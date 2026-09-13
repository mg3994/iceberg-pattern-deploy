import 'dart:async';

import 'package:blogstore/data/task_repository.dart';
import 'package:blogstore/domain/task.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskRepository Submerged Engine Tests', () {
    late StreamController<List<Task>> streamController;
    late TaskRepository repository;
    late List<Task> remoteTasks;

    setUp(() {
      streamController = StreamController<List<Task>>.broadcast();
      remoteTasks = [
        (id: '1', title: 'Task 1', isCompleted: false, tags: ['work'].toIList()),
        (id: '2', title: 'Task 2', isCompleted: true, tags: ['home'].toIList()),
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
            final old = remoteTasks[idx];
            remoteTasks[idx] = (
              id: old.id,
              title: old.title,
              isCompleted: isCompleted,
              tags: old.tags,
            );
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
