import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

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
    StateNotifierProvider<PostCurrentController, PostCurrentState>((ref) {
  return PostCurrentController();
});

class PostCurrentController extends StateNotifier<PostCurrentState> {
  PostCurrentController() : super(PostCurrentState());
  saveCurrentPost(dynamic newPost) {
    state = state.copyWith(posts: newPost);
  }
}
