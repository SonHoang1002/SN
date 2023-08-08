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

  /// data of current user
  final List postUserPage;
  final bool isMoreUserPage;

  /// data of another user
  final List postAnotherUserPage;
  final bool isMoreAnother;

  const PostState(
      {this.posts = const [],
      this.postUserPage = const [],
      this.postsPin = const [],
      this.isMore = true,
      this.postAnotherUserPage = const [],
      this.isMoreUserPage = true,
      this.isMoreAnother = true});

  PostState copyWith(
      {List posts = const [],
      List postUserPage = const [],
      List postsPin = const [],
      bool isMore = true,
      List postAnotherUserPage = const [],
      bool isMoreAnother = true,
      bool isMoreUserPage = true}) {
    return PostState(
        posts: posts,
        postUserPage: postUserPage,
        postsPin: postsPin,
        isMore: isMore,
        isMoreAnother: isMoreAnother,
        postAnotherUserPage: postAnotherUserPage,
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

  reset() {
    state = const PostState();
  }

  getListPost(params) async {
    List response = await PostApi().getListPostApi(params) ?? [];
    if (mounted) {
      state = state.copyWith(
          posts: checkObjectUniqueInList(state.posts + response, 'id'),
          postsPin: state.postsPin,
          postUserPage: state.postUserPage,
          isMore: response.length < params['limit'] ? false : true,
          postAnotherUserPage: state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  updatePostWhenScroll(String scrollDirection, dynamic newData) async {
    List result = state.posts;
    switch (scrollDirection) {
      // xóa 1 ở đầu và thêm 1 ở đuôi
      case "fromBottomToTop":
        result.removeLast();
        result.insert(0, newData);
        break;

      case "fromTopToBottom":
        result.removeAt(0);
        result.add(newData);
        break;
    }
    if (mounted) {
      state = state.copyWith(
          posts: result,
          postsPin: state.postsPin,
          postUserPage: state.postUserPage,
          isMore: true,
          postAnotherUserPage: state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  addListPost(List newData, dynamic params) {
    if (mounted) {
      state = state.copyWith(
          posts: checkObjectUniqueInList(state.posts + newData, 'id'),
          postsPin: state.postsPin,
          postUserPage: state.postUserPage,
          postAnotherUserPage: state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMore: newData.length < params['limit'] ? false : true,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  getListPostUserPage(bool isIdCurrentUser, accountId, params) async {
    List response = await UserPageApi().getListPostApi(accountId, params) ?? [];
    List newList = [];
    if (params["max_id"] != null) {
      newList = checkObjectUniqueInList(
          (isIdCurrentUser ? state.postUserPage : state.postAnotherUserPage) +
              response,
          'id');
    } else {
      newList = response;
    }

    if (mounted) {
      state = state.copyWith(
        posts: state.posts,
        postsPin: state.postsPin,
        postUserPage: isIdCurrentUser ? newList : state.postUserPage,
        postAnotherUserPage:
            !isIdCurrentUser ? newList : state.postAnotherUserPage,
        isMore: state.isMore,
        isMoreAnother: !isIdCurrentUser
            ? response.length < params['limit']
                ? false
                : true
            : state.isMoreAnother,
        isMoreUserPage: isIdCurrentUser
            ? response.length < params['limit']
                ? false
                : true
            : state.isMoreUserPage,
      );
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
          postAnotherUserPage: state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  createUpdatePost(dynamic type, dynamic newPost,
      {bool isIdCurrentUser = true}) {
    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: [feedPost, postPageUser].contains(type)
              ? [newPost] + state.posts
              : state.posts,
          isMore: state.isMore,
          postUserPage: isIdCurrentUser == true
              ? ([feedPost, postPageUser].contains(type))
                  ? [newPost] + state.postUserPage
                  : state.postUserPage
              : state.postUserPage,
          postAnotherUserPage: isIdCurrentUser == false
              ? ([feedPost, postPageUser].contains(type))
                  ? [newPost] + state.postAnotherUserPage
                  : state.postAnotherUserPage
              : state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  // only apply for first post of list post from post screen
  // Recently, create post from feed or userpage also show other page. Therefore, we should update on two page
  changeProcessingPost(dynamic newData, {bool isIdCurrentUser = true}) {
    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: [
            ...state.posts.sublist(0, 0),
            newData,
            ...state.posts.sublist(1)
          ],
          isMore: state.isMore,
          postUserPage: isIdCurrentUser == true
              ? [
                  ...state.postUserPage.sublist(0, 0),
                  newData,
                  ...state.postUserPage.sublist(1)
                ]
              : state.postUserPage,
          postAnotherUserPage: isIdCurrentUser == false
              ? [
                  ...state.postAnotherUserPage.sublist(0, 0),
                  newData,
                  ...state.postAnotherUserPage.sublist(1)
                ]
              : state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  removeProgessingPost() {
    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: [...state.posts.sublist(0, 0), ...state.posts.sublist(1)],
          isMore: state.isMore,
          postUserPage: [
            ...state.posts.sublist(0, 0),
            ...state.posts.sublist(1)
          ],
          postAnotherUserPage: state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
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
          postAnotherUserPage: state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  actionUpdatePostCount(String? preType, dynamic data) {
    int index = -1;
    if (preType == feedPost || preType == postDetailFromFeed) {
      index = state.posts.indexWhere((element) => element['id'] == data['id']);
    } else if (preType == postPageUser || preType == postDetailFromUserPage) {
      if (state.postsPin.isNotEmpty) {
        index =
            state.postsPin.indexWhere((element) => element['id'] == data['id']);
        if (index != -1) {
          state.postsPin[index] = data;
        }
      }
      index = state.postUserPage
          .indexWhere((element) => element['id'] == data['id']);
    }
    if (index < 0) return;

    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: preType == feedPost
              ? [
                  ...state.posts.sublist(0, index),
                  data,
                  ...state.posts.sublist(index + 1)
                ]
              : state.posts,
          isMore: state.isMore,
          postUserPage: preType == postPageUser
              ? [
                  ...state.postUserPage.sublist(0, index),
                  data,
                  ...state.postUserPage.sublist(index + 1)
                ]
              : state.postUserPage,
          postAnotherUserPage: state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  actionUpdateDetailInPost(dynamic type, dynamic data,
      {dynamic preType, bool isIdCurrentUser = true}) async {
    int index = -1;
    if (type == feedPost ||
        (preType == postDetailFromFeed) ||
        (type == postMultipleMedia && preType == feedPost)) {
      index = state.posts.indexWhere((element) => element['id'] == data['id']);
    } else if (type == postPageUser ||
        (preType == postDetailFromUserPage) ||
        (type == postMultipleMedia && preType == postPageUser)) {
      if (state.postsPin.isNotEmpty) {
        index =
            state.postsPin.indexWhere((element) => element['id'] == data['id']);
        if (index != -1) {
          state.postsPin[index] = data;
        }
      }
      if (isIdCurrentUser == true) {
        index = state.postUserPage
            .indexWhere((element) => element['id'] == data['id']);
      } else {
        index = state.postAnotherUserPage
            .indexWhere((element) => element['id'] == data['id']);
      }
    }
    if (index < 0) return;

    if (mounted) {
      state = state.copyWith(
          postsPin: state.postsPin,
          posts: type == feedPost ||
                  (preType != null && preType == postDetailFromFeed) ||
                  (type == postMultipleMedia && preType == feedPost)
              ? [
                  ...state.posts.sublist(0, index),
                  data,
                  ...state.posts.sublist(index + 1)
                ]
              : state.posts,
          isMore: state.isMore,
          postUserPage: isIdCurrentUser == true
              ? type == postPageUser ||
                      (preType != null && preType == postDetailFromUserPage) ||
                      (type == postMultipleMedia && preType == postPageUser)
                  ? [
                      ...state.postUserPage.sublist(0, index),
                      data,
                      ...state.postUserPage.sublist(index + 1)
                    ]
                  : state.postUserPage
              : state.postUserPage,
          postAnotherUserPage: isIdCurrentUser == false
              ? type == postPageUser ||
                      (preType != null && preType == postDetailFromUserPage) ||
                      (type == postMultipleMedia && preType == postPageUser)
                  ? [
                      ...state.postAnotherUserPage.sublist(0, index),
                      data,
                      ...state.postAnotherUserPage.sublist(index + 1)
                    ]
                  : state.postAnotherUserPage
              : state.postAnotherUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  actionHiddenDeletePost(dynamic type, dynamic data,
      {bool isIdCurrentUser = true}) {
    int index = -1;
    if (type == feedPost) {
      index = state.posts.indexWhere((element) => element['id'] == data['id']);
    } else if (type == postPageUser) {
      if (state.postsPin.isNotEmpty) {
        index =
            state.postsPin.indexWhere((element) => element['id'] == data['id']);
        if (index != -1) {
          state.postsPin.removeAt(index);
        }
      }
      if (isIdCurrentUser == true) {
        index = state.postUserPage
            .indexWhere((element) => element['id'] == data['id']);
      } else {
        index = state.postAnotherUserPage
            .indexWhere((element) => element['id'] == data['id']);
      }
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
          postUserPage: isIdCurrentUser == true
              ? type == postPageUser
                  ? [
                      ...state.postUserPage.sublist(0, index),
                      ...state.postUserPage.sublist(index + 1)
                    ]
                  : state.postUserPage
              : state.postUserPage,
          postAnotherUserPage: isIdCurrentUser == false
              ? type == postPageUser
                  ? [
                      ...state.postAnotherUserPage.sublist(0, index),
                      ...state.postAnotherUserPage.sublist(index + 1)
                    ]
                  : state.postUserPage
              : state.postUserPage,
          isMoreAnother: state.isMoreAnother,
          isMoreUserPage: state.isMoreUserPage);
    }
  }

  actionFriendModerationPost(type, data) {
    int index = -1;
    if (type == feedPost) {
      index = state.posts.indexWhere((element) => element['id'] == data['id']);
      state.posts[index] = data;
    } else if (type == postPageUser) {
      if (state.postsPin.isNotEmpty) {
        index =
            state.postsPin.indexWhere((element) => element['id'] == data['id']);
        state.postsPin[index] = data;
      }
      index = state.postUserPage
          .indexWhere((element) => element['id'] == data['id']);
      if (index != -1) {
        state.postUserPage[index] = data;
      }
    }
  }

  actionUpdatePost(type, data) {
    int index = -1;
    if (type == feedPost) {
      index = state.posts.indexWhere((element) => element['id'] == data['id']);
    } else if (type == postPageUser) {
      if (state.postsPin.isNotEmpty) {
        index =
            state.postsPin.indexWhere((element) => element['id'] == data['id']);
        if (index != -1) {
          state.postsPin[index] = data;
        }
      }
      index = state.postUserPage
          .indexWhere((element) => element['id'] == data['id']);
    }
    if (index < 0) return;
    if (mounted) {
      type == feedPost
          ? state.posts[index] = data
          : type == postPageUser
              ? state.postUserPage[index] = data
              : null;
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
            postAnotherUserPage: state.postAnotherUserPage,
            isMoreAnother: state.isMoreAnother,
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
            postAnotherUserPage: state.postAnotherUserPage,
            isMoreAnother: state.isMoreAnother,
            isMoreUserPage: state.isMoreUserPage);
      }
    }
  }

  removeListPost(type) async {
    if (mounted) {
      state = state.copyWith(
          isMore: true,
          posts: type == 'post' ? [] : state.posts,
          postsPin: type == 'user' ? [] : state.postsPin,
          postUserPage: type == 'user' ? [] : state.postUserPage,
          postAnotherUserPage: type == 'user' ? [] : state.postAnotherUserPage,
          isMoreAnother: type == 'user' ? true : false,
          isMoreUserPage: type == 'user' ? true : false);
    }
  }

  signPollPost(dynamic pollId, dynamic params, dynamic type) async {
    final response = await PostApi().signPollPost(pollId, params);
  }

  updatePollPost(dynamic pollId, dynamic params, dynamic type) async {
    final response = await PostApi().updatePollPost(pollId, params);
  }
}
