import 'dart:async';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';
import '../domain/task_record.dart';
import '../domain/i_task_repository.dart';
import 'task_data_source.dart';

/// The Submerged Engine: Quarantines raw asynchronous cloud streams into a
/// synchronous, cached reactive graph and handles optimistic reconciliation.
class TaskRepository implements ITaskRepository {
  final TaskDataSource _dataSource;

  TaskRepository({
    required TaskDataSource dataSource,
    List<Task> initialTasks = const [],
  }) : _dataSource = dataSource {
    _initEngine(initialTasks);
  }

  // In-flight guard against rapid re-entrant toggles (DRY core primitive)
  final _guard = MutationGuard<String>();

  // Private Reactive Graph with structural sharing
  late final StreamSignal<List<Task>> _cloudStreamSignal;
  final _optimisticPatches = signal<IMap<String, bool>>(IMap());
  final _optimisticDeletions = signal<ISet<String>>(ISet());
  final _hasSyncError = signal<bool>(false);
  late final Computed<List<Task>> _computedTasks;

  void _initEngine(List<Task> initialTasks) {
    _cloudStreamSignal = streamSignal(
      () => _dataSource.taskStream,
      options: AsyncSignalOptions<List<Task>>(initialValue: initialTasks),
    );

    _computedTasks = computed(() {
      final baseTasks = _cloudStreamSignal.value.value ?? const [];
      final overrides = _optimisticPatches.value;
      final deletions = _optimisticDeletions.value;

      if (overrides.isEmpty && deletions.isEmpty) return baseTasks;

      // Single-pass reconciliation loop for O(N) memory efficiency
      return baseTasks.where((t) => !deletions.contains(t.id)).map((task) {
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

  /// OPTIMISTIC MUTATION: Updates state across all screens in 0ms, synchronizes with cloud in background.
  @override
  Future<void> toggleTask(String id, bool currentStatus) async {
    final newStatus = !currentStatus;

    await (() async {
      _optimisticPatches.value = _optimisticPatches.value.add(id, newStatus);

      try {
        await _dataSource.updateTask(id, newStatus);
        // Reconcile atomically
        batch(() {
          _hasSyncError.value = false;
          _optimisticPatches.value = _optimisticPatches.value.remove(id);
        });
      } catch (error, stackTrace) {
        // Rollback atomically
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

  /// OPTIMISTIC MUTATION: Hides item instantly, synchronizes with cloud in background.
  @override
  Future<void> deleteTask(String id) async {
    await (() async {
      _optimisticDeletions.value = _optimisticDeletions.value.add(id);

      try {
        await _dataSource.deleteTask(id);
        // Reconcile atomically
        batch(() {
          _hasSyncError.value = false;
          _optimisticDeletions.value = _optimisticDeletions.value.remove(id);
        });
      } catch (error, stackTrace) {
        // Rollback atomically
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
    _guard.clear();
    _cloudStreamSignal.dispose();
    _optimisticPatches.dispose();
    _optimisticDeletions.dispose();
    _hasSyncError.dispose();
    _computedTasks.dispose();
  }
}
