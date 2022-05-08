import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:q_flutter_test/models/connection.dart';
import 'package:q_flutter_test/models/local_storage.dart';
import 'package:q_flutter_test/models/posts_data.dart';
import 'api.dart';
import 'posts_state.dart';

final postsNotifierProvider = StateNotifierProvider<PostsNotifier, PostsState>(
  (ref) => PostsNotifier(
    ApiRepository(),
  ),
);

class PostsNotifier extends StateNotifier<PostsState> {
  final ApiRepository _apiRepository;

  PostsNotifier(this._apiRepository) : super(PostsInitialState());

  void getPosts({
    RefreshController? refreshController,
    bool? refresh,
    List<Posts>? oldPosts,
    int? postID,
    bool offlineUse = false,
    bool initialRefresh = false,
  }) async {
    ApiResponse<List<Posts>> posts;
    if (await Network.statusOnline()) {
      // state = PostsLoadingState();
      if (refresh!) {
        if (initialRefresh) state = PostsInitialState();
        posts = await _apiRepository.fetchPosts();
        refreshController!.refreshCompleted();
      } else {
        posts = await _apiRepository.fetchNewPosts(
            oldPosts: oldPosts, postID: postID);
        refreshController!.loadComplete();
      }
      if (posts.success) {
        state = PostsLoadedState(posts.data!);
      } else {
        state = PostsErrorState(posts.error!);
      }
    } else {
      if (offlineUse) {
        wentOffline();
      } else {
        state = const PostsNoInternetState(
            'An error occured, check internet connection!');
        refresh!
            ? refreshController!.refreshCompleted()
            : refreshController!.loadComplete();
      }
    }
  }

  void wentOffline() async {
    state = PostsInitialState();

    List<Posts> posts = LocalStorage.getInitial();
    await Future.delayed(Duration(seconds: 1));
    state = PostsLocalStorage(posts);
  }

  void loadMoreOffinePosts(
      {required List<Posts> oldPosts,
      required RefreshController refreshController}) async {
    List<Posts> posts = await LocalStorage.loadMorePosts(
        oldPosts: oldPosts, refreshController: refreshController);
    state = PostsLocalStorage(posts);
  }

  void backOnline(List<Posts> posts) => state = PostsLoadedState(posts);
  // void load(
  //     {List<Posts>? oldPosts,
  //     int? postID,
  //     RefreshController? refreshController}) async {
  //   if (await Network.checkConnection()) {
  //     state = PostsLoadedState(oldPosts!);
  //     final newPosts = await _apiRepository.fetchNewPosts(
  //         oldPosts: oldPosts, postID: postID);
  //     refreshController!.loadComplete();
  //     if (newPosts.success) {
  //       state = PostsLoadedState(newPosts.data!);
  //     } else {
  //       state = PostsErrorState(newPosts.error!);
  //     }
  //   } else {
  //     state =
  //         const PostsErrorState('An error occured, check internet connection!');
  //   }
  // }
}
