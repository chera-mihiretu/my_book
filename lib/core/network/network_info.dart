import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract class for network information
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of NetworkInfo using connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    // TODO: Implement connectivity check
    throw UnimplementedError();
  }

  @override
  Stream<bool> get onConnectivityChanged {
    // TODO: Implement connectivity stream
    throw UnimplementedError();
  }
}
