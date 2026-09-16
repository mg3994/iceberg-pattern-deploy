import 'package:drift/drift.dart';

/// Database Record definition mirroring raw table data layout parameters cleanly.
typedef TaskDbData = ({
  String id,
  String title,
  bool isCompleted,
  String serializedTags,
  DateTime createdAt,
  int syncStatus,
  String? lastError,
});

/// Feature-Sealed Contract governing relational data access operations without exposing internal mechanics.
abstract interface class TasksDao {
  /// Stream providing typed relational task database rows.
  Stream<List<TaskDbData>> watchAllTasks();

  /// Fetches all tasks that are not yet synchronized.
  Future<List<TaskDbData>> getUnsyncedTasks();

  /// Inserts a new task record.
  Future<void> insertTask(TaskDbData task);

  /// Updates a task record status and sync metadata.
  Future<void> updateTaskStatus(String id, bool isCompleted, int syncStatus, [String? error]);

  /// Updates a task title and sync metadata.
  Future<void> updateTaskTitle(String id, String newTitle, int syncStatus, [String? error]);

  /// Updates task tags and sync metadata.
  Future<void> updateTaskTags(String id, String serializedTags, int syncStatus, [String? error]);

  /// Evicts a task row using explicit key parameters.
  Future<void> deleteCloudTaskRow(String id);

  /// Bulk upserts tasks into the local database (Synchronizes Cloud -> Local).
  Future<void> upsertTasks(List<TaskDbData> tasks);

  /// Atomically replaces all tasks in the local database with the provided snapshot.
  Future<void> replaceTableContent(List<TaskDbData> tasks);
}
