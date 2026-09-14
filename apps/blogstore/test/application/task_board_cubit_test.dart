import 'package:blogstore/application/task_board_cubit.dart';
import 'package:blogstore/domain/task.dart';
import 'package:blogstore/domain/task_repository_interface.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signals_core/signals_core.dart';

class MockTaskRepository implements ITaskRepository {
  MockTaskRepository({
    List<Task> initialTasks = const [],
    bool initialSyncError = false,
  })  : _tasksSignal = signal(initialTasks.toIList()),
        _hasSyncErrorSignal = signal(initialSyncError);

  final Signal<IList<Task>> _tasksSignal;
  final Signal<bool> _hasSyncErrorSignal;

  bool toggleCalled = false;
  bool deleteCalled = false;
  Object? toggleErrorToThrow;

  @override
  ReadonlySignal<IList<Task>> get tasks => _tasksSignal;

  @override
  ReadonlySignal<bool> get hasSyncError => _hasSyncErrorSignal;

  @override
  Future<void> toggleTask(String id, bool currentStatus) async {
    toggleCalled = true;
    if (toggleErrorToThrow != null) {
      throw toggleErrorToThrow!;
    }
    final idx = _tasksSignal.value.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final updated = List<Task>.from(_tasksSignal.value);
      final old = updated[idx];
      updated[idx] = (
        id: old.id,
        title: old.title,
        isCompleted: !currentStatus,
        tags: old.tags,
      );
      _tasksSignal.value = updated.toIList();
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    deleteCalled = true;
    final updated = List<Task>.from(_tasksSignal.value)..removeWhere((t) => t.id == id);
    _tasksSignal.value = updated.toIList();
  }

  @override
  void dispose() {
    _tasksSignal.dispose();
    _hasSyncErrorSignal.dispose();
  }
}

void main() {
  group('TaskBoardCubit Tests', () {
    late MockTaskRepository repository;
    late TaskBoardCubit cubit;

    final testTasks = <Task>[
      (id: '1', title: 'Work task', isCompleted: false, tags: ['work'].toIList()),
      (id: '2', title: 'Personal task', isCompleted: true, tags: ['personal'].toIList()),
    ];

    setUp(() {
      repository = MockTaskRepository(initialTasks: testTasks);
      cubit = TaskBoardCubit(repository: repository);
    });

    tearDown(() {
      cubit.close();
      repository.dispose();
    });

    test('initialState reflects repository values', () {
      expect(cubit.state.value.tasks, equals(testTasks.toIList()));
      expect(cubit.state.value.activeFilterTag, isNull);
      expect(cubit.state.value.isDeletingTaskId, isNull);
      expect(cubit.state.value.hasSyncError, isFalse);
    });

    test('setFilterTag filters tasks correctly', () async {
      cubit.setFilterTag('work');
      await pumpEventQueue();

      expect(cubit.state.value.activeFilterTag, equals('work'));
      expect(cubit.state.value.tasks.length, equals(1));
      expect(cubit.state.value.tasks[0].id, equals('1'));

      cubit.setFilterTag(null);
      await pumpEventQueue();

      expect(cubit.state.value.tasks.length, equals(2));
    });

    test('toggleTask dispatches call to repository', () async {
      cubit.toggleTask('1', false);
      await pumpEventQueue();

      expect(repository.toggleCalled, isTrue);
    });

    test('deleteTask manages isDeletingTaskId state during execution', () async {
      final deleteFuture = cubit.deleteTask('1');

      expect(repository.deleteCalled, isTrue);
      await deleteFuture;

      expect(cubit.state.value.isDeletingTaskId, isNull);
      expect(cubit.state.value.tasks.length, equals(1));
    });
  });
}
