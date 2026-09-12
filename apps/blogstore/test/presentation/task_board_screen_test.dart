import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/application/task_board_cubit.dart';
import 'package:blogstore/domain/task.dart';
import 'package:blogstore/domain/task_repository_interface.dart';
import 'package:blogstore/presentation/task_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signals_core/signals_core.dart';

class MockTaskRepository implements ITaskRepository {
  MockTaskRepository({
    required List<Task> tasks,
    bool hasSyncError = false,
  })  : _tasks = signal(tasks),
        _syncError = signal(hasSyncError);

  final Signal<List<Task>> _tasks;
  final Signal<bool> _syncError;

  bool toggleCalled = false;

  @override
  ReadonlySignal<List<Task>> get tasks => _tasks;

  @override
  ReadonlySignal<bool> get hasSyncError => _syncError;

  @override
  Future<void> toggleTask(String id, bool currentStatus) async {
    toggleCalled = true;
  }

  @override
  Future<void> deleteTask(String id) async {}

  @override
  void dispose() {
    _tasks.dispose();
    _syncError.dispose();
  }
}

void main() {
  group('TaskBoardScreen Widget Tests', () {
    late MockTaskRepository repository;

    final sampleTasks = [
      const Task(id: '1', title: 'First Task', isCompleted: false, tags: ['work']),
      const Task(id: '2', title: 'Second Task', isCompleted: true, tags: ['personal']),
    ];

    setUp(() {
      repository = MockTaskRepository(tasks: sampleTasks);
    });

    tearDown(() {
      repository.dispose();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocSignalProvider<TaskBoardCubit>(
          create: (context) => TaskBoardCubit(repository: repository),
          child: const TaskBoardScreen(),
        ),
      );
    }

    testWidgets('renders app bar, filter chips, and task list items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Tasks (The Iceberg Pattern)'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);

      expect(find.text('First Task'), findsOneWidget);
      expect(find.text('Second Task'), findsOneWidget);
    });

    testWidgets('tapping filter chip filters displayed tasks', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();

      expect(find.text('First Task'), findsOneWidget);
      expect(find.text('Second Task'), findsNothing);
    });

    testWidgets('renders sync error banner when hasSyncError is true', (tester) async {
      repository = MockTaskRepository(tasks: sampleTasks, hasSyncError: true);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Offline / Sync Error — Showing Cached Tasks'), findsOneWidget);
    });
  });
}
