import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

List<Posts> postsFromJson(String str) =>
    List<Posts>.from(json.decode(str).map((x) => Posts.fromJson(x)));

String postsToJson(List<Posts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Posts {
  Posts({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  int? postId;
  int? id;
  String? name;
  String? email;
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

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "id": id,
        "name": name,
        "email": email,
        "body": body,
      };

  Future<List<Posts>> fetchPosts() async {
    List<Posts> posts = [];
    for (int i = 1; i < 5; i++) {
      final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=$i'));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        posts.addAll(postsFromJson(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load posts');
      }
    }
    return posts;
  }

  Future<List<Posts>> loadNewPosts(
      {int postNumber = 5, List<Posts>? oldPosts}) async {
    List<Posts> newPosts = [...oldPosts!];

    for (int i = postNumber - 2; i <= postNumber; i++) {
      final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=$i'));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        newPosts.addAll(postsFromJson(response.body));
        //return newPosts;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load posts');
      }
    }
    return newPosts;
  }
}
