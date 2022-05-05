import 'package:connectivity_plus/connectivity_plus.dart';

class Network {
  static bool isConnected(ConnectivityResult connection) =>
      connection != ConnectivityResult.none;

  static statusChanged() => Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult connection) {});
}
