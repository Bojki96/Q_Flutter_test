import 'package:flutter/material.dart';
import '../models/posts_data.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class PostsLoaded extends StatelessWidget {
  const PostsLoaded({Key? key, @required this.posts}) : super(key: key);
  final List<Posts>? posts;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            //showBottomBorder: false,
            columnSpacing: 30,
            dataRowHeight: 60,
            border: TableBorder(
                verticalInside: BorderSide(
                    width: 0.5, color: Color.fromARGB(255, 79, 255, 0))),
            headingRowColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 79, 255, 0)),
            // headingTextStyle: TextStyle(
            //     color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('PostID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('E-mail')),
              DataColumn(label: Text('Body'))
            ],
            rows: getRowData(posts: posts)));
  }

  List<DataRow> getRowData({@required List<Posts>? posts}) {
    List<DataRow> rowContent = [];
    posts!.forEach(
        (post) => rowContent.add(DataRow(cells: getCellData(post: post))));
    return rowContent;
  }

  List<DataCell> getCellData({@required Posts? post}) {
    List<DataCell> cellsContent = [
      DataCell(CellContent(
        title: 'ID',
        content: post!.id.toString(),
      )),
      DataCell(CellContent(
        title: 'PostID',
        content: post.postId.toString(),
      )),
      DataCell(CellContent(
        title: 'Name',
        content: post.name,
      )),
      DataCell(CellContent(
        title: 'E-mail',
        content: post.email,
      )),
      DataCell(CellContent(
        title: 'Body',
        content: post.body,
      )),
    ];
    return cellsContent;
  }
}

class CellContent extends StatelessWidget {
  const CellContent({
    required this.content,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String? content;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        child: SingleChildScrollView(
          child: Text(
            content!,
            // style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: () {
          showCellContent(context: context, title: title, content: content);
        },
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
              color: Colors.white,
            )),
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.transparent,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 79, 255, 0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            side: MaterialStateProperty.all<BorderSide>(const BorderSide(
              color: Color.fromARGB(255, 79, 255, 0),
              width: 1,
            )),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(8)),
            maximumSize: MaterialStateProperty.all<Size>(Size(200, 100))
            // elevation: MaterialStateProperty.all<double>(10),
            // shadowColor:
            //     MaterialStateProperty.all<Color>(Color.fromARGB(255, 79, 255, 0)),
            ),
      ),
    );
  }

  Future showCellContent(
      {BuildContext? context, String? title, String? content}) {
    return showDialog(
        context: context!,
        builder: (context) {
          return BasicDialogAlert(
              title: Text(
                title!,
                style: TextStyle(color: Colors.black),
              ),
              content: Text(
                content!,
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                BasicDialogAction(
                  title: const Text(
                    'OK',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]);
        });
  }
}
