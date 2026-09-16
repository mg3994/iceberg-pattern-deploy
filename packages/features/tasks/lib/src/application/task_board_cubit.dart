import 'dart:async';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';
import '../data/task_engine.dart';
import '../domain/task_record.dart';

/// View Model for an individual task item in the UI.
typedef TaskItem = ({
  Task task,
  bool isSyncing,
});

/// Screen-scoped presentation state for the Task Board.
typedef TaskBoardState = ({
  IList<TaskItem> tasks,
  IList<String> availableTags,
  String? activeFilterTag,
  String searchQuery,
  String? isDeletingTaskId,
  bool hasSyncError,
  bool isBusy,
});

/// The Visible Boundary: Screen-scoped facade that filters domain data,
/// tracks ephemeral UI states (such as row-level loading spinners),
/// and translates repository exceptions into standard BLoC error channels.
class TaskBoardCubit extends CubitSignal<TaskBoardState> {
  TaskBoardCubit({required TaskRepository repository})
      : _repository = repository,
        super(
          initialState: (
            tasks: IList(),
            availableTags: IList(),
            activeFilterTag: null,
            searchQuery: '',
            isDeletingTaskId: null,
            hasSyncError: repository.hasSyncError.value,
            isBusy: repository.isBusy.value,
          ),
          equals: (prev, curr) => prev == curr, // Built-in Dart 3 deep record structural equality
        ) {
    _initFacade();
  }

  final TaskRepository _repository;
  final _activeFilterTag = signal<String?>(null);
  final _searchQuery = signal<String>('');
  final _isDeletingTaskId = signal<String?>(null);
  late final void Function() _disposeEffect;

  void _initFacade() {
    final computedState = computed(() {
      final allTasks = _repository.tasks.value;
      final activeIds = _repository.activeTaskIds.value;
      final filter = _activeFilterTag.value;
      final query = _searchQuery.value.toLowerCase();

      // Derive all available tags from the task pool dynamically
      final tagsSet = <String>{};
      for (final task in allTasks) {
        tagsSet.addAll(task.tags);
      }
      final sortedTags = tagsSet.toIList().sort();

      // 1. Filter, 2. Map to View Model (TaskItem)
      final filteredTasks = allTasks.where((t) {
        final matchesTag = filter == null || t.tags.contains(filter);
        final matchesSearch = query.isEmpty || t.title.toLowerCase().contains(query);
        return matchesTag && matchesSearch;
      }).map((task) => (
        task: task,
        isSyncing: activeIds.contains(task.id),
      )).toIList();

      return (
        tasks: filteredTasks,
        availableTags: sortedTags,
        activeFilterTag: filter,
        searchQuery: _searchQuery.value,
        isDeletingTaskId: _isDeletingTaskId.value,
        hasSyncError: _repository.hasSyncError.value,
        isBusy: _repository.isBusy.value,
      );
    });

    _disposeEffect = computedState.subscribe(emit);
  }

  /// Updates the active category/tag filter.
  void setFilterTag(String? tag) => _activeFilterTag.value = tag;

  /// Updates the search query.
  void setSearchQuery(String query) => _searchQuery.value = query;

  /// Creates a new task.
  Future<void> onCreateTask(String title) async {
    try {
      await _repository.createTask(title);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  /// Updates a task title.
  Future<void> onUpdateTitle(String id, String title) async {
    try {
      await _repository.updateTaskTitle(id, title);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  /// Adds a tag to a task.
  Future<void> onAddTag(String id, String tag) async {
    try {
      await _repository.addTag(id, tag);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  /// Removes a tag from a task.
  Future<void> onRemoveTag(String id, String tag) async {
    try {
      await _repository.removeTag(id, tag);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  /// Dispatches optimistic toggle; forwards failure to onError for SnackBar display.
  void toggleTask(String id, bool currentStatus) {
    unawaited(
      _repository.toggleTask(id, currentStatus).catchError(
        (Object error, StackTrace st) {
          onError(error, st);
        },
      ),
    );
  }

  /// Dispatches optimistic delete.
  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  @override
  Future<void> close() async {
    _disposeEffect();
    _activeFilterTag.dispose();
    _searchQuery.dispose();
    _isDeletingTaskId.dispose();
    await super.close();
  }
}
