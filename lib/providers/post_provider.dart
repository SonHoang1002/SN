import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';

@immutable
class PostState {
  final List posts;
  final bool isMore;

  const PostState({this.posts = const [], this.isMore = true});

  PostState copyWith({List posts = const [], bool isMore = true}) {
    return PostState(posts: posts, isMore: isMore);
  }
}

final postControllerProvider =
    StateNotifierProvider<PostController, PostState>((ref) => PostController());

class PostController extends StateNotifier<PostState> {
  PostController() : super(const PostState());

  getListPost(params) async {
    List response = await PostApi().getListPostApi(params) ?? [];

    if (response.isNotEmpty) {
      state = state.copyWith(
          posts: state.posts + response,
          isMore: response.length < params['limit'] ? false : true);
    } else {
      state = state.copyWith(isMore: false);
    }
  }

  refreshListPost(params) async {
    List response = await PostApi().getListPostApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          posts: response,
          isMore: response.length < params['limit'] ? false : true);
    } else {
      state = state.copyWith(isMore: false);
    }
  }
}
