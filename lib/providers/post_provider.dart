import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

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
    StateNotifierProvider.autoDispose<PostController, PostState>((ref) {
  ref.read(meControllerProvider);
  return PostController();
});

class PostController extends StateNotifier<PostState> {
  PostController() : super(const PostState());

  getListPost(params) async {
    List response = await PostApi().getListPostApi(params) ?? [];
    if (mounted) {
      state = state.copyWith(
          posts: checkObjectUniqueInList(state.posts + response, 'id'),
          postsPin: state.postsPin,
          postUserPage: state.postUserPage,
          isMore: response.length < params['limit'] ? false : true,
          // isMore: true,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  getListPostUserPage(accountId, params) async {
    List response = await UserPageApi().getListPostApi(accountId, params) ?? [];
    if (mounted) {
      state = state.copyWith(
          posts: state.posts,
          postsPin: state.postsPin,
          postUserPage:
              checkObjectUniqueInList(state.postUserPage + response, 'id'),
          isMore: state.isMore,
          isMoreUserPage: response.length < params['limit'] ? false : true);
      // isMoreUserPage: true);
    }
  }

  getListPostPin(accountId) async {
    List response = await PostApi().getListPostPinApi(accountId) ?? [];
    if (mounted) {
      state = state.copyWith(
          postsPin: response,
          posts: state.posts,
          isMore: state.isMore,
          postUserPage: state.postUserPage,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  createUpdatePost(type, newPost) {
    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: type == feedPost ? [newPost] + state.posts : state.posts,
          isMore: state.isMore,
          postUserPage: [feedPost, postPageUser].contains(type)
              ? [newPost] + state.postUserPage
              : state.postUserPage,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  actionPinPost(type, post) async {
    if (mounted) {
      state = state.copyWith(
          postsPin: type == 'pin_post'
              ? state.postsPin + [post]
              : state.postsPin
                  .where((element) => element['id'] != post['id'])
                  .toList(),
          isMore: state.isMore,
          posts: state.posts,
          postUserPage: type == 'pin_post'
              ? state.postUserPage
                  .where((element) => element['id'] != post['id'])
                  .toList()
              : [post] + state.postUserPage,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  actionUpdateDetailInPost(type, data) async {
    int index = -1;

    if (type == feedPost) {
      index = state.posts.indexWhere((element) => element['id'] == data['id']);
    } else if (type == postPageUser) {
      index = state.postUserPage
          .indexWhere((element) => element['id'] == data['id']);
    }

    if (index < 0) return;
    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: type == feedPost
              ? [
                  ...state.posts.sublist(0, index),
                  data,
                  ...state.posts.sublist(index + 1)
                ]
              : state.posts,
          isMore: state.isMore,
          postUserPage: type == postPageUser
              ? [
                  ...state.postUserPage.sublist(0, index),
                  data,
                  ...state.postUserPage.sublist(index + 1)
                ]
              : state.postUserPage,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  actionHiddenDeletePost(type, data) {
    int index = -1;

    if (type == feedPost) {
      index = state.posts.indexWhere((element) => element['id'] == data['id']);
    } else if (type == postPageUser) {
      index = state.postUserPage
          .indexWhere((element) => element['id'] == data['id']);
    }

    if (index < 0) return;
    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: type == feedPost
              ? [
                  ...state.posts.sublist(0, index),
                  ...state.posts.sublist(index + 1)
                ]
              : state.posts,
          isMore: state.isMore,
          postUserPage: type == postPageUser
              ? [
                  ...state.postUserPage.sublist(0, index),
                  ...state.postUserPage.sublist(index + 1)
                ]
              : state.posts,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  refreshListPost(params) async {
    List response = await PostApi().getListPostApi(params);
    if (response.isNotEmpty) {
      if (mounted) {
        state = state.copyWith(
            posts: response,
            postsPin: state.postsPin,
            postUserPage: state.postUserPage,
            isMoreUserPage: state.isMoreUserPage,
            isMore: response.length < params['limit'] ? false : true);
      }
    } else {
      if (mounted) {
        state = state.copyWith(
            isMore: false,
            posts: response,
            postsPin: state.postsPin,
            postUserPage: state.postUserPage,
            isMoreUserPage: state.isMoreUserPage);
      }
    }
  }

  removeListPost(type) async {
    if (mounted) {
      state = state.copyWith(
          isMore: true,
          posts: type == 'post' ? [] : state.posts,
          postsPin: type == 'user' ? [] : state.posts,
          postUserPage: type == 'user' ? [] : state.posts,
          isMoreUserPage: type == 'user' ? true : false);
    }
  }
}
