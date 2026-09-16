import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import '../../domain/task_record.dart';
import '../task_data_source.dart' as source;
import 'tasks_dao.dart';

/// Production Relational Storage implementation mapping clean typed DAO queries to domain entities.
class DriftTaskDataSource implements source.LocalTaskDataSource {
  final TasksDao _dao;

  DriftTaskDataSource({
    required TasksDao dao,
  }) : _dao = dao;

  @override
  Stream<List<Task>> get taskStream {
    return _dao.watchAllTasks().map((rows) {
      return rows.map((row) {
        final tagsList = row.serializedTags.isEmpty
            ? const IListConst<String>([])
            : IList<String>(row.serializedTags.split(','));

        return (
          id: row.id,
          title: row.title,
          isCompleted: row.isCompleted,
          tags: tagsList,
        );
      }).toList();
    });
  }

  @override
  Future<void> updateTask(String id, bool isCompleted) async {
    await _dao.updateTaskStatus(id, isCompleted);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _dao.deleteCloudTaskRow(id);
  }

  @override
  Future<void> syncRemoteData(List<Task> remoteTasks) async {
    final dbRows = remoteTasks.map((t) => (
      id: t.id,
      title: t.title,
      isCompleted: t.isCompleted,
      serializedTags: t.tags.join(','),
    )).toList();

    await _dao.upsertTasks(dbRows);
  }
}
