import 'dart:async';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import '../domain/task_record.dart';
import 'task_data_source.dart';

/// Realized Tier 1 Mock Remote Datastore handling cloud state simulation.
class MockTaskDataSource implements RemoteTaskDataSource {
  final _controller = StreamController<List<Task>>.broadcast();
  final List<Task> _currentTasks;

  MockTaskDataSource(List<Task> initialTasks) : _currentTasks = List.from(initialTasks);

  @override
  Stream<List<Task>> get taskStream => _controller.stream;

  @override
  Future<void> createTask(Task task) async {
    // Simulate remote cloud write latency
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // Intentionally fail sync if title contains 'Error'
    if (task.title.contains('Error')) {
      throw Exception('Cloud server creation failure');
    }

    final index = _currentTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _currentTasks[index] = task;
    } else {
      _currentTasks.add(task);
    }
    _controller.add(List.from(_currentTasks));
  }

  @override
  Future<void> updateTask(String id, bool isCompleted) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final index = _currentTasks.indexWhere((t) => t.id == id);
    if (id == '3' || (index != -1 && _currentTasks[index].title.contains('Error'))) {
      throw Exception('Cloud server write failure');
    }

    if (index != -1) {
      final old = _currentTasks[index];
      _currentTasks[index] = (
        id: old.id,
        title: old.title,
        isCompleted: isCompleted,
        tags: old.tags,
        createdAt: old.createdAt,
        syncStatus: TaskSyncStatus.synced,
        lastErrorMessage: null,
      );
      _controller.add(List.from(_currentTasks));
    }
  }

  @override
  Future<void> updateTaskTitle(String id, String newTitle) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (newTitle.contains('Error')) {
      throw Exception('Cloud server update failure');
    }

    final index = _currentTasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final old = _currentTasks[index];
      _currentTasks[index] = (
        id: old.id,
        title: newTitle,
        isCompleted: old.isCompleted,
        tags: old.tags,
        createdAt: old.createdAt,
        syncStatus: TaskSyncStatus.synced,
        lastErrorMessage: null,
      );
      _controller.add(List.from(_currentTasks));
    }
  }

  @override
  Future<void> updateTaskTags(String id, IList<String> tags) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (tags.contains('Error')) {
      throw Exception('Cloud server tags update failure');
    }

    final index = _currentTasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final old = _currentTasks[index];
      _currentTasks[index] = (
        id: old.id,
        title: old.title,
        isCompleted: old.isCompleted,
        tags: tags,
        createdAt: old.createdAt,
        syncStatus: TaskSyncStatus.synced,
        lastErrorMessage: null,
      );
      _controller.add(List.from(_currentTasks));
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _currentTasks.removeWhere((t) => t.id == id);
    _controller.add(List.from(_currentTasks));
  }

  void primeChannel() {
    if (_currentTasks.isNotEmpty) {
      _controller.add(List.from(_currentTasks));
    }
  }
}
