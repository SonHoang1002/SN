import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';

@immutable
class PostState {
  final List posts;
  final List postsPin;
  final bool isMore;

  const PostState(
      {this.posts = const [], this.postsPin = const [], this.isMore = true});

  PostState copyWith(
      {List posts = const [], List postsPin = const [], bool isMore = true}) {
    return PostState(posts: posts, postsPin: postsPin, isMore: isMore);
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

  getListPostPin(accountId) async {
    List response = await PostApi().getListPostPinApi(accountId) ?? [];

    state = state.copyWith(postsPin: response);
  }

  actionPinPost(type, postId) async {
    dynamic response;
    if (type == 'pin') {
      response = await PostApi().pinPostApi(postId);
      if (response == null) return;

      state = state.copyWith(
          postsPin: state.postsPin + [response],
          posts: state.posts
              .where((element) => element['id'] != response['id'])
              .toList());
    } else if (type == 'unpin') {
      response = await PostApi().unPinPostApi(postId);
      if (response == null) return;
      state = state.copyWith(
          postsPin: state.postsPin
              .where((element) => element['id'] != response['id'])
              .toList(),
          posts: [response] + state.posts);
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
