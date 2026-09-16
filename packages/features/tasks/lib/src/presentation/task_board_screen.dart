import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import '../application/task_board_cubit.dart';
import '../domain/task_record.dart';

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
            SnackBar(
              content: const Text('Sync failed: Some changes are logged for retry.'),
              backgroundColor: Colors.amber[800],
            ),
          );
        }
      },
      child: BlocSignalBuilder<TaskBoardCubit, TaskBoardState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tasks (High-Availability Iceberg)'),
              bottom: state.hasSyncError
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(28),
                      child: ColoredBox(
                        color: Colors.amber,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Offline / Sync Errors Present — Retrying in background',
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: context.read<TaskBoardCubit>().setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'Showing ${state.stats.visible} of ${state.stats.total} tasks',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${state.stats.completed} completed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.teal[700],
                            ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: state.activeFilterTag == null,
                        onSelected: (_) =>
                            context.read<TaskBoardCubit>().setFilterTag(null),
                      ),
                      const SizedBox(width: 8),
                      ...state.availableTags.map((tag) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(tag),
                              selected: state.activeFilterTag == tag,
                              onSelected: (_) => context
                                  .read<TaskBoardCubit>()
                                  .setFilterTag(tag),
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SegmentedButton<TaskStatusFilter>(
                    segments: const [
                      ButtonSegment(
                          value: TaskStatusFilter.all, label: Text('All')),
                      ButtonSegment(
                          value: TaskStatusFilter.active, label: Text('Active')),
                      ButtonSegment(
                          value: TaskStatusFilter.completed,
                          label: Text('Completed')),
                    ],
                    selected: {state.statusFilter},
                    onSelectionChanged: (value) => context
                        .read<TaskBoardCubit>()
                        .setStatusFilter(value.first),
                  ),
                ),
                Expanded(
                  child: state.tasks.isEmpty
                      ? _buildEmptyState(context, state)
                      : ListView.builder(
                          itemCount: state.tasks.length,
                          itemBuilder: (context, index) {
                            final item = state.tasks[index];
                            final task = item.task;

                            return ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: item.isSyncing
                                    ? null
                                    : (_) => context
                                        .read<TaskBoardCubit>()
                                        .toggleTask(
                                          task.id,
                                          task.isCompleted,
                                        ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: item.isSyncing
                                          ? null
                                          : () => _showTaskDialog(
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
                                          color: item.isSyncing
                                              ? Colors.grey
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _buildSyncIndicator(task.syncStatus),
                                ],
                              ),
                              subtitle: Wrap(
                                spacing: 4,
                                children: [
                                  ...task.tags.map((tag) => InputChip(
                                        label: Text(tag,
                                            style: const TextStyle(fontSize: 10)),
                                        onDeleted: item.isSyncing
                                            ? null
                                            : () => context
                                                .read<TaskBoardCubit>()
                                                .onRemoveTag(task.id, tag),
                                      )),
                                  ActionChip(
                                    label: const Icon(Icons.add, size: 14),
                                    onPressed: item.isSyncing
                                        ? null
                                        : () => _showAddTagDialog(
                                            context, task.id),
                                  ),
                                ],
                              ),
                              trailing: item.isSyncing
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : IconButton(
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

  Widget _buildSyncIndicator(TaskSyncStatus status) {
    return switch (status) {
      TaskSyncStatus.synced => const SizedBox.shrink(),
      TaskSyncStatus.pending => const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Icon(Icons.cloud_upload_outlined, size: 14, color: Colors.blue),
        ),
      TaskSyncStatus.error => const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Icon(Icons.sync_problem, size: 14, color: Colors.red),
        ),
    };
  }

  Widget _buildEmptyState(BuildContext context, TaskBoardState state) {
    final hasFilter = state.activeFilterTag != null ||
        state.searchQuery.isNotEmpty ||
        state.statusFilter != TaskStatusFilter.all;

    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(
            hasFilter ? Icons.search_off : Icons.task_alt,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter
                ? 'No tasks match your criteria'
                : 'Your task board is empty',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          if (hasFilter)
            TextButton(
              onPressed: () {
                final cubit = context.read<TaskBoardCubit>();
                cubit.setFilterTag(null);
                cubit.setSearchQuery('');
                cubit.setStatusFilter(TaskStatusFilter.all);
              },
              child: const Text('Clear all filters'),
            ),
        ],
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
