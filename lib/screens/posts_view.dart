import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:q_flutter_test/app_widgets/posts_error.dart';
import 'package:q_flutter_test/app_widgets/posts_loaded.dart';
import 'package:q_flutter_test/app_widgets/posts_loading.dart';
import 'package:q_flutter_test/models/posts_data.dart';
import 'package:q_flutter_test/models/posts_state.dart';
import 'package:q_flutter_test/models/state_provider.dart';

class PostsView extends ConsumerStatefulWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  ConsumerState<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends ConsumerState<PostsView>
    with WidgetsBindingObserver {
  Posts post = Posts();
  late RefreshController _refreshController;
  int _postID = 5;
  List<Posts> posts = [];
  StreamSubscription<ConnectivityResult>? subscription;
  bool hideInitialConnection = true;
  bool wentOffline = false;
  bool initialRefresh = true;
  bool initialOffline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _refreshController = RefreshController();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (!hideInitialConnection) {
        if (result != ConnectivityResult.none) {
          if (initialOffline) {
            await _refreshController.requestRefresh();
            initialOffline = false;
          } else {
            online(posts);
          }
        } else {
          offline();
        }
      }
    });
    _onRefresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // await Hive.close();
    } else if (state == AppLifecycleState.resumed) {
      hideInitialConnection = true;
      // await Hive.openBox<Posts>('posts');
    } else if (state == AppLifecycleState.paused) {
      // await Hive.close();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _postID = 5;
    Hive.close();
    subscription!.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 79, 255, 0),
          title: const Center(
              child: Text(
            'Q Test',
            style: TextStyle(color: Colors.black),
          )),
          elevation: 0,
        ),
        body: SafeArea(
          child: SizedBox(
            width: screenWidth,
            child: SmartRefresher(
              enablePullUp: !wentOffline &&
                  (ref.watch(postsNotifierProvider) is! PostsNoInternetState),
              enablePullDown: !wentOffline,
              controller: _refreshController,
              onLoading: () => _onLoading(
                  posts: posts,
                  offlineUse:
                      ref.watch(postsNotifierProvider) is PostsLocalStorage),
              onRefresh: _onRefresh,
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(postsNotifierProvider);
                  if (state is PostsInitialState) {
                    return const PostsLoading();
                  } else if (state is PostsNoInternetState) {
                    hideInitialConnection = false;
                    initialOffline = true;
                    return PostsError(
                      error: state.error,
                      isConnected: false,
                      ref: ref,
                    );
                  } else if (state is PostsLoadedState) {
                    posts = state.posts;
                    hideInitialConnection = false;
                    return PostsLoaded(
                      posts: posts,
                    );
                  } else if (state is PostsLocalStorage) {
                    posts = state.posts;
                    hideInitialConnection = false;
                    return PostsLoaded(posts: posts);
                  } else {
                    hideInitialConnection = false;
                    return PostsError(
                        error: (state as PostsErrorState).error,
                        isConnected: true);
                  }
                },
              ),
            ),
          ),
        ));
  }

  void _onRefresh() async {
    ref.read(postsNotifierProvider.notifier).getPosts(
        refreshController: _refreshController,
        refresh: true,
        initialRefresh: initialRefresh);
    initialRefresh = false;
    _postID = 5;
  }

  void _onLoading({List<Posts>? posts, bool offlineUse = false}) async {
    _postID += 3;
    if (!offlineUse) {
      ref.read(postsNotifierProvider.notifier).getPosts(
          refresh: false,
          oldPosts: posts,
          postID: _postID,
          refreshController: _refreshController);
    } else {
      ref.read(postsNotifierProvider.notifier).loadMoreOffinePosts(
          oldPosts: posts!, refreshController: _refreshController);
    }
  }

  void offline() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Lost internet connection!",
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.red,
    ));
    setState(() {
      wentOffline = true;
    });
    hideInitialConnection = false;
  }

  void online(List<Posts> posts) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "You are back online!",
      ),
      backgroundColor: Color.fromARGB(255, 79, 255, 0),
    ));
    ref.read(postsNotifierProvider.notifier).backOnline(posts);
    setState(() {
      wentOffline = false;
    });
    hideInitialConnection = false;
  }
}
