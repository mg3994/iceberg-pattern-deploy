import 'dart:async';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';
import '../domain/task_record.dart';
import '../domain/i_task_repository.dart';
import 'task_data_source.dart';

/// The Submerged Engine: High-availability dual-track synchronization.
/// Uses the local database as a persistent intent log to survive app restarts.
class TaskRepository implements ITaskRepository {
  final RemoteTaskDataSource _remoteDataSource;
  final LocalTaskDataSource _localDataSource;

  TaskRepository({
    required RemoteTaskDataSource remoteDataSource,
    required LocalTaskDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource {
    _initEngine();
  }

  // In-flight guard against rapid re-entrant toggles
  final _guard = MutationGuard<String>();

  // Private Reactive Graph with persistent intent and single-pass optimization
  late final StreamSignal<List<Task>> _localStreamSignal;
  final _optimisticPatches = signal<IMap<String, TaskPatch>>(IMap());
  final _optimisticCreations = signal<IList<Task>>(IList());
  final _hasSyncError = signal<bool>(false);
  late final Computed<List<Task>> _computedTasks;
  late final StreamSubscription<List<Task>> _remoteSyncSubscription;
  
  Timer? _syncQueueTimer;

  void _initEngine() {
    _localStreamSignal = streamSignal(() => _localDataSource.taskStream);

    // Initial background sync
    _remoteSyncSubscription = _remoteDataSource.taskStream.listen((remoteTasks) {
      _localDataSource.syncRemoteData(remoteTasks);
    });

    _computedTasks = computed(() {
      final localTasks = _localStreamSignal.value.value ?? const [];
      final patches = _optimisticPatches.value;
      final creations = _optimisticCreations.value;

      if (patches.isEmpty && creations.isEmpty) return localTasks;

      final reconciled = <Task>[];
      final localIds = <String>{};
      for (final task in localTasks) {
        localIds.add(task.id);
        final patch = patches[task.id];
        
        if (patch?.isDeleted ?? false) continue;

        if (patch != null) {
          reconciled.add((
            id: task.id,
            title: patch.title ?? task.title,
            isCompleted: patch.isCompleted ?? task.isCompleted,
            tags: patch.tags ?? task.tags,
            createdAt: task.createdAt,
            syncStatus: TaskSyncStatus.pending, // Force pending during memory patch flash
            lastErrorMessage: null,
          ));
        } else {
          reconciled.add(task);
        }
      }

      final uniqueCreations = creations.where((t) => !localIds.contains(t.id));
      return reconciled + uniqueCreations.toList();
    });

    // Start background worker to process unsynced intent log
    _syncQueueTimer = Timer.periodic(const Duration(seconds: 5), (_) => _processSyncQueue());
    _processSyncQueue(); // Run immediately on boot
  }

  @override
  ReadonlySignal<List<Task>> get tasks => _computedTasks;

  @override
  ReadonlySignal<bool> get hasSyncError => _hasSyncError;

  @override
  ReadonlySignal<bool> get isBusy => _guard.busySignal;

  @override
  ReadonlySignal<ISet<String>> get activeTaskIds => _guard.activeKeys;

  /// Background Worker: Scans Drift intent log and attempts cloud reconciliation.
  Future<void> _processSyncQueue() async {
    final unsynced = await _localDataSource.getUnsyncedTasks();
    if (unsynced.isEmpty) return;

    for (final task in unsynced) {
      // Re-trigger the appropriate sync track based on item status
      if (task.syncStatus == TaskSyncStatus.pending || task.syncStatus == TaskSyncStatus.error) {
        unawaited(_reconcileTaskWithCloud(task));
      }
    }
  }

  Future<void> _reconcileTaskWithCloud(Task task) async {
    await _guard.run(task.id, () async {
      try {
        // Attempt Cloud Write
        await _remoteDataSource.createTask(task); // Remote createTask should handle upsert
        
        // Success: Clear intent log locally
        await _localDataSource.updateTask(task.id, task.isCompleted, TaskSyncStatus.synced);
      } catch (e) {
        // Failure: Flag in Drift for future retry
        await _localDataSource.updateTask(task.id, task.isCompleted, TaskSyncStatus.error, e.toString());
        batch(() => _hasSyncError.value = true);
      }
    });
  }

  @override
  Future<void> createTask(String title) async {
    final task = (
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      isCompleted: false,
      tags: const IListConst<String>([]),
      createdAt: DateTime.now(),
      syncStatus: TaskSyncStatus.pending,
      lastErrorMessage: null,
    );

    await (() async {
      // 1. Memory Flash (0ms)
      _optimisticCreations.value = _optimisticCreations.value.add(task);

      try {
        // 2. Persistent Intent Log (Drift)
        await _localDataSource.createTask(task);
        
        // 3. Clear memory flash immediately as Drift stream will now carry the 'pending' task
        _optimisticCreations.value = _optimisticCreations.value.remove(task);

        // 4. Trigger Cloud Sync
        await _remoteDataSource.createTask(task);

        // 5. Success: Mark Synced in DB
        await _localDataSource.updateTask(task.id, false, TaskSyncStatus.synced);
        batch(() => _hasSyncError.value = false);
      } catch (error, stackTrace) {
        // 6. Network Failure: Keep in DB as 'error' for background retry
        await _localDataSource.updateTask(task.id, false, TaskSyncStatus.error, error.toString());
        batch(() {
          _optimisticCreations.value = _optimisticCreations.value.remove(task);
          _hasSyncError.value = true;
        });
        Error.throwWithStackTrace(SyncRollbackException('Create failed. Logged for retry.', error), stackTrace);
      }
    }).guardedBy(_guard, task.id);
  }

  @override
  Future<void> updateTaskTitle(String id, String newTitle) async {
    await (() async {
      // 1. Memory Flash
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: newTitle,
        isCompleted: null,
        tags: null,
        isDeleted: null,
      ));

      try {
        // 2. Intent Log
        await _localDataSource.updateTaskTitle(id, newTitle, TaskSyncStatus.pending);
        _optimisticPatches.value = _optimisticPatches.value.remove(id);

        // 3. Cloud Sync
        await _remoteDataSource.updateTaskTitle(id, newTitle);

        // 4. Finalize
        await _localDataSource.updateTaskTitle(id, newTitle, TaskSyncStatus.synced);
        batch(() => _hasSyncError.value = false);
      } catch (error) {
        await _localDataSource.updateTaskTitle(id, newTitle, TaskSyncStatus.error, error.toString());
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> addTag(String id, String tag) async {
    await (() async {
      final currentTask = _computedTasks.value.firstWhere((t) => t.id == id);
      final nextTags = currentTask.tags.add(tag);

      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: null,
        isCompleted: null,
        tags: nextTags,
        isDeleted: null,
      ));

      try {
        await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.pending);
        _optimisticPatches.value = _optimisticPatches.value.remove(id);

        await _remoteDataSource.updateTaskTags(id, nextTags);

        await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.synced);
        batch(() => _hasSyncError.value = false);
      } catch (error) {
        await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.error, error.toString());
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> removeTag(String id, String tag) async {
    await (() async {
      final currentTask = _computedTasks.value.firstWhere((t) => t.id == id);
      final nextTags = currentTask.tags.remove(tag);

      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: null,
        isCompleted: null,
        tags: nextTags,
        isDeleted: null,
      ));

      try {
        await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.pending);
        _optimisticPatches.value = _optimisticPatches.value.remove(id);

        await _remoteDataSource.updateTaskTags(id, nextTags);

        await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.synced);
        batch(() => _hasSyncError.value = false);
      } catch (error) {
        await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.error, error.toString());
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> toggleTask(String id, bool currentStatus) async {
    final newStatus = !currentStatus;

    await (() async {
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: null,
        isCompleted: newStatus,
        tags: null,
        isDeleted: null,
      ));

      try {
        await _localDataSource.updateTask(id, newStatus, TaskSyncStatus.pending);
        _optimisticPatches.value = _optimisticPatches.value.remove(id);

        await _remoteDataSource.updateTask(id, newStatus);

        await _localDataSource.updateTask(id, newStatus, TaskSyncStatus.synced);
        batch(() => _hasSyncError.value = false);
      } catch (error) {
        await _localDataSource.updateTask(id, newStatus, TaskSyncStatus.error, error.toString());
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> deleteTask(String id) async {
    await (() async {
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: null,
        isCompleted: null,
        tags: null,
        isDeleted: true,
      ));

      try {
        // For deletion, we don't have an 'error' state in DB typically, 
        // we either delete or we don't. We'll mark as pending/error if we wanted persistent delete retry,
        // but for now we'll just attempt background deletion.
        await _remoteDataSource.deleteTask(id);
        await _localDataSource.deleteTask(id);

        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error) {
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
      }
    }).guardedBy(_guard, id);
  }

  @override
  void dispose() {
    _syncQueueTimer?.cancel();
    _remoteSyncSubscription.cancel();
    _guard.clear();
    _localStreamSignal.dispose();
    _optimisticPatches.dispose();
    _optimisticCreations.dispose();
    _hasSyncError.dispose();
    _computedTasks.dispose();
  }
}
