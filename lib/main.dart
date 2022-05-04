import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flutter_test/screens/postsview.dart';

void main() {
  runApp(const QTest());
}

class QTest extends StatelessWidget {
  const QTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return MaterialApp(
        home: PostsView(),
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
