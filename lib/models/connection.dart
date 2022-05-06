import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

// Connectivity _connectivity = Connectivity();

class Network {
  static Future<bool> statusOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // static bool isConnected(ConnectivityResult connection) =>
  //     connection != ConnectivityResult.none;

  static status() => Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult connection) {});
}
