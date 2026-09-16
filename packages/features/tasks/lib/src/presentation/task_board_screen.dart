import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import '../application/task_board_cubit.dart';

/// Presentation Layer: Pure synchronous projection (UI = ƒ(State))
/// with zero stream subscriptions, non-blocking sync error banner,
/// and snack bar alerts via standard BlocSignalListener.
class TaskBoardScreen extends StatelessWidget {
  /// Creates a [TaskBoardScreen].
  const TaskBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSignalListener<TaskBoardCubit, TaskBoardState>(
      listenWhen: (previous, current) =>
          !previous.hasSyncError && current.hasSyncError,
      listener: (context, state) {
        if (state.hasSyncError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sync failed: Reverted to server truth.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: BlocSignalBuilder<TaskBoardCubit, TaskBoardState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tasks (The Iceberg Pattern)'),
              bottom: state.hasSyncError
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(28),
                      child: ColoredBox(
                        color: Colors.amber,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Offline / Sync Error — Showing Cached Tasks',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            body: Column(
              children: [
                if (state.isBusy) const LinearProgressIndicator(minHeight: 2),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: state.activeFilterTag == null,
                        onSelected: (_) =>
                            context.read<TaskBoardCubit>().setFilterTag(null),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Work'),
                        selected: state.activeFilterTag == 'work',
                        onSelected: (_) =>
                            context.read<TaskBoardCubit>().setFilterTag('work'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Personal'),
                        selected: state.activeFilterTag == 'personal',
                        onSelected: (_) => context
                            .read<TaskBoardCubit>()
                            .setFilterTag('personal'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.tasks.isEmpty
                      ? const Center(child: Text('No tasks found'))
                      : ListView.builder(
                          itemCount: state.tasks.length,
                          itemBuilder: (context, index) {
                            final task = state.tasks[index];

                            return ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (_) => context
                                    .read<TaskBoardCubit>()
                                    .toggleTask(
                                      task.id,
                                      task.isCompleted,
                                    ),
                              ),
                              title: InkWell(
                                onTap: () => _showTaskDialog(
                                  context,
                                  id: task.id,
                                  initialTitle: task.title,
                                ),
                                child: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                              subtitle: Wrap(
                                spacing: 4,
                                children: [
                                  ...task.tags.map((tag) => InputChip(
                                        label: Text(tag,
                                            style: const TextStyle(fontSize: 10)),
                                        onDeleted: () => context
                                            .read<TaskBoardCubit>()
                                            .onRemoveTag(task.id, tag),
                                      )),
                                  ActionChip(
                                    label: const Icon(Icons.add, size: 14),
                                    onPressed: () =>
                                        _showAddTagDialog(context, task.id),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => context
                                    .read<TaskBoardCubit>()
                                    .deleteTask(task.id),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showTaskDialog(context),
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showTaskDialog(
    BuildContext context, {
    String? id,
    String initialTitle = '',
  }) {
    final controller = TextEditingController(text: initialTitle);
    final isEditing = id != null;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'New Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task title...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  if (isEditing) {
                    context.read<TaskBoardCubit>().onUpdateTitle(id, title);
                  } else {
                    context.read<TaskBoardCubit>().onCreateTask(title);
                  }
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTagDialog(BuildContext context, String taskId) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Tag'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter tag name...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final tag = controller.text.trim();
                if (tag.isNotEmpty) {
                  context.read<TaskBoardCubit>().onAddTag(taskId, tag);
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
