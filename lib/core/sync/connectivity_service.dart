import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper around `connectivity_plus` so the rest of the app depends
/// on this interface rather than the package directly.
class ConnectivityService {
  ConnectivityService([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Emits `true` when the device has *some* network path (Wi-Fi, mobile,
  /// ethernet). Note: this indicates network reachability, not that the
  /// VyomVidya backend is actually reachable — the sync engine still treats
  /// individual push failures as retryable.
  Stream<bool> get onStatusChange => _connectivity.onConnectivityChanged.map(_hasConnection);

  Future<bool> get isOnline async => _hasConnection(await _connectivity.checkConnectivity());

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
