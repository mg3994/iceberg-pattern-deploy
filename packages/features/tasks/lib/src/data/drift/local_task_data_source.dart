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
      return rows.map(_mapRowToTask).toList();
    });
  }

  @override
  Future<List<Task>> getUnsyncedTasks() async {
    final rows = await _dao.getUnsyncedTasks();
    return rows.map(_mapRowToTask).toList();
  }

  @override
  Future<void> createTask(Task task) async {
    await _dao.insertTask((
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      serializedTags: task.tags.join(','),
      createdAt: task.createdAt,
      syncStatus: _mapSyncStatusToInt(task.syncStatus),
      lastError: task.lastErrorMessage,
    ));
  }

  @override
  Future<void> updateTask(String id, bool isCompleted, [TaskSyncStatus status = TaskSyncStatus.pending, String? error]) async {
    await _dao.updateTaskStatus(id, isCompleted, _mapSyncStatusToInt(status), error);
  }

  @override
  Future<void> updateTaskTitle(String id, String newTitle, [TaskSyncStatus status = TaskSyncStatus.pending, String? error]) async {
    await _dao.updateTaskTitle(id, newTitle, _mapSyncStatusToInt(status), error);
  }

  @override
  Future<void> updateTaskTags(String id, IList<String> tags, [TaskSyncStatus status = TaskSyncStatus.pending, String? error]) async {
    await _dao.updateTaskTags(id, tags.join(','), _mapSyncStatusToInt(status), error);
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
              createdAt: t.createdAt,
              syncStatus: 0, // synced
              lastError: null,
            ))
        .toList();

    await _dao.upsertTasks(dbRows);
  }

  Task _mapRowToTask(TaskDbData row) {
    final tagsList = row.serializedTags.isEmpty
        ? const IListConst<String>([])
        : IList<String>(row.serializedTags.split(','));

    return (
      id: row.id,
      title: row.title,
      isCompleted: row.isCompleted,
      tags: tagsList,
      createdAt: row.createdAt,
      syncStatus: _mapIntToSyncStatus(row.syncStatus),
      lastErrorMessage: row.lastError,
    );
  }

  int _mapSyncStatusToInt(TaskSyncStatus status) {
    return switch (status) {
      TaskSyncStatus.synced => 0,
      TaskSyncStatus.pending => 1,
      TaskSyncStatus.error => 2,
    };
  }

  TaskSyncStatus _mapIntToSyncStatus(int value) {
    return switch (value) {
      1 => TaskSyncStatus.pending,
      2 => TaskSyncStatus.error,
      _ => TaskSyncStatus.synced,
    };
  }
}
