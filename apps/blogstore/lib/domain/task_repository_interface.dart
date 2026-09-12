import 'package:signals_core/signals_core.dart';
import 'task.dart';

/// Clean Domain Repository Interface adhering to the Dependency Inversion Principle (DIP).
abstract class ITaskRepository {
  /// Readonly signal of current task snapshot list
  ReadonlySignal<List<Task>> get tasks;

  /// Readonly signal indicating if a sync/network error occurred during background reconciliation
  ReadonlySignal<bool> get hasSyncError;

  /// Optimistically toggles completion status for task with [id]
  Future<void> toggleTask(String id, bool currentStatus);

  /// Pessimistically deletes task with [id]
  Future<void> deleteTask(String id);

  /// Releases reactive resources
  void dispose();
}
