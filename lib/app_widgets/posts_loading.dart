import 'package:flutter/material.dart';

class PostsLoading extends StatelessWidget {
  const PostsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
