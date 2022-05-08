import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:q_flutter_test/models/posts_data.dart';

class LocalStorage {
  static Box<Posts> get getLocalPostBox => Hive.box<Posts>('posts');

  static void save({@required List<Posts>? posts}) async {
    for (int i = 0; i < posts!.length; i++) {
      await LocalStorage.getLocalPostBox.put(posts[i].id, posts[i]);
    }
  }

  static List<Posts> getInitial() {
    List<Posts> posts = [];
    for (int i = 0; i < 25; i++) {
      if (LocalStorage.getLocalPostBox.getAt(i)!.isInBox) {
        posts.add(LocalStorage.getLocalPostBox.getAt(i)!);
      } else {
        return posts;
      }
    }
    return posts;
  }

  static Future<List<Posts>> loadMorePosts(
      {required List<Posts>? oldPosts,
      RefreshController? refreshController}) async {
    List<Posts> posts = [...oldPosts!];
    for (int i = oldPosts.length; i < oldPosts.length + 25; i++) {
      if (i < LocalStorage.getLocalPostBox.length - 1) {
        posts.add(LocalStorage.getLocalPostBox.getAt(i)!);
      } else {
        refreshController!.loadNoData();
        return posts;
      }
    }
    await Future.delayed(const Duration(seconds: 1));
    refreshController!.loadComplete();
    return posts;
  }

  static Posts get getLastPost =>
      getLocalPostBox.getAt(getLocalPostBox.length - 1)!;

  static bool get boxIsEmpty => getLocalPostBox.isEmpty;
}
