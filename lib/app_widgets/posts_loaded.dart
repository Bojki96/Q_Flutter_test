import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
            columnSpacing: 40,
            dataRowHeight: 60,
            border: const TableBorder(
                left: BorderSide(
                    width: 0.5, color: Color.fromARGB(255, 79, 255, 0)),
                right: BorderSide(
                    width: 0.5, color: Color.fromARGB(255, 79, 255, 0)),
                verticalInside: BorderSide(
                    width: 0.5, color: Color.fromARGB(255, 79, 255, 0))),
            headingRowColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 79, 255, 0)),
            dividerThickness: 0.0,
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
    for (var post in posts!) {
      rowContent.add(DataRow(cells: getCellData(post: post)));
    }
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
        child: Text(
          content!,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.fade,
        ),
        onPressed: () {
          showCellContent(context: context, title: title, content: content);
        },
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )),
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.transparent,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary),
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
            maximumSize: MaterialStateProperty.all<Size>(const Size(200, 100))
            // elevation: MaterialStateProperty.all<double>(10),
            // shadowColor:
            //     MaterialStateProperty.all<Color>(Color.fromARGB(255, 79, 255, 0)),
            ),
      ),
    );
  }

  Future showCellContent(
      {BuildContext? context, String? title, String? content}) {
    return Platform.isAndroid
        ? showDialog(
            context: context!,
            builder: (context) => AlertDialog(
              title: Text(
                title!,
                style: const TextStyle(color: Colors.black),
              ),
              content: Text(
                content!,
                style: const TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                )
              ],
            ),
          )
        : showCupertinoDialog(
            context: context!,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(title!),
                  content: SingleChildScrollView(child: Text(content!)),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ));
  }
}
