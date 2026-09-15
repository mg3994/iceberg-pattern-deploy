import '../domain/task_record.dart';

/// Tier 1 Datastore Contract: Handles raw data stream access and cloud/DB mutations.
abstract interface class TaskDataSource {
  /// Stream providing raw real-time data entries.
  Stream<List<Task>> get taskStream;

  /// Sends a raw mutation update over the wire.
  Future<void> updateTask(String id, bool isCompleted);

  /// Sends a raw deletion command over the wire.
  Future<void> deleteTask(String id);
}
