import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:tasks/tasks.dart';

void main() {
  // Initialize Cross-Cutting Services
  final connectivity = MockConnectivityService();

  // Initialize Physical Persistence
  final db = AppDatabase();
  final tasksDao = RealTasksDao(database: db);

  // Initialize Tier 1 Datastores
  final localDataSource = DriftTaskDataSource(dao: tasksDao);
  
  // Initialize with initial data to prevent empty-wipe issues on first boot
  final remoteDataSource = MockTaskDataSource([
    (
      id: 'task_1',
      title: 'Welcome to the Smart Iceberg!',
      isCompleted: false,
      tags: const IListConst(['getting-started']),
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      syncStatus: TaskSyncStatus.synced,
      lastErrorMessage: null,
    ),
  ]);

  // Initialize Tier 2 Submerged Engine
  final repository = TaskRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    connectivity: connectivity,
  );

  // Prime the remote simulation channel
  remoteDataSource.primeChannel();

  runApp(
    IcebergPatternApp(
      repository: repository,
      connectivity: connectivity,
    ),
  );
}

/// Root widget for the Iceberg Pattern example application.
class IcebergPatternApp extends StatelessWidget {
  const IcebergPatternApp({
    required this.repository,
    required this.connectivity,
    super.key,
  });

  final TaskRepository repository;
  final MockConnectivityService connectivity;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Iceberg Pattern Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: BlocSignalProvider<TaskBoardCubit>(
          create: (context) => TaskBoardCubit(repository: repository),
          child: const TaskBoardScreen(),
        ),
        // Demonstration FAB to toggle connectivity
        floatingActionButton: FloatingActionButton.small(
          onPressed: connectivity.toggle,
          backgroundColor: Colors.grey[800],
          child: const Icon(Icons.wifi_off, color: Colors.white, size: 16),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
