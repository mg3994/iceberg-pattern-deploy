import 'dart:async';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:signals_core/signals_core.dart';

/// Reusable re-entrancy protector to block double-taps across any feature engine.
class MutationGuard<T> {
  final _inFlight = signal<ISet<T>>(ISet());

  /// Exposes the set of keys currently in flight as a reactive signal.
  ReadonlySignal<ISet<T>> get activeKeys => _inFlight;

  /// Claims execution rights for [id].
  /// Returns `true` if claimed, `false` if already in flight.
  bool claim(T id) {
    if (_inFlight.value.contains(id)) return false;
    _inFlight.value = _inFlight.value.add(id);
    return true;
  }

  /// Releases execution rights for [id].
  void release(T id) {
    _inFlight.value = _inFlight.value.remove(id);
  }

  /// Clears all in-flight locks.
  void clear() => _inFlight.value = ISet();

  /// Returns `true` if [id] currently has an operation in flight.
  bool isLocked(T id) => _inFlight.value.contains(id);

  /// Returns `true` if any operation is currently in flight.
  bool get isBusy => _inFlight.value.isNotEmpty;

  /// Number of active locks currently held.
  int get activeLockCount => _inFlight.value.length;

  /// Exposes the busy status as a reactive signal.
  late final ReadonlySignal<bool> busySignal = computed(() => isBusy);

  /// Executes [action] safely under [id], auto-releasing on completion or error.
  ///
  /// [timeout] prevents stale locks if the asynchronous action hangs indefinitely.
  Future<R?> run<R>(
    T id,
    Future<R> Function() action, {
    Duration? timeout,
  }) async {
    if (!claim(id)) return null;
    try {
      if (timeout != null) {
        return await action().timeout(timeout);
      }
      return await action();
    } finally {
      release(id);
    }
  }
}

/// Extension providing a declarative DSL for guarding asynchronous closures.
extension GuardedAsync<R> on Future<R> Function() {
  /// Executes this function only if [key] isn't currently locked by [guard].
  Future<R?> guardedBy<T>(
    MutationGuard<T> guard,
    T key, {
    Duration? timeout,
  }) =>
      guard.run(key, this, timeout: timeout);
}
