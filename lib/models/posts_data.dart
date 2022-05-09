import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:hive/hive.dart';
part 'posts_data.g.dart';

List<Posts> postsFromJson(String str) =>
    List<Posts>.from(json.decode(str).map((x) => Posts.fromJson(x)));

@HiveType(typeId: 0)
class Posts extends HiveObject {
  Posts({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  @HiveField(0)
  int? postId;
  @HiveField(1)
  int? id;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? body;

  factory Posts.fromJson(Map<String, dynamic> json) {
    HtmlUnescape unescape = HtmlUnescape();
    return Posts(
      postId: json["postId"],
      id: json["id"],
      name: unescape.convert(json["name"]),
      email: json["email"],
      body: unescape.convert(json["body"]),
    );
  }
}
