import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:q_flutter_test/models/postsdata.dart';

class PostsView extends StatefulWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  Posts post = Posts();
  late RefreshController _refreshController;
  int _postNumber = 1;
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
            future: post.fetchPosts(),
            builder: (context, AsyncSnapshot<List<Posts>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                    width: screenWidth,
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('An error occured while fetching data!'));
              } else if (snapshot.hasData) {
                List<Posts> posts = snapshot.data!;
                return SizedBox(
                  width: screenWidth,
                  child: SmartRefresher(
                    enablePullUp: true,
                    enablePullDown: true,
                    controller: _refreshController,
                    onLoading: () => post
                        .loadNewPosts(
                            postNumber: _postNumber++, oldPosts: posts)
                        .then((value) {
                      setState(() {});
                    }),
                    onRefresh: () => post.fetchPosts(),
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
                );
              } else {
                return Center(
                    child: Text('An error occured while fetching data!'));
              }
            }),
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
