import 'dart:async';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';
import '../data/task_engine.dart';
import '../domain/task_record.dart';

/// Screen-scoped presentation state for the Task Board.
typedef TaskBoardState = ({
IList<Task> tasks,
String? activeFilterTag,
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
        tasks: repository.tasks.value.lock,
        activeFilterTag: null,
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
  final _isDeletingTaskId = signal<String?>(null);
  late final void Function() _disposeEffect;

  void _initFacade() {
    final computedState = computed(() {
      final allTasks = _repository.tasks.value;
      final filter = _activeFilterTag.value;

      final filteredTasks = filter == null
          ? allTasks.lock
          : allTasks.where((t) => t.tags.contains(filter)).toIList();

      return (
      tasks: filteredTasks,
      activeFilterTag: filter,
      isDeletingTaskId: _isDeletingTaskId.value,
      hasSyncError: _repository.hasSyncError.value,
      isBusy: _repository.isBusy.value,
      );
    });

    _disposeEffect = computedState.subscribe(emit);
  }

  /// Updates the active category/tag filter.
  void setFilterTag(String? tag) => _activeFilterTag.value = tag;

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
    _isDeletingTaskId.dispose();
    await super.close();
  }
}
