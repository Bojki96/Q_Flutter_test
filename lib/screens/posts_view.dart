import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:q_flutter_test/models/local_posts.dart';
import 'package:q_flutter_test/models/posts_data.dart';

class PostsView extends StatefulWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  Posts post = Posts();
  late RefreshController _refreshController;
  int _postNumber = 4;
  List<Posts> posts = [];

  void _onRefresh() async {
    _postNumber = 4;
    await post.fetchPosts().then((value) => posts = value);
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    _postNumber += 3;
    await post
        .loadNewPosts(postNumber: _postNumber, oldPosts: posts)
        .then((value) => posts = value);
    setState(() {
      _refreshController.loadComplete();
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    post.fetchPosts().then((value) {
      setState(() {
        posts = value;
        print('POSTS: $posts');
        LocalPosts.save(posts: posts);
        _refreshController.refreshCompleted();
        LocalPosts.get().then((value) => print(value[10].email));
      });
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _postNumber = 4;
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
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                showBottomBorder: true,
                //  columnSpacing: 30,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('PostID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('E-mail')),
                  DataColumn(label: Text('Body'))
                ],
                rows: getRowData(posts: posts)),
          ),
        ),
      ),
    ));
  }

  List<DataRow> getRowData({@required List<Posts>? posts}) {
    List<DataRow> rowContent = [];
    posts!.forEach(
        (post) => rowContent.add(DataRow(cells: getCellData(post: post))));
    return rowContent;
  }

  List<DataCell> getCellData({@required Posts? post}) {
    List<DataCell> cellsContent = [
      DataCell(Text('${post!.id}')),
      DataCell(Text('${post.postId}')),
      DataCell(Text('${post.name}')),
      DataCell(Text('${post.email}')),
      DataCell(Text('${post.body}'))
    ];
    return cellsContent;
  }
}