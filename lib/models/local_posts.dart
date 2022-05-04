import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:q_flutter_test/models/posts_data.dart';

class LocalPosts {
  static Box<Posts> get getLocalPostBox => Hive.box<Posts>('posts');

  static void save({@required List<Posts>? posts}) async {
    for (int i = 0; i < posts!.length; i++) {
      await LocalPosts.getLocalPostBox.put(posts[i].id, posts[i]);
    }
  }

  static Future<List<Posts>> get() async {
    List<Posts> posts = [];
    for (int i = 0; i < LocalPosts.getLocalPostBox.length; i++) {
      posts.add(LocalPosts.getLocalPostBox.getAt(i)!);
    }
    return posts;
  }
}
