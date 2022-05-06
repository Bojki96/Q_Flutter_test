import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:q_flutter_test/models/local_storage.dart';
import 'package:q_flutter_test/models/state_provider.dart';

import '../models/posts_data.dart';

class PostsError extends StatelessWidget {
  PostsError(
      {Key? key, @required this.error, @required this.isConnected, this.ref})
      : super(key: key);
  final String? error;
  final bool? isConnected;
  WidgetRef? ref;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isConnected!
              ? Icons.error_outline_outlined
              : Icons.signal_wifi_connected_no_internet_4,
          size: 50,
          color: Colors.red[700],
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          error!,
          style: TextStyle(fontSize: 23),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
            onPressed: () {
              if (LocalStorage.boxIsEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  'There are no data saved yet!',
                  style: TextStyle(color: Colors.red[700]),
                )));
              } else {
                ref!
                    .read(postsNotifierProvider.notifier)
                    .getPosts(offlineUse: true);
              }
            },
            child: Text('Use offline'))
      ],
    );
  }
}
