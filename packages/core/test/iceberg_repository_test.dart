import 'dart:async';
import 'package:core/core.dart';
import 'package:test/test.dart';

class TestItem {
  const TestItem({required this.id, required this.value});
  final String id;
  final String value;
}

class TestIcebergRepository extends IcebergRepository<TestItem, String> {
  TestIcebergRepository({
    required super.cloudSnapshotStream,
    super.initialItems,
  }) : super(getId: (item) => item.id);
}

void main() {
  group('IcebergRepository Generic Submerged Engine Tests', () {
    late StreamController<List<TestItem>> streamController;
    late TestIcebergRepository repository;

    setUp(() {
      streamController = StreamController<List<TestItem>>.broadcast();
      repository = TestIcebergRepository(
        cloudSnapshotStream: streamController.stream,
        initialItems: const [
          TestItem(id: '1', value: 'Initial A'),
          TestItem(id: '2', value: 'Initial B'),
        ],
      );
    });

    tearDown(() {
      repository.dispose();
      streamController.close();
    });

    test('exposes initial items and receives stream updates', () async {
      expect(repository.items.value.length, equals(2));
      expect(repository.items.value[0].value, equals('Initial A'));

      streamController.add([
        const TestItem(id: '1', value: 'Updated A'),
        const TestItem(id: '2', value: 'Initial B'),
        const TestItem(id: '3', value: 'New C'),
      ]);

      await pumpEventQueue();

      expect(repository.items.value.length, equals(3));
      expect(repository.items.value[0].value, equals('Updated A'));
    });

    test('optimistic mutation updates state immediately and reconciles on success', () async {
      final completer = Completer<void>();

      final mutationFuture = repository.executeOptimisticMutation(
        id: '1',
        optimisticItem: const TestItem(id: '1', value: 'Optimistic A'),
        remoteAction: () => completer.future,
      );

      // State updated immediately (0ms)
      expect(repository.items.value[0].value, equals('Optimistic A'));
      expect(repository.isIdInFlight('1'), isTrue);

      completer.complete();
      await mutationFuture;

      expect(repository.isIdInFlight('1'), isFalse);
      expect(repository.hasSyncError.value, isFalse);
    });

    test('optimistic mutation failure triggers atomic rollback and sets sync error', () async {
      expect(repository.hasSyncError.value, isFalse);

      final mutationFuture = repository.executeOptimisticMutation(
        id: '1',
        optimisticItem: const TestItem(id: '1', value: 'Optimistic A'),
        remoteAction: () async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          throw Exception('Remote server error');
        },
      );

      // State updated immediately before remote finishes
      expect(repository.items.value[0].value, equals('Optimistic A'));

      expect(
        mutationFuture,
        throwsA(isA<SyncRollbackException>()),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      // Reverted to original server truth and set hasSyncError flag
      expect(repository.items.value[0].value, equals('Initial A'));
      expect(repository.hasSyncError.value, isTrue);
    });

    test('in-flight guard prevents duplicate concurrent mutations for same ID', () async {
      var callCount = 0;
      final completer = Completer<void>();

      final firstCall = repository.executeOptimisticMutation(
        id: '1',
        optimisticItem: const TestItem(id: '1', value: 'First'),
        remoteAction: () {
          callCount++;
          return completer.future;
        },
      );

      final secondCall = repository.executeOptimisticMutation(
        id: '1',
        optimisticItem: const TestItem(id: '1', value: 'Second'),
        remoteAction: () async {
          callCount++;
        },
      );

      expect(callCount, equals(1));

      completer.complete();
      await firstCall;
      await secondCall;

      expect(callCount, equals(1));
    });
  });
}
