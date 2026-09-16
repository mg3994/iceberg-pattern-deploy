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
  TaskRepository({
    required RemoteTaskDataSource remoteDataSource,
    required LocalTaskDataSource localDataSource,
    required ConnectivityService connectivity,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivity = connectivity {
    _initEngine();
  }

  final RemoteTaskDataSource _remoteDataSource;
  final LocalTaskDataSource _localDataSource;
  final ConnectivityService _connectivity;

  // In-flight guard against rapid re-entrant toggles
  final _guard = MutationGuard<String>();

  // Private Reactive Graph with persistent intent and single-pass optimization
  late final StreamSignal<List<Task>> _localStreamSignal;
  final _optimisticPatches = signal<IMap<String, TaskPatch>>(IMap());
  final _optimisticCreations = signal<IList<Task>>(IList());
  final _hasSyncError = signal<bool>(false);
  late final Computed<List<Task>> _computedTasks;
  late final StreamSubscription<List<Task>> _remoteSyncSubscription;
  late final void Function() _disposables;
  
  Timer? _syncQueueTimer;

  void _initEngine() {
    _localStreamSignal = streamSignal(() => _localDataSource.taskStream);

    // Initial background sync from cloud truth
    _remoteSyncSubscription = _remoteDataSource.taskStream.listen((remoteTasks) {
      _localDataSource.syncRemoteData(remoteTasks);
    });

    _computedTasks = computed(() {
      final localTasks = _localStreamSignal.value.value ?? const [];
      final patches = _optimisticPatches.value;
      final creations = _optimisticCreations.value;

      if (patches.isEmpty && creations.isEmpty) return localTasks;

      // High-performance single-pass reconciliation via for-in loop (Best for Memory/GC)
      final reconciled = <Task>[];
      final localIds = <String>{};
      for (final task in localTasks) {
        localIds.add(task.id);
        final patch = patches[task.id];
        
        // Skip items marked for deletion
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

      // Filter out creations that have already materialized in the local stream
      final uniqueCreations = creations.where((t) => !localIds.contains(t.id));

      return reconciled + uniqueCreations.toList();
    });

    // 🌊 PATCH GARBAGE COLLECTOR: Eliminates UI Flicker
    // Automatically removes optimistic patches once they are acknowledged (ACKed) by the local stream.
    final gcEffect = effect(() {
      final localTasks = _localStreamSignal.value.value;
      if (localTasks == null) return;

      final patches = _optimisticPatches.value;
      if (patches.isEmpty) return;

      final localMap = {for (var t in localTasks) t.id: t};
      Map<String, TaskPatch>? updatedMap;
        
      for (final entry in patches.entries) {
        final id = entry.key;
        final patch = entry.value;
        final localTask = localMap[id];

        bool isAcked = false;
        if (patch.isDeleted == true) {
          isAcked = localTask == null;
        } else {
          if (localTask != null) {
            final matchesTitle = patch.title == null || localTask.title == patch.title;
            final matchesStatus = patch.isCompleted == null || localTask.isCompleted == patch.isCompleted;
            final matchesTags = patch.tags == null || localTask.tags == patch.tags;
            isAcked = matchesTitle && matchesStatus && matchesTags;
          }
        }

        if (isAcked) {
          updatedMap ??= Map.from(patches.unlock);
          updatedMap.remove(id);
        }
      }

      if (updatedMap != null) {
        _optimisticPatches.value = updatedMap.lock;
      }
    });

    // Connectivity-aware sync orchestration
    final connEffect = effect(() {
      final isOnline = _connectivity.status.value == ConnectivityStatus.online;
      
      if (isOnline) {
        // Start worker when online
        _syncQueueTimer?.cancel();
        _syncQueueTimer = Timer.periodic(const Duration(seconds: 10), (_) => _processSyncQueue());
        unawaited(_processSyncQueue());
      } else {
        // Stop worker when offline to save battery/resources
        _syncQueueTimer?.cancel();
        _syncQueueTimer = null;
      }
    });

    _disposables = () {
      gcEffect();
      connEffect();
    };
  }

  @override
  ReadonlySignal<List<Task>> get tasks => _computedTasks;

  @override
  ReadonlySignal<bool> get hasSyncError => _hasSyncError;

  @override
  ReadonlySignal<bool> get isBusy => _guard.busySignal;

  @override
  ReadonlySignal<bool> get isOnline => computed(() => _connectivity.status.value == ConnectivityStatus.online);

  @override
  ReadonlySignal<ISet<String>> get activeTaskIds => _guard.activeKeys;

  @override
  Future<void> triggerSyncManual() => _processSyncQueue();

  /// Background Worker: Scans Drift intent log and attempts cloud reconciliation.
  Future<void> _processSyncQueue() async {
    if (_connectivity.status.value == ConnectivityStatus.offline) return;

    final unsynced = await _localDataSource.getUnsyncedTasks();
    if (unsynced.isEmpty) return;

    for (final task in unsynced) {
      if (task.syncStatus == TaskSyncStatus.pending || task.syncStatus == TaskSyncStatus.error) {
        unawaited(_reconcileTaskWithCloud(task));
      }
    }
  }

  Future<void> _reconcileTaskWithCloud(Task task) async {
    await _guard.run(task.id, () async {
      try {
        await _remoteDataSource.createTask(task);
        await _localDataSource.updateTask(task.id, task.isCompleted, TaskSyncStatus.synced);
      } catch (e) {
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
      _optimisticCreations.value = _optimisticCreations.value.add(task);

      try {
        await _localDataSource.createTask(task);
        _optimisticCreations.value = _optimisticCreations.value.remove(task);

        if (_connectivity.isOnline) {
          await _remoteDataSource.createTask(task);
          await _localDataSource.updateTask(task.id, false, TaskSyncStatus.synced);
          batch(() => _hasSyncError.value = false);
        }
      } catch (error, stackTrace) {
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
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: newTitle,
        isCompleted: null,
        tags: null,
        isDeleted: null,
      ));

      try {
        await _localDataSource.updateTaskTitle(id, newTitle, TaskSyncStatus.pending);
        
        if (_connectivity.isOnline) {
          await _remoteDataSource.updateTaskTitle(id, newTitle);
          await _localDataSource.updateTaskTitle(id, newTitle, TaskSyncStatus.synced);
          batch(() => _hasSyncError.value = false);
        }
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
        
        if (_connectivity.isOnline) {
          await _remoteDataSource.updateTaskTags(id, nextTags);
          await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.synced);
          batch(() => _hasSyncError.value = false);
        }
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

        if (_connectivity.isOnline) {
          await _remoteDataSource.updateTaskTags(id, nextTags);
          await _localDataSource.updateTaskTags(id, nextTags, TaskSyncStatus.synced);
          batch(() => _hasSyncError.value = false);
        }
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

        if (_connectivity.isOnline) {
          await _remoteDataSource.updateTask(id, newStatus);
          await _localDataSource.updateTask(id, newStatus, TaskSyncStatus.synced);
          batch(() => _hasSyncError.value = false);
        }
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
        if (_connectivity.isOnline) {
          await _remoteDataSource.deleteTask(id);
        }
        await _localDataSource.deleteTask(id);
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
    _disposables();
    _guard.clear();
    _localStreamSignal.dispose();
    _optimisticPatches.dispose();
    _optimisticCreations.dispose();
    _hasSyncError.dispose();
    _computedTasks.dispose();
  }
}
