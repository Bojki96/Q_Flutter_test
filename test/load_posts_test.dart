import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:q_flutter_test/models/api.dart';
import 'package:q_flutter_test/models/posts_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostsAdapter());
  await Hive.openBox('posts');
  group('Load posts', () {
    test('Convert json to posts', (() {
      String json = '';
      Posts posts = Posts();

      expect(postsFromJson(json).first, posts);
    }));

    test('Fetching limited number of posts', (() async {
      ApiRepository _apiRepository = ApiRepository();
      ApiResponse<List<Posts>> apiResponse;
      List<Posts> posts = [];
      apiResponse =
          await _apiRepository.fetchNewPosts(oldPosts: posts, postID: 20);
      if (apiResponse.success) {
        List<Posts> posts = apiResponse.data!;
        expect(posts.first.postId, 18);
      } else {
        expect(apiResponse.error, 'Data not found, check internet connection!');
      }
      expect(posts.length, 25);
    }));

    test('Load new posts - first data', () async {
      ApiRepository _apiRepository = ApiRepository();
      ApiResponse<List<Posts>> apiResponse;
      apiResponse = await _apiRepository.fetchPosts();
      if (apiResponse.success) {
        List<Posts> posts = apiResponse.data!;
        expect(posts.first.postId, 18);
      } else {
        expect(apiResponse.error, 'Data not found, check internet connection!');
      }
    });

    test('API Response', () async {
      ApiRepository _apiRepository = ApiRepository();
      ApiResponse<List<Posts>> apiResponse;
      apiResponse = await _apiRepository.fetchPosts();
      if (apiResponse.success) {
        expect(apiResponse.data!.last.id, 25);
      } else {
        expect(apiResponse.error, 'Data not found, check internet connection!');
      }
    });
  });
}
