import 'package:connectivity_plus/connectivity_plus.dart';

class Network {
  static Future<bool> statusOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static status() => Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult connection) {});
}
