/// Reusable re-entrancy protector to block double-taps across any feature engine.
class MutationGuard<T> { // TODO: make it primary const
  final _inFlight = <T>{};

  bool claim(T id) {
    if (_inFlight.contains(id)) return false;
    _inFlight.add(id);
    return true;
  }

  void release(T id) {
    _inFlight.remove(id);
  }

  void clear() => _inFlight.clear();
}
