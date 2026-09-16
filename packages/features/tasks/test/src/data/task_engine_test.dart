import 'dart:async';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:signals_core/signals_core.dart';
import 'package:tasks/tasks.dart';

class MockRemoteDataSource extends Mock implements RemoteTaskDataSource {}
class MockLocalDataSource extends Mock implements LocalTaskDataSource {}
class MockConnectivity extends Mock implements ConnectivityService {}

void main() {
  setUpAll(() {
    registerFallbackValue((
      id: '',
      title: '',
      isCompleted: false,
      tags: const IListConst<String>([]),
      createdAt: DateTime(2024),
      syncStatus: TaskSyncStatus.synced,
      lastErrorMessage: null,
    ));
    registerFallbackValue(TaskSyncStatus.synced);
    registerFallbackValue(const IListConst<String>([]));
  });

  late MockRemoteDataSource remote;
  late MockLocalDataSource local;
  late MockConnectivity connectivity;
  late TaskRepository repository;

  final localStreamController = StreamController<List<Task>>.broadcast();
  final remoteStreamController = StreamController<List<Task>>.broadcast();

  setUp(() {
    remote = MockRemoteDataSource();
    local = MockLocalDataSource();
    connectivity = MockConnectivity();

    when(() => local.taskStream).thenAnswer((_) => localStreamController.stream);
    when(() => remote.taskStream).thenAnswer((_) => remoteStreamController.stream);
    when(() => local.getUnsyncedTasks()).thenAnswer((_) async => []);
    when(() => local.syncRemoteData(any())).thenAnswer((_) async {});
    
    // Default online
    final statusSignal = signal(ConnectivityStatus.online);
    when(() => connectivity.status).thenReturn(statusSignal);
    when(() => connectivity.isOnline).thenReturn(true);

    repository = TaskRepository(
      remoteDataSource: remote,
      localDataSource: local,
      connectivity: connectivity,
    );
  });

  tearDown(() {
    repository.dispose();
  });

  test('Optimistic Creation: Item appears in tasks signal immediately', () async {
    final title = 'Test Task';
    
    when(() => local.createTask(any())).thenAnswer((_) async {});
    when(() => remote.createTask(any())).thenAnswer((_) async {});
    when(() => local.updateTask(any(), any(), any())).thenAnswer((_) async {});

    // Action
    unawaited(repository.createTask(title));

    // Assert
    final currentTasks = repository.tasks.value;
    expect(currentTasks.length, 1);
    expect(currentTasks.first.title, title);
    expect(currentTasks.first.syncStatus, TaskSyncStatus.pending);
  });

  test('Reconciliation: Memory patch is cleared when local stream ACKs the change', () async {
    final title = 'Reconciliation Task';
    
    when(() => local.createTask(any())).thenAnswer((_) async {});
    when(() => remote.createTask(any())).thenAnswer((_) async {});
    when(() => local.updateTask(any(), any(), any())).thenAnswer((_) async {});

    // 1. Create task
    unawaited(repository.createTask(title));
    final tempId = repository.tasks.value.first.id;
    expect(repository.tasks.value.length, 1);

    // 2. Emit the same task from local database (ACK)
    final ackTask = (
      id: tempId,
      title: title,
      isCompleted: false,
      tags: const IListConst<String>([]),
      createdAt: DateTime.now(),
      syncStatus: TaskSyncStatus.pending,
      lastErrorMessage: null,
    );
    
    localStreamController.add([ackTask]);
    
    // Wait for the effect to run
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Assert: Tasks should still show 1 item, and _optimisticCreations should be empty (indirectly verified by stable length)
    expect(repository.tasks.value.length, 1);
    expect(repository.tasks.value.first.id, tempId);
  });

  test('Connectivity: Remote sync is skipped when offline', () async {
    final title = 'Offline Task';
    
    final statusSignal = signal(ConnectivityStatus.offline);
    when(() => connectivity.status).thenReturn(statusSignal);
    when(() => connectivity.isOnline).thenReturn(false);

    when(() => local.createTask(any())).thenAnswer((_) async {});

    // Action
    await repository.createTask(title);

    // Assert
    verifyNever(() => remote.createTask(any()));
    verify(() => local.createTask(any())).called(1);
  });
}
