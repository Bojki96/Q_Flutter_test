import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomThemeMode {
  static darkAndroid(BuildContext context) => ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color.fromARGB(255, 79, 255, 0),
      ),
      primaryColor: const Color.fromARGB(255, 79, 255, 0),
      textTheme: Theme.of(context)
          .textTheme
          .apply(bodyColor: Colors.white, fontSizeDelta: 5));

  static lightAndroid(BuildContext context) => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.black,
      ),
      primaryColor: Colors.black,
      textTheme: Theme.of(context)
          .textTheme
          .apply(bodyColor: Colors.black, fontSizeDelta: 5));

  static darkIOS(BuildContext context) => {
        CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.black,
            primaryColor: const Color.fromARGB(255, 79, 255, 0),
            textTheme: CupertinoTheme.of(context).textTheme.copyWith(
                primaryColor: Colors.white,
                textStyle: const TextStyle(color: CupertinoColors.white))),
      };

  static lightIOS(BuildContext context) => {
        CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.white,
            primaryColor: CupertinoColors.black,
            textTheme: CupertinoTheme.of(context).textTheme.copyWith(
                primaryColor: CupertinoColors.black,
                textStyle: const TextStyle(color: CupertinoColors.black))),
      };
}
