import '../domain/task_record.dart';

/// Tier 1 Remote Datastore Contract: Handles raw cloud synchronization.
abstract interface class RemoteTaskDataSource {
  /// Stream providing raw real-time data entries from the cloud.
  Stream<List<Task>> get taskStream;

  /// Sends a raw mutation update over the wire.
  Future<void> updateTask(String id, bool isCompleted);

  /// Sends a raw deletion command over the wire.
  Future<void> deleteTask(String id);
}

/// Tier 1 Local Datastore Contract: Handles relational persistence mapping.
abstract interface class LocalTaskDataSource {
  /// Stream providing raw real-time data entries from the local DB.
  Stream<List<Task>> get taskStream;

  /// Updates a task record status locally.
  Future<void> updateTask(String id, bool isCompleted);

  /// Deletes a task record locally.
  Future<void> deleteTask(String id);

  /// Bulk synchronizes remote data into the local cache.
  Future<void> syncRemoteData(List<Task> remoteTasks);
}
