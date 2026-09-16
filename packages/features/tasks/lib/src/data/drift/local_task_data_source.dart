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
  Future<void> createTask(Task task) async {
    await _dao.insertTask((
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      serializedTags: task.tags.join(','),
    ));
  }

  @override
  Future<void> updateTask(String id, bool isCompleted) async {
    await _dao.updateTaskStatus(id, isCompleted);
  }

  @override
  Future<void> updateTaskTitle(String id, String newTitle) async {
    await _dao.updateTaskTitle(id, newTitle);
  }

  @override
  Future<void> updateTaskTags(String id, IList<String> tags) async {
    await _dao.updateTaskTags(id, tags.join(','));
  }

  @override
  Future<void> deleteTask(String id) async {
    await _dao.deleteCloudTaskRow(id);
  }

  @override
  Future<void> syncRemoteData(List<Task> remoteTasks) async {
    final dbRows = remoteTasks
        .map((t) => (
              id: t.id,
              title: t.title,
              isCompleted: t.isCompleted,
              serializedTags: t.tags.join(','),
            ))
        .toList();

    await _dao.replaceTableContent(dbRows);
  }
}
