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
      for (final task in localTasks) {
        final patch = patches[task.id];
        
        // Skip items marked for deletion
        if (patch?.isDeleted ?? false) continue;

        if (patch != null) {
          reconciled.add((
            id: task.id,
            title: patch.title ?? task.title,
            isCompleted: patch.isCompleted ?? task.isCompleted,
            tags: patch.tags ?? task.tags,
          ));
        } else {
          reconciled.add(task);
        }
      }

      return reconciled + creations.toList();
    });
  }

  @override
  ReadonlySignal<List<Task>> get tasks => _computedTasks;

  @override
  ReadonlySignal<bool> get hasSyncError => _hasSyncError;

  @override
  ReadonlySignal<bool> get isBusy => _guard.busySignal;

  @override
  Future<void> createTask(String title) async {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final task = (
      id: tempId,
      title: title,
      isCompleted: false,
      tags: const IListConst<String>([]),
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
    }).guardedBy(_guard, 'create_task');
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
