import 'package:signals_core/signals_core.dart';

/// Represents the physical network connectivity status of the device.
enum ConnectivityStatus {
  /// Device is connected to the internet.
  online,

  /// Device has no active internet connection.
  offline,
}

/// Abstract contract governing network awareness across the workspace.
abstract interface class ConnectivityService {
  /// Reactive signal broadcasting the current connectivity status.
  ReadonlySignal<ConnectivityStatus> get status;

  /// Returns true if the device is currently online.
  bool get isOnline;
}

/// Simulation implementation of ConnectivityService for testing and demonstration.
class MockConnectivityService implements ConnectivityService {
  final _status = signal(ConnectivityStatus.online);

  @override
  ReadonlySignal<ConnectivityStatus> get status => _status;

  @override
  bool get isOnline => _status.value == ConnectivityStatus.online;

  /// Manually toggles the connectivity state.
  void toggle() {
    _status.value = _status.value == ConnectivityStatus.online
        ? ConnectivityStatus.offline
        : ConnectivityStatus.online;
  }
}
