import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';

@immutable
class PostState {
  final List posts;
  final List postsPin;
  final bool isMore;

  final List postUserPage;
  final bool isMoreUserPage;

  const PostState(
      {this.posts = const [],
      this.postUserPage = const [],
      this.postsPin = const [],
      this.isMore = true,
      this.isMoreUserPage = true});

  PostState copyWith(
      {List posts = const [],
      List postUserPage = const [],
      List postsPin = const [],
      bool isMore = true,
      bool isMoreUserPage = true}) {
    return PostState(
        posts: posts,
        postUserPage: postUserPage,
        postsPin: postsPin,
        isMore: isMore,
        isMoreUserPage: isMoreUserPage);
  }
}

final postControllerProvider =
    StateNotifierProvider<PostController, PostState>((ref) => PostController());

class PostController extends StateNotifier<PostState> {
  PostController() : super(const PostState());

  getListPost(params) async {
    List response = await PostApi().getListPostApi(params) ?? [];
    state = state.copyWith(
        posts: state.posts + response,
        postsPin: state.postsPin,
        postUserPage: state.postUserPage,
        isMore: response.length < params['limit'] ? false : true,
        isMoreUserPage: state.isMoreUserPage);
  }

  getListPostUserPage(accountId, params) async {
    List response = await UserPageApi().getListPostApi(accountId, params) ?? [];

    state = state.copyWith(
        posts: state.posts,
        postsPin: state.postsPin,
        postUserPage: state.postUserPage + response,
        isMore: state.isMore,
        isMoreUserPage: response.length < params['limit'] ? false : true);
  }

  getListPostPin(accountId) async {
    List response = await PostApi().getListPostPinApi(accountId) ?? [];

    state = state.copyWith(
        postsPin: response,
        posts: state.posts,
        isMore: state.isMore,
        postUserPage: state.postUserPage,
        isMoreUserPage: state.isMoreUserPage);
  }

  createUpdatePost(type, newPost) {
    state = state.copyWith(
        postsPin: state.postsPin,
        posts: type == feedPost ? [newPost] + state.posts : state.posts,
        isMore: state.isMore,
        postUserPage: state.postUserPage,
        isMoreUserPage: state.isMoreUserPage);
  }

  actionPinPost(type, postId) async {
    dynamic response;
    if (type == 'pin') {
      response = await PostApi().pinPostApi(postId);
      if (response == null) return;

      state = state.copyWith(
          postsPin: state.postsPin + [response],
          isMore: state.isMore,
          posts: state.posts,
          postUserPage: state.postUserPage
              .where((element) => element['id'] != response['id'])
              .toList(),
          isMoreUserPage: state.isMoreUserPage);
    } else if (type == 'unpin') {
      response = await PostApi().unPinPostApi(postId);
      if (response == null) return;
      state = state.copyWith(
          postsPin: state.postsPin
              .where((element) => element['id'] != response['id'])
              .toList(),
          postUserPage: [response] + state.postUserPage,
          isMore: state.isMore,
          isMoreUserPage: state.isMoreUserPage,
          posts: state.posts);
    }
  }

  refreshListPost(params) async {
    List response = await PostApi().getListPostApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          posts: response,
          postsPin: state.postsPin,
          postUserPage: state.postUserPage,
          isMoreUserPage: state.isMoreUserPage,
          isMore: response.length < params['limit'] ? false : true);
    } else {
      state = state.copyWith(
          isMore: false,
          posts: response,
          postsPin: state.postsPin,
          postUserPage: state.postUserPage,
          isMoreUserPage: state.isMoreUserPage);
    }
  }
}
