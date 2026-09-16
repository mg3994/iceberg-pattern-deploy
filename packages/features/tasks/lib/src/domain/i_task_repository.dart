import 'package:signals_core/signals_core.dart';
import 'task_record.dart';

/// Dependency Inversion Anchor: Contract governing facade interaction parameters.
abstract interface class ITaskRepository {
  /// Public readonly signaling stream.
  ReadonlySignal<List<Task>> get tasks;

  /// Signal flagging synchronization exceptions.
  ReadonlySignal<bool> get hasSyncError;

  /// Signal indicating if any mutation is in-flight.
  ReadonlySignal<bool> get isBusy;

  /// Appends a new task using the optimistic track.
  Future<void> createTask(String title);

  /// Updates a task title using the optimistic track.
  Future<void> updateTaskTitle(String id, String newTitle);

  /// Adds a tag to a task using the optimistic track.
  Future<void> addTag(String id, String tag);

  /// Removes a tag from a task using the optimistic track.
  Future<void> removeTag(String id, String tag);

  /// Triggers an optimistic state switch for task completion.
  Future<void> toggleTask(String id, bool currentStatus);

  /// Triggers an optimistic item eviction.
  Future<void> deleteTask(String id);

  /// Disposes active stream dependencies.
  void dispose();
}
