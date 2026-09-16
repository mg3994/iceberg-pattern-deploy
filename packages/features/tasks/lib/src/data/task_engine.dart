import 'dart:async';
import 'package:core/core.dart';
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

  // Private Reactive Graph
  late final StreamSignal<List<Task>> _cloudStreamSignal;
  final _optimisticPatches = signal<Map<String, bool>>({});
  final _optimisticDeletions = signal<Set<String>>({});
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

      return baseTasks
          .where((t) => !deletions.contains(t.id))
          .map((task) {
        final override = overrides[task.id];
        return override != null
            ? (
                id: task.id,
                title: task.title,
                isCompleted: override,
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
      _optimisticPatches.value = {..._optimisticPatches.value, id: newStatus};

      try {
        await _dataSource.updateTask(id, newStatus);
        // Reconcile atomically using batch(): clear override and clear sync error
        batch(() {
          _hasSyncError.value = false;
          final updated = Map<String, bool>.from(_optimisticPatches.value)..remove(id);
          _optimisticPatches.value = updated;
        });
      } catch (error, stackTrace) {
        // Rollback atomically using batch(): silently revert override and set sync error
        batch(() {
          final updated = Map<String, bool>.from(_optimisticPatches.value)..remove(id);
          _optimisticPatches.value = updated;
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
      _optimisticDeletions.value = {..._optimisticDeletions.value, id};

      try {
        await _dataSource.deleteTask(id);
        // Reconcile atomically
        batch(() {
          _hasSyncError.value = false;
          final updated = Set<String>.from(_optimisticDeletions.value)..remove(id);
          _optimisticDeletions.value = updated;
        });
      } catch (error, stackTrace) {
        // Rollback atomically: show item again
        batch(() {
          final updated = Set<String>.from(_optimisticDeletions.value)..remove(id);
          _optimisticDeletions.value = updated;
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
