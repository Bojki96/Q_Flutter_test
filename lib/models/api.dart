import 'package:http/http.dart' as http;
import 'package:q_flutter_test/models/local_storage.dart';
import 'package:q_flutter_test/models/posts_data.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse({this.success = true, this.data, this.error})
      : assert(
          (success && error == null && data != null) ||
              (!success && error != null && data == null),
        );
}

class ApiService {
  Future<ApiResponse<List<Posts>>> fetchPosts() async {
    List<Posts> posts = [];
    for (int i = 1; i < 5; i++) {
      try {
        final response = await http.get(Uri.parse(
            'https://jsonplaceholder.typicode.com/comments?postId=$i'));
        posts.addAll(postsFromJson(response.body));
      } catch (error) {
        return ApiResponse(
          success: false,
          error: "Data not found, check internet connection!",
        );
      }
    }
    LocalStorage.save(posts: posts);
    return ApiResponse(data: posts);
  }

  Future<ApiResponse<List<Posts>>> fetchNewPosts(
      {List<Posts>? oldPosts, int postID = 5}) async {
    List<Posts> posts = [...oldPosts!];
    for (int i = postID - 2; i <= postID; i++) {
      try {
        final response = await http.get(Uri.parse(
            'https://jsonplaceholder.typicode.com/comments?postId=$i'));
        posts.addAll(postsFromJson(response.body));
      } catch (error) {
        return ApiResponse(
          success: false,
          error: "Data not found, check internet connection!",
        );
      }
    }
    LocalStorage.save(posts: posts);
    return ApiResponse(data: posts);
  }
}

class ApiRepository {
  final _provider = ApiService();

  Future<ApiResponse<List<Posts>>> fetchPosts() {
    return _provider.fetchPosts();
  }

  Future<ApiResponse<List<Posts>>> fetchNewPosts(
      {List<Posts>? oldPosts, int? postID}) {
    return _provider.fetchNewPosts(oldPosts: oldPosts, postID: postID!);
  }
}
