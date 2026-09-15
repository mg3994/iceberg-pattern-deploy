import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:tasks/tasks.dart';

void main() {
  final initialTasks = <Task>[
    (
    id: '1',
    title: 'Draft Iceberg Pattern architecture article',
    isCompleted: true,
    tags: const IListConst(['work', 'writing']),
    ),
    (
    id: '2',
    title: 'Review PR feedback on BlocSignal ecosystem',
    isCompleted: false,
    tags: const IListConst(['work']),
    ),
    (
    id: '3',
    title: 'Grocery shopping & farmers market (Fails Sync)',
    isCompleted: false,
    tags: const IListConst(['personal']),
    ),
  ];

  // Initialize Tier 1 Datastore
  final dataSource = MockTaskDataSource(initialTasks);

  // Initialize Tier 2 Submerged Engine
  final repository = TaskRepository(
    dataSource: dataSource,
    initialTasks: initialTasks,
  );

  // Prime the initial mock snapshot channel
  dataSource.primeChannel();

  runApp(
    IcebergPatternApp(
      repository: repository,
    ),
  );
}

/// Root widget for the Iceberg Pattern example application.
class IcebergPatternApp extends StatelessWidget {
  const IcebergPatternApp({
    required this.repository,
    super.key,
  });

  final TaskRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Iceberg Pattern Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: BlocSignalProvider<TaskBoardCubit>(
        create: (context) => TaskBoardCubit(repository: repository),
        child: const TaskBoardScreen(),
      ),
    );
  }
}
