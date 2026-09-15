import 'package:signals_core/signals_core.dart';
import 'task_record.dart';

/// Dependency Inversion Anchor: Contract governing facade interaction parameters.
abstract interface class ITaskRepository {
  /// Public readonly signaling stream.
  ReadonlySignal<List<Task>> get tasks;

  /// Signal flagging synchronization exceptions.
  ReadonlySignal<bool> get hasSyncError;

  /// Triggers an optimistic state switch.
  Future<void> toggleTask(String id, bool currentStatus);

  /// Triggers a pessimistic item eviction.
  Future<void> deleteTask(String id);

  /// Disposes active stream dependencies.
  void dispose();
}
