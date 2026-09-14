import 'dart:async';

import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';

import '../domain/task.dart';
import '../domain/task_repository_interface.dart';

/// Data Layer: Concrete Submerged Engine for Task entity.
/// Inherits generic reactive graph stream caching (via streamSignal and computed), optimistic patch overrides,
/// atomic batch rollbacks, and deduplication from [IcebergRepository].
class TaskRepository extends IcebergRepository<Task, String>
    implements ITaskRepository {
  TaskRepository({
    required super.cloudSnapshotStream,
    required Future<void> Function(String id, bool isCompleted) updateCloudTask,
    required Future<void> Function(String id) deleteCloudTask,
    List<Task> initialTasks = const [],
  })  : _updateCloudTask = updateCloudTask,
        _deleteCloudTask = deleteCloudTask,
        super(
          getId: (task) => task.id,
          initialItems: initialTasks,
        );

  final Future<void> Function(String id, bool isCompleted) _updateCloudTask;
  final Future<void> Function(String id) _deleteCloudTask;

  @override
  ReadonlySignal<IList<Task>> get tasks => items;

  @override
  Future<void> toggleTask(String id, bool currentStatus) async {
    final currentTasks = tasks.value;
    final taskIndex = currentTasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) return;

    final targetTask = currentTasks[taskIndex];
    final newStatus = !currentStatus;
    final optimisticTask = (
      id: targetTask.id,
      title: targetTask.title,
      isCompleted: newStatus,
      tags: targetTask.tags,
    );

    await executeOptimisticMutation(
      id: id,
      optimisticItem: optimisticTask,
      remoteAction: () => _updateCloudTask(id, newStatus),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await executePessimisticMutation(() => _deleteCloudTask(id));
  }
}
