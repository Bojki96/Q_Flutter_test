import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:q_flutter_test/app_widgets/posts_error.dart';
import 'package:q_flutter_test/app_widgets/posts_loaded.dart';
import 'package:q_flutter_test/models/local_storage.dart';
import 'package:q_flutter_test/models/posts_data.dart';
import 'package:q_flutter_test/models/posts_state.dart';
import 'package:q_flutter_test/models/state_provider.dart';

class PostsView extends ConsumerStatefulWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  ConsumerState<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends ConsumerState<PostsView> {
  Posts post = Posts();
  late RefreshController _refreshController;
  int _postID = 4;
  List<Posts> posts = [];

  void _onRefresh() async {
    _postID = 4;
    ref
        .read(postsNotifierProvider.notifier)
        .getPosts(refreshController: _refreshController, refresh: true);
  }

  void _onLoading({List<Posts>? posts}) async {
    _postID += 3;
    ref.read(postsNotifierProvider.notifier).getPosts(
        refresh: false,
        oldPosts: posts,
        postID: _postID,
        refreshController: _refreshController);
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _postID = 4;
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: screenWidth,
        child: SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: _refreshController,
          onLoading: () => _onLoading(posts: posts),
          onRefresh: _onRefresh,
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(postsNotifierProvider);
              if (state is PostsNoInternetState) {
                return PostsError(
                  error: state.error,
                  isConnected: false,
                  ref: ref,
                );
              } else if (state is PostsLoadingState) {
                return PostsLoaded(posts: posts);
              } else if (state is PostsLoadedState) {
                posts = state.posts;
                return PostsError(
                  isConnected: false,
                  error: 'An error occured, check internet connection!',
                  ref: ref,
                );
                // return PostsLoaded(
                //   posts: posts,
                // );
              } else if (state is PostsLocalStorage) {
                posts = LocalStorage.get();
                print(posts);
                return PostsLoaded(posts: posts);
              } else {
                return PostsError(
                    error: (state as PostsErrorState).error, isConnected: true);
              }
            },
          ),
        ),
      ),
    ));
  }
}
