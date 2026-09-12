import 'dart:async';

import 'package:blogstore/data/task_repository.dart';
import 'package:blogstore/domain/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskRepository Submerged Engine Tests', () {
    late StreamController<List<Task>> streamController;
    late TaskRepository repository;
    late List<Task> remoteTasks;

    setUp(() {
      streamController = StreamController<List<Task>>.broadcast();
      remoteTasks = [
        const Task(id: '1', title: 'Task 1', isCompleted: false, tags: ['work']),
        const Task(id: '2', title: 'Task 2', isCompleted: true, tags: ['home']),
      ];

      repository = TaskRepository(
        cloudSnapshotStream: streamController.stream,
        initialTasks: List.from(remoteTasks),
        updateCloudTask: (id, isCompleted) async {
          if (id == 'fail') {
            throw Exception('Cloud Error');
          }
          final idx = remoteTasks.indexWhere((t) => t.id == id);
          if (idx != -1) {
            remoteTasks[idx] = remoteTasks[idx].copyWith(isCompleted: isCompleted);
            streamController.add(List.from(remoteTasks));
          }
        },
        deleteCloudTask: (id) async {
          remoteTasks.removeWhere((t) => t.id == id);
          streamController.add(List.from(remoteTasks));
        },
      );
    });

    tearDown(() {
      repository.dispose();
      streamController.close();
    });

    test('toggleTask toggles status optimistically and syncs with remote', () async {
      expect(repository.tasks.value[0].isCompleted, isFalse);

      await repository.toggleTask('1', false);

      expect(remoteTasks[0].isCompleted, isTrue);
    });

    test('deleteTask removes task via remote callback', () async {
      expect(repository.tasks.value.length, equals(2));

      await repository.deleteTask('1');

      expect(remoteTasks.length, equals(1));
      expect(remoteTasks[0].id, equals('2'));
    });
  });
}
