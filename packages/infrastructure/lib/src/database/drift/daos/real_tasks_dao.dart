import 'package:drift/drift.dart';
import 'package:tasks/tasks.dart' show TasksDao, TaskDbData;
import '../app_database.dart';

/// Relational storage realization implementing the clean typed TasksDao contract.
class RealTasksDao implements TasksDao {
  final AppDatabase _db;

  RealTasksDao({
    required AppDatabase database,
  }) : _db = database;

  @override
  Stream<List<TaskDbData>> watchAllTasks() {
    return _db.select(_db.tasksTable).watch().map((rows) {
      return rows.map((row) {
        return (
          id: row.id,
          title: row.title,
          isCompleted: row.isCompleted,
          serializedTags: row.serializedTags,
        );
      }).toList();
    });
  }

  @override
  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        isCompleted: Value(isCompleted),
      ),
    );
  }

  @override
  Future<void> deleteCloudTaskRow(String id) async {
    await (_db.delete(_db.tasksTable)..where((t) => t.id.equals(id))).go();
  }
}
