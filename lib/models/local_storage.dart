import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:q_flutter_test/models/posts_data.dart';

class LocalStorage {
  static Box<Posts> get getLocalPostBox => Hive.box<Posts>('posts');

  static void save({@required List<Posts>? posts}) async {
    //await Hive.openBox<Posts>('posts');
    for (int i = 0; i < posts!.length; i++) {
      await LocalStorage.getLocalPostBox.put(posts[i].id, posts[i]);
    }
    // Hive.close();
  }

  static List<Posts> get() {
    // await Hive.openBox<Posts>('posts');
    List<Posts> posts = [];
    for (int i = 0; i < LocalStorage.getLocalPostBox.length; i++) {
      posts.add(LocalStorage.getLocalPostBox.getAt(i)!);
    }
    //Hive.close();
    return posts;
  }
}
