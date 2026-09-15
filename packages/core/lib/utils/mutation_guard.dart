/// Reusable re-entrancy protector to block double-taps across any feature engine.
class MutationGuard<T> {
  final _inFlight = <T>{};

  /// Claims execution rights for [id].
  /// Returns `true` if claimed, `false` if already in flight.
  bool claim(T id) => _inFlight.add(id);

  /// Releases execution rights for [id].
  void release(T id) => _inFlight.remove(id);

  /// Clears all in-flight locks.
  void clear() => _inFlight.clear();

  /// Executes [action] safely under [id], auto-releasing on completion or error.
  Future<R?> run<R>(T id, Future<R> Function() action) async {
    if (!claim(id)) return null;
    try {
      return await action();
    } finally {
      release(id);
    }
  }
}

/// Extension providing a declarative DSL for guarding asynchronous closures.
extension GuardedAsync<R> on Future<R> Function() {
  /// Executes this function only if [key] isn't currently locked by [guard].
  Future<R?> guardedBy<T>(MutationGuard<T> guard, T key) => guard.run(key, this);
}
