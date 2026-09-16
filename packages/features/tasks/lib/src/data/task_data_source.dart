import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import '../domain/task_record.dart';

/// Tier 1 Remote Datastore Contract: Handles raw cloud synchronization.
abstract interface class RemoteTaskDataSource {
  /// Stream providing raw real-time data entries from the cloud.
  Stream<List<Task>> get taskStream;

  /// Sends a raw creation update over the wire.
  Future<void> createTask(Task task);

  /// Sends a raw mutation update for task completion status.
  Future<void> updateTask(String id, bool isCompleted);

  /// Sends a raw mutation update for task title.
  Future<void> updateTaskTitle(String id, String newTitle);

  /// Sends a raw mutation update for task tags.
  Future<void> updateTaskTags(String id, IList<String> tags);

  /// Sends a raw deletion command over the wire.
  Future<void> deleteTask(String id);
}

/// Tier 1 Local Datastore Contract: Handles relational persistence mapping.
abstract interface class LocalTaskDataSource {
  /// Stream providing raw real-time data entries from the local DB.
  Stream<List<Task>> get taskStream;

  /// Fetches tasks that need synchronization.
  Future<List<Task>> getUnsyncedTasks();

  /// Inserts a task record locally.
  Future<void> createTask(Task task);

  /// Updates a task record status locally.
  Future<void> updateTask(String id, bool isCompleted, [TaskSyncStatus status, String? error]);

  /// Updates a task title locally.
  Future<void> updateTaskTitle(String id, String newTitle, [TaskSyncStatus status, String? error]);

  /// Updates task tags locally.
  Future<void> updateTaskTags(String id, IList<String> tags, [TaskSyncStatus status, String? error]);

  /// Deletes a task record locally.
  Future<void> deleteTask(String id);

  /// Bulk synchronizes remote data into the local cache.
  Future<void> syncRemoteData(List<Task> remoteTasks);
}
