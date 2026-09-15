import 'dart:async';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import '../domain/task_record.dart';
import 'task_data_source.dart';

/// Realized Tier 1 Mock Datastore handling local memory state and simulation latencies.
class MockTaskDataSource implements TaskDataSource {
  final _controller = StreamController<List<Task>>.broadcast();
  final List<Task> _currentTasks;

  MockTaskDataSource(List<Task> initialTasks) : _currentTasks = List.from(initialTasks);

  @override
  Stream<List<Task>> get taskStream => _controller.stream;

  @override
  Future<void> updateTask(String id, bool isCompleted) async {
    // Simulate remote cloud write latency
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // Intentionally fail sync for task 3 to demonstrate optimistic UI rollback
    if (id == '3') {
      throw Exception('Cloud server write failure');
    }

    final index = _currentTasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final old = _currentTasks[index];
      _currentTasks[index] = (
        id: old.id,
        title: old.title,
        isCompleted: isCompleted,
        tags: old.tags,
      );
      _controller.add(List.from(_currentTasks));
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    // Simulate server deletion latency
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _currentTasks.removeWhere((t) => t.id == id);
    _controller.add(List.from(_currentTasks));
  }

  /// Pushes the initial state snapshot to cold subscribers.
  void primeChannel() {
    _controller.add(List.from(_currentTasks));
  }
}
