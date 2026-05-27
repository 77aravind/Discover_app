abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Simple implementation that always reports connected.
/// Replace with real connectivity checks as needed.
class AlwaysConnectedNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}
