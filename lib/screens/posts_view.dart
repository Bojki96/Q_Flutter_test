import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:q_flutter_test/app_widgets/posts_widget_states.dart';
import 'package:q_flutter_test/models/api.dart';
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
    // await post.fetchPosts().then((value) => posts = value);
    // setState(() {
    //   _refreshController.refreshCompleted();
    // });
    ref
        .read(postsNotifierProvider.notifier)
        .refresh(refreshController: _refreshController);

    //_refreshController.refreshCompleted();
  }

  void _onLoading({List<Posts>? posts}) async {
    _postID += 3;
    // await post
    //     .loadNewPosts(postNumber: _postNumber, oldPosts: posts)
    //     .then((value) => posts = value);
    // setState(() {
    //   _refreshController.loadComplete();
    // });
    ref.read(postsNotifierProvider.notifier).load(
        posts: posts, postID: _postID, refreshController: _refreshController);
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    // ref.read(postsNotifierProvider.notifier).refresh();
    // post.fetchPosts().then((value) {
    //   setState(() {
    //     posts = value;
    //     LocalStorage.save(posts: posts);
    //     _refreshController.refreshCompleted();
    //   });
    // });
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(postsNotifierProvider);
                if (state is PostsLoadingState) {
                  return postsLoaded(posts: posts);
                } else if (state is PostsLoadedState) {
                  posts = state.posts;
                  return postsLoaded(posts: state.posts);
                } else if (state is PostsErrorState) {
                  return postsError(width: screenWidth, error: state.error);
                } else {
                  return Text('NE RADI!');
                }
              },
            ),
          ),
        ),
      ),
    ));
  }
}
