import 'package:drift/drift.dart';

/// Database Record definition mirroring raw table data layout parameters cleanly.
typedef TaskDbData = ({
  String id,
  String title,
  bool isCompleted,
  String serializedTags,
});

/// Feature-Sealed Contract governing relational data access operations without exposing internal mechanics.
abstract interface class TasksDao {
  /// Stream providing typed relational task database rows.
  Stream<List<TaskDbData>> watchAllTasks();

  /// Updates a task record status using strict compile-time types.
  Future<void> updateTaskStatus(String id, bool isCompleted);

  /// Evicts a task row using explicit key parameters.
  Future<void> deleteCloudTaskRow(String id);
}
