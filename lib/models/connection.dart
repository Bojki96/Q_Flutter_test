import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Network {
  static Future<bool> statusOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static void status() => Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult connection) {});

  static void showConnectionMessage(
      {required BuildContext context,
      required String message,
      bool? isOnline}) {
    if (Platform.isAndroid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isOnline! ? Colors.white : Colors.black),
        ),
        backgroundColor:
            isOnline ? const Color.fromARGB(255, 79, 255, 0) : Colors.red,
      ));
    }
  }
}
