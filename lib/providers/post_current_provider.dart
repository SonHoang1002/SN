import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class PostCurrentState {
  dynamic currentPost;

  PostCurrentState({this.currentPost = const {}});

  PostCurrentState copyWith({
    dynamic posts = const {},
  }) {
    return PostCurrentState(
      currentPost: posts,
    );
  }
}

final currentPostControllerProvider =
    StateNotifierProvider.autoDispose<PostCurrentController, PostCurrentState>((ref) {
  return PostCurrentController();
});

class PostCurrentController extends StateNotifier<PostCurrentState> {
  PostCurrentController() : super(PostCurrentState());
  saveCurrentPost(dynamic newPost) {
    state = state.copyWith(posts: newPost);
  }
}
