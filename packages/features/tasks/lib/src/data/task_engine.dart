import 'dart:async';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';
import '../domain/task_record.dart';
import '../domain/i_task_repository.dart';
import 'task_data_source.dart';

/// The Submerged Engine: Dual-track synchronization between Local Drift and Remote Cloud.
/// This engine fulfills the "Stale-While-Revalidate" pattern by booting from local cache
/// and refreshing from the cloud in the background.
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

  // In-flight guard against rapid re-entrant toggles (DRY core primitive)
  final _guard = MutationGuard<String>();

  // Private Reactive Graph with structural sharing and single-pass optimization
  late final StreamSignal<List<Task>> _localStreamSignal;
  final _optimisticPatches = signal<IMap<String, TaskPatch>>(IMap());
  final _optimisticCreations = signal<IList<Task>>(IList());
  final _hasSyncError = signal<bool>(false);
  late final Computed<List<Task>> _computedTasks;
  late final StreamSubscription<List<Task>> _remoteSyncSubscription;

  void _initEngine() {
    _localStreamSignal = streamSignal(() => _localDataSource.taskStream);

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
          ));
        } else {
          reconciled.add(task);
        }
      }

      // Filter out creations that have already materialized in the local stream
      final uniqueCreations = creations.where((t) => !localIds.contains(t.id));

      return reconciled + uniqueCreations.toList();
    });
  }

  @override
  ReadonlySignal<List<Task>> get tasks => _computedTasks;

  @override
  ReadonlySignal<bool> get hasSyncError => _hasSyncError;

  @override
  ReadonlySignal<bool> get isBusy => _guard.busySignal;

  @override
  ReadonlySignal<ISet<String>> get activeTaskIds => _guard.activeKeys;

  @override
  Future<void> createTask(String title) async {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final task = (
      id: tempId,
      title: title,
      isCompleted: false,
      tags: const IListConst<String>([]),
      createdAt: DateTime.now(),
    );

    await (() async {
      _optimisticCreations.value = _optimisticCreations.value.add(task);

      try {
        await _localDataSource.createTask(task);
        await _remoteDataSource.createTask(task);

        batch(() {
          _hasSyncError.value = false;
          _optimisticCreations.value = _optimisticCreations.value.remove(task);
        });
      } catch (error, stackTrace) {
        batch(() {
          _optimisticCreations.value = _optimisticCreations.value.remove(task);
          _hasSyncError.value = true;
        });
        Error.throwWithStackTrace(
          SyncRollbackException('Failed to create task. Reverted.', error),
          stackTrace,
        );
      }
    }).guardedBy(_guard, task.id); // Use task.id instead of a global string to allow parallel creations
  }

  @override
  Future<void> updateTaskTitle(String id, String newTitle) async {
    await (() async {
      final oldPatch = _optimisticPatches.value[id];
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: newTitle,
        isCompleted: oldPatch?.isCompleted,
        tags: oldPatch?.tags,
        isDeleted: oldPatch?.isDeleted,
      ));

      try {
        await _localDataSource.updateTaskTitle(id, newTitle);
        await _remoteDataSource.updateTaskTitle(id, newTitle);

        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error, stackTrace) {
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
        Error.throwWithStackTrace(
          SyncRollbackException('Failed to update task title. Reverted.', error),
          stackTrace,
        );
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> addTag(String id, String tag) async {
    await (() async {
      final currentTask = _computedTasks.value.firstWhere((t) => t.id == id);
      if (currentTask.tags.contains(tag)) return;
      
      final nextTags = currentTask.tags.add(tag);
      final oldPatch = _optimisticPatches.value[id];
      
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: oldPatch?.title,
        isCompleted: oldPatch?.isCompleted,
        tags: nextTags,
        isDeleted: oldPatch?.isDeleted,
      ));

      try {
        await _localDataSource.updateTaskTags(id, nextTags);
        await _remoteDataSource.updateTaskTags(id, nextTags);

        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error, stackTrace) {
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
        Error.throwWithStackTrace(
          SyncRollbackException('Failed to add tag. Reverted.', error),
          stackTrace,
        );
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> removeTag(String id, String tag) async {
    await (() async {
      final currentTask = _computedTasks.value.firstWhere((t) => t.id == id);
      if (!currentTask.tags.contains(tag)) return;
      
      final nextTags = currentTask.tags.remove(tag);
      final oldPatch = _optimisticPatches.value[id];
      
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: oldPatch?.title,
        isCompleted: oldPatch?.isCompleted,
        tags: nextTags,
        isDeleted: oldPatch?.isDeleted,
      ));

      try {
        await _localDataSource.updateTaskTags(id, nextTags);
        await _remoteDataSource.updateTaskTags(id, nextTags);

        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error, stackTrace) {
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
        Error.throwWithStackTrace(
          SyncRollbackException('Failed to remove tag. Reverted.', error),
          stackTrace,
        );
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> toggleTask(String id, bool currentStatus) async {
    final newStatus = !currentStatus;

    await (() async {
      final oldPatch = _optimisticPatches.value[id];
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: oldPatch?.title,
        isCompleted: newStatus,
        tags: oldPatch?.tags,
        isDeleted: oldPatch?.isDeleted,
      ));

      try {
        await _localDataSource.updateTask(id, newStatus);
        await _remoteDataSource.updateTask(id, newStatus);

        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error, stackTrace) {
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
        Error.throwWithStackTrace(
          SyncRollbackException('Failed to update task $id. Reverted.', error),
          stackTrace,
        );
      }
    }).guardedBy(_guard, id);
  }

  @override
  Future<void> deleteTask(String id) async {
    await (() async {
      final oldPatch = _optimisticPatches.value[id];
      _optimisticPatches.value = _optimisticPatches.value.add(id, (
        title: oldPatch?.title,
        isCompleted: oldPatch?.isCompleted,
        tags: oldPatch?.tags,
        isDeleted: true,
      ));

      try {
        await _localDataSource.deleteTask(id);
        await _remoteDataSource.deleteTask(id);

        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error, stackTrace) {
        batch(() {
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
          _hasSyncError.value = true;
        });
        Error.throwWithStackTrace(
          SyncRollbackException('Failed to delete task $id. Reverted.', error),
          stackTrace,
        );
      }
    }).guardedBy(_guard, id);
  }

  @override
  void dispose() {
    _remoteSyncSubscription.cancel();
    _guard.clear();
    _localStreamSignal.dispose();
    _optimisticPatches.dispose();
    _optimisticCreations.dispose();
    _hasSyncError.dispose();
    _computedTasks.dispose();
  }
}
