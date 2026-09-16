import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:tasks/tasks.dart';

void main() {
  // Initialize Physical Persistence
  final db = AppDatabase();
  final tasksDao = RealTasksDao(database: db);

  // Initialize Tier 1 Datastores
  final localDataSource = DriftTaskDataSource(dao: tasksDao);
  
  // Initialize with EMPTY remote to demonstrate cloud-to-local sync
  final remoteDataSource = MockTaskDataSource([]);

  // Initialize Tier 2 Submerged Engine (Dual-Track Sync)
  final repository = TaskRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  // Prime the remote simulation channel (starts empty)
  remoteDataSource.primeChannel();

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
