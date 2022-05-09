import 'package:flutter/material.dart';
import 'posts_data.dart';

@immutable
abstract class PostsState {
  const PostsState();

  // @override
  // List<Object> get props => [];
}

class PostsInitialState extends PostsState {}

//class PostsLoadingState extends PostsState {}

class PostsLoadedState extends PostsState {
  final List<Posts> posts;

  const PostsLoadedState(this.posts);
}

class PostsErrorState extends PostsState {
  final String error;

  const PostsErrorState(this.error);
}

class PostsNoInternetState extends PostsState {
  final String error;

  const PostsNoInternetState(this.error);
}

class PostsLocalStorage extends PostsState {
  final List<Posts> posts;
  const PostsLocalStorage(this.posts);
}
