import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

  PostsNotifier(this._apiRepository) : super(PostsLoadingState());

  void refresh({
    RefreshController? refreshController,
  }) async {
    state = PostsLoadingState();
    final posts = await _apiRepository.fetchPosts();
    refreshController!.refreshCompleted();
    if (posts.success) {
      state = PostsLoadedState(posts.data!);
    } else {
      state = PostsErrorState(posts.error!);
    }
  }

  void load(
      {List<Posts>? posts,
      int? postID,
      RefreshController? refreshController}) async {
    state = PostsLoadedState(posts!);
    final newPosts =
        await _apiRepository.fetchNewPosts(posts: posts, postID: postID);
    refreshController!.loadComplete();
    if (newPosts.success) {
      state = PostsLoadedState(newPosts.data!);
    } else {
      state = PostsErrorState(newPosts.error!);
    }
  }
}
