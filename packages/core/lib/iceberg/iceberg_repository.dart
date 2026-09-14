import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';

import 'sync_rollback_exception.dart';

/// The Submerged Engine Base: Quarantines raw asynchronous cloud/remote streams
/// into a synchronous, cached reactive graph and manages optimistic reconciliation,
/// atomic batch rollbacks, and in-flight request deduplication.
abstract class IcebergRepository<T, ID> {
  IcebergRepository({
    required Stream<List<T>> cloudSnapshotStream,
    required this.getId,
    List<T> initialItems = const [],
  }) {
    _initEngine(cloudSnapshotStream, initialItems);
  }

  /// Function to extract unique identity [ID] from a domain item [T].
  final ID Function(T item) getId;

  // In-flight guard to prevent duplicate concurrent operations on the same entity ID
  final Set<ID> _inFlightIds = {};

  // Private Reactive Graph
  late final StreamSignal<List<T>> _cloudStreamSignal;
  final _optimisticPatches = signal<Map<ID, T>>({});
  final _hasSyncError = signal<bool>(false);
  late final Computed<IList<T>> _computedItems;

  void _initEngine(Stream<List<T>> cloudSnapshotStream, List<T> initialItems) {
    _cloudStreamSignal = streamSignal(
      () => cloudSnapshotStream,
      options: AsyncSignalOptions<List<T>>(initialValue: initialItems),
    );

    _computedItems = computed(() {
      final baseItems = _cloudStreamSignal.value.value ?? const [];
      final overrides = _optimisticPatches.value;
      if (overrides.isEmpty) return baseItems.toIList();

      return baseItems.map((item) {
        final override = overrides[getId(item)];
        return override ?? item;
      }).toIList();
    });
  }

  /// Public Readonly Boundary for domain items as fast_immutable_collections [IList]
  ReadonlySignal<IList<T>> get items => _computedItems;

  /// Public Readonly Boundary for sync error banner flag
  ReadonlySignal<bool> get hasSyncError => _hasSyncError;

  /// Returns whether a mutation for [id] is currently in-flight.
  bool isIdInFlight(ID id) => _inFlightIds.contains(id);

  /// OPTIMISTIC MUTATION: Updates local state immediately, then synchronizes in background.
  /// On success: atomically clears local patch and sync error.
  /// On failure: atomically rolls back local patch, flags sync error, and throws [SyncRollbackException].
  Future<void> executeOptimisticMutation({
    required ID id,
    required T optimisticItem,
    required Future<void> Function() remoteAction,
  }) async {
    if (_inFlightIds.contains(id)) return;
    _inFlightIds.add(id);

    final updatedPatches = Map<ID, T>.from(_optimisticPatches.value)
      ..[id] = optimisticItem;
    _optimisticPatches.value = updatedPatches;

    try {
      await remoteAction();

      // Reconcile atomically using batch(): clear override and clear sync error
      batch(() {
        _hasSyncError.value = false;
        final remaining = Map<ID, T>.from(_optimisticPatches.value)..remove(id);
        _optimisticPatches.value = remaining;
      });
    } catch (error, stackTrace) {
      // Rollback atomically using batch(): revert override and set sync error
      batch(() {
        final remaining = Map<ID, T>.from(_optimisticPatches.value)..remove(id);
        _optimisticPatches.value = remaining;
        _hasSyncError.value = true;
      });

      Error.throwWithStackTrace(
        SyncRollbackException('Failed optimistic mutation for ID $id. Reverted.', error),
        stackTrace,
      );
    } finally {
      _inFlightIds.remove(id);
    }
  }

  /// PESSIMISTIC MUTATION: Executes remote action directly.
  Future<R> executePessimisticMutation<R>(Future<R> Function() remoteAction) async {
    return await remoteAction();
  }

  /// Disposes internal reactive signals.
  void dispose() {
    _inFlightIds.clear();
    _cloudStreamSignal.dispose();
    _optimisticPatches.dispose();
    _hasSyncError.dispose();
    _computedItems.dispose();
  }
}
