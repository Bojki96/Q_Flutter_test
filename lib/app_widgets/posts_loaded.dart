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
            rows: getRowData(posts: posts, context: context)));
  }

  List<DataRow> getRowData(
      {@required List<Posts>? posts, @required BuildContext? context}) {
    List<DataRow> rowContent = [];
    posts!.forEach((post) => rowContent
        .add(DataRow(cells: getCellData(post: post, context: context))));
    return rowContent;
  }

  List<DataCell> getCellData(
      {@required Posts? post, @required BuildContext? context}) {
    List<DataCell> cellsContent = [
      DataCell(TextButton(
        child: Text('${post!.id}'),
        onPressed: () {
          showCellContent(context: context);
        },
      )),
      DataCell(TextButton(
        child: Text('${post.postId}'),
        onPressed: () {},
      )),
      DataCell(TextButton(
        child: Text('${post.name}'),
        onPressed: () {},
      )),
      DataCell(TextButton(child: Text('${post.email}'), onPressed: () {})),
      DataCell(
        TextButton(
          child: Text('${post.body}'),
          onPressed: () {},
        ),
      )
    ];
    return cellsContent;
  }

  Future showCellContent({BuildContext? context}) {
    return showDialog(
        context: context!,
        builder: (context) {
          return AboutDialog();
        });
  }
}
