import 'package:flutter/material.dart';
import '../models/posts_data.dart';

class PostsLoaded extends StatelessWidget {
  const PostsLoaded({Key? key, @required this.posts}) : super(key: key);
  final List<Posts>? posts;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
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
