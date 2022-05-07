import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color.fromARGB(255, 79, 255, 0),
            ),
            primaryColor: Color.fromARGB(255, 79, 255, 0),
            // canvasColor: Color.fromARGB(255, 79, 255, 0),
            // splashColor: Color.fromARGB(255, 79, 255, 0),
            textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                //displayColor: Colors.white,
                fontSizeDelta: 5),
            // textButtonTheme: TextButtonThemeData(
            //   style: ButtonStyle(
            //     textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
            //       color: Colors.white,
            //     )),
            //     backgroundColor: MaterialStateProperty.all<Color>(
            //       Colors.black,
            //     ),
            //     foregroundColor:
            //         MaterialStateProperty.all<Color>(Colors.white),
            //     overlayColor: MaterialStateProperty.all<Color>(
            //       Color.fromARGB(255, 79, 255, 0),
            //     ),
            //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //       RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12)),
            //     ),
            //     side: MaterialStateProperty.all<BorderSide>(BorderSide(
            //       color: Colors.grey[900]!,
            //       width: 1,
            //     )),
            //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            //         EdgeInsets.fromLTRB(5, 0, 5, 0)),
            //   ),
            //)
          ),
          home: PostsView(),
        ),
      );
    } else if (Platform.isIOS) {
      return CupertinoApp();
    } else {
      return NonExistingPlatform();
    }
  }
}

class NonExistingPlatform extends StatelessWidget {
  const NonExistingPlatform({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child:
            Text('This is not a valid platform for running the application!'),
      ),
    );
  }
}
