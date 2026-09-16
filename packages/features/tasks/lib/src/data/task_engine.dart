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

  // Private Reactive Graph with structural sharing
  late final StreamSignal<List<Task>> _localStreamSignal;
  final _optimisticPatches = signal<IMap<String, bool>>(IMap());
  final _optimisticDeletions = signal<ISet<String>>(ISet());
  final _hasSyncError = signal<bool>(false);
  late final Computed<List<Task>> _computedTasks;
  late final StreamSubscription<List<Task>> _remoteSyncSubscription;

  void _initEngine() {
    // 1. Primary Ingress: Listen to the Local Database (Frame 0 Boot)
    _localStreamSignal = streamSignal(
      () => _localDataSource.taskStream,
    );

    // 2. Background Sync: Listen to Remote Cloud and pipe into Local DB
    _remoteSyncSubscription = _remoteDataSource.taskStream.listen((remoteTasks) {
      _localDataSource.syncRemoteData(remoteTasks);
    });

    // 3. Unified Projection: Merge Local Stream + In-flight Patches + In-flight Deletions
    _computedTasks = computed(() {
      final localTasks = _localStreamSignal.value.value ?? const [];
      final overrides = _optimisticPatches.value;
      final deletions = _optimisticDeletions.value;

      if (overrides.isEmpty && deletions.isEmpty) return localTasks;

      return localTasks.where((t) => !deletions.contains(t.id)).map((task) {
        final patch = overrides[task.id];
        return patch != null
            ? (
                id: task.id,
                title: task.title,
                isCompleted: patch,
                tags: task.tags,
              )
            : task;
      }).toList();
    });
  }

  // Public Readonly Boundary satisfying ITaskRepository
  @override
  ReadonlySignal<List<Task>> get tasks => _computedTasks;

  @override
  ReadonlySignal<bool> get hasSyncError => _hasSyncError;

  @override
  ReadonlySignal<bool> get isBusy => _guard.busySignal;

  /// DUAL-TRACK MUTATION: Updates Local DB instantly, synchronizes with Cloud in background.
  @override
  Future<void> toggleTask(String id, bool currentStatus) async {
    final newStatus = !currentStatus;

    await (() async {
      // Step A: Update memory patch (0ms track)
      _optimisticPatches.value = _optimisticPatches.value.add(id, newStatus);

      try {
        // Step B: Update Local Persistence
        await _localDataSource.updateTask(id, newStatus);

        // Step C: Update Remote Cloud
        await _remoteDataSource.updateTask(id, newStatus);

        // Reconcile atomically on success
        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error, stackTrace) {
        // Rollback on failure
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

  /// DUAL-TRACK MUTATION: Hides item locally, deletes remotely in background.
  @override
  Future<void> deleteTask(String id) async {
    await (() async {
      // Step A: Update memory deletion set (0ms track)
      _optimisticDeletions.value = _optimisticDeletions.value.add(id);

      try {
        // Step B: Update Local Persistence
        await _localDataSource.deleteTask(id);

        // Step C: Update Remote Cloud
        await _remoteDataSource.deleteTask(id);

        // Reconcile atomically on success
        batch(() {
          _hasSyncError.value = false;
          _optimisticDeletions.value = _optimisticDeletions.value.remove(id);
        });
      } catch (error, stackTrace) {
        // Rollback on failure (item reappears)
        batch(() {
          _optimisticDeletions.value = _optimisticDeletions.value.remove(id);
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
    _optimisticDeletions.dispose();
    _hasSyncError.dispose();
    _computedTasks.dispose();
  }
}
