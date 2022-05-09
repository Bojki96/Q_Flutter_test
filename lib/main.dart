import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_flutter_test/models/theme_provider.dart';
import 'package:q_flutter_test/screens/posts_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/posts_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostsAdapter());
  await Hive.openBox<Posts>('posts');
  runApp(const QTest());
}

class QTest extends StatelessWidget {
  const QTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return ProviderScope(
        child: MaterialApp(
          themeMode: ThemeMode.dark,
          theme: CustomThemeMode.lightAndroid(context),
          darkTheme: CustomThemeMode.darkAndroid(context),
          home: const PostsView(),
        ),
      );
    } else if (Platform.isIOS) {
      return ProviderScope(
        child: CupertinoApp(
          theme: CupertinoThemeData(
              scaffoldBackgroundColor: CupertinoColors.black,
              primaryColor: const Color.fromARGB(255, 79, 255, 0),
              textTheme: CupertinoTheme.of(context).textTheme.copyWith(
                  primaryColor: Colors.white,
                  textStyle: const TextStyle(color: CupertinoColors.white))),
          home: const PostsView(),
        ),
      );
    } else {
      return const NonExistingPlatform();
    }
  }
}

class NonExistingPlatform extends StatelessWidget {
  const NonExistingPlatform({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: const Text(
            'This is not a valid platform for running the application!'),
      ),
    );
  }
}
