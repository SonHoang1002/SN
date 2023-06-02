import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';

@immutable
class PageState {
  final bool rolePage;
  final List pageFeed;
  final bool isMoreFeed;
  final List pageReview;
  final bool isMoreReview;
  final List pagePined;
  final List pagePhoto;
  final bool isMorePhoto;
  final List pageAlbum;
  final bool isMoreAlbum;
  final List pageVideo;
  final bool isMoreVideo;
  final List pageGroup;
  final bool isMoreGroup;
  final dynamic pageDetail;

  const PageState(
      {this.rolePage = true,
      this.pageFeed = const [],
      this.isMoreFeed = true,
      this.pageReview = const [],
      this.isMoreReview = true,
      this.pagePined = const [],
      this.pagePhoto = const [],
      this.isMorePhoto = true,
      this.pageAlbum = const [],
      this.isMoreAlbum = true,
      this.pageVideo = const [],
      this.isMoreVideo = true,
      this.pageGroup = const [],
      this.pageDetail = const {},
      this.isMoreGroup = true});

  PageState copyWith(
      {bool rolePage = true,
      List pageFeed = const [],
      bool isMoreFeed = true,
      List pageReview = const [],
      bool isMoreReview = true,
      List pagePined = const [],
      List pagePhoto = const [],
      bool isMorePhoto = true,
      List pageAlbum = const [],
      bool isMoreAlbum = true,
      List pageVideo = const [],
      bool isMoreVideo = true,
      List pageGroup = const [],
      dynamic pageDetail = const {},
      bool isMoreGroup = true}) {
    return PageState(
        rolePage: rolePage,
        pageFeed: pageFeed,
        isMoreFeed: isMoreFeed,
        pageReview: pageReview,
        isMoreReview: isMoreReview,
        pagePined: pagePined,
        pagePhoto: pagePhoto,
        isMorePhoto: isMorePhoto,
        pageAlbum: pageAlbum,
        isMoreAlbum: isMoreAlbum,
        pageVideo: pageVideo,
        isMoreVideo: isMoreVideo,
        pageGroup: pageGroup,
        pageDetail: pageDetail,
        isMoreGroup: isMoreGroup);
  }
}

final pageControllerProvider =
    StateNotifierProvider.autoDispose<PageController, PageState>((ref) {
  return PageController();
});

class PageController extends StateNotifier<PageState> {
  PageController() : super(const PageState());

  getListPageReview(params, id) async {
    var response = await PageApi().getListReviewPageApi(params, id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
          rolePage: state.rolePage,
          pageFeed: state.pageFeed,
          isMoreFeed: state.isMoreFeed,
          pageReview: checkObjectUniqueInList(
              params['page'] == '0'
                  ? response + state.pageReview
                  : state.pageReview + response,
              'id'),
          isMoreReview: response.isEmpty ? false : true,
          pagePined: state.pagePined,
          pagePhoto: state.pagePhoto,
          isMorePhoto: state.isMorePhoto,
          pageAlbum: state.pageAlbum,
          isMoreAlbum: state.isMoreAlbum,
          pageVideo: state.pageVideo,
          isMoreVideo: state.isMoreVideo,
          pageGroup: state.pageGroup,
          isMoreGroup: state.isMoreGroup,
          pageDetail: state.pageDetail,
        );
      }
    }
  }

  getPageDetail(id) async {
    var response = await PageApi().fetchPageDetail(id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            pageDetail: response,
            rolePage: state.rolePage,
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: state.pageReview,
            isMoreReview: response.isEmpty ? false : true,
            pagePined: state.pagePined,
            pagePhoto: state.pagePhoto,
            isMorePhoto: state.isMorePhoto,
            pageAlbum: state.pageAlbum,
            isMoreAlbum: state.isMoreAlbum,
            pageVideo: state.pageVideo,
            isMoreVideo: state.isMoreVideo,
            pageGroup: state.pageGroup,
            isMoreGroup: state.isMoreGroup);
      }
    }
  }

  updateLikePageDetail(id, type) async {
    switch (type) {
      case "like":
        state = state.copyWith(
            pageDetail: {
              ...state.pageDetail,
              'page_relationship': {
                ...state.pageDetail['page_relationship'],
                'like': true
              }
            },
            rolePage: state.rolePage,
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: state.pageReview,
            isMoreReview: state.isMoreReview,
            pagePined: state.pagePined,
            pagePhoto: state.pagePhoto,
            isMorePhoto: state.isMorePhoto,
            pageAlbum: state.pageAlbum,
            isMoreAlbum: state.isMoreAlbum,
            pageVideo: state.pageVideo,
            isMoreVideo: state.isMoreVideo,
            pageGroup: state.pageGroup,
            isMoreGroup: state.isMoreGroup);
        break;
      case "unlike":
        state = state.copyWith(
            pageDetail: {
              ...state.pageDetail,
              'page_relationship': {
                ...state.pageDetail['page_relationship'],
                'like': false
              }
            },
            rolePage: state.rolePage,
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: state.pageReview,
            isMoreReview: state.isMoreReview,
            pagePined: state.pagePined,
            pagePhoto: state.pagePhoto,
            isMorePhoto: state.isMorePhoto,
            pageAlbum: state.pageAlbum,
            isMoreAlbum: state.isMoreAlbum,
            pageVideo: state.pageVideo,
            isMoreVideo: state.isMoreVideo,
            pageGroup: state.pageGroup,
            isMoreGroup: state.isMoreGroup);
        break;
      default:
    }
    type == "like"
        ? await PageApi().likePageSuggestion(id)
        : await PageApi().unLikePageSuggestion(id);
  }

  getListPageGroup(params, id) async {
    var response = await PageApi().getListGroupPageApi(params, id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            rolePage: state.rolePage,
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: state.pageReview,
            isMoreReview: state.isMoreReview,
            pagePined: state.pagePined,
            pagePhoto: state.pagePhoto,
            isMorePhoto: state.isMorePhoto,
            pageAlbum: state.pageAlbum,
            isMoreAlbum: state.isMoreAlbum,
            pageVideo: state.pageVideo,
            isMoreVideo: state.isMoreVideo,
            pageDetail: state.pageDetail,
            pageGroup:
                checkObjectUniqueInList(state.pageGroup + response, 'id'),
            isMoreGroup: response.length < params['limit'] ? false : true);
      }
    }
  }

  getListPageFeed(params, id) async {
    var response = await PageApi().getListPostPageApi(params, id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            rolePage: state.rolePage,
            pageFeed: checkObjectUniqueInList(state.pageFeed + response, 'id'),
            isMoreFeed: response.length < params['limit'] ? false : true,
            pageReview: state.pageReview,
            isMoreReview: state.isMoreReview,
            pagePined: state.pagePined,
            pagePhoto: state.pagePhoto,
            isMorePhoto: state.isMorePhoto,
            pageAlbum: state.pageAlbum,
            pageDetail: state.pageDetail,
            isMoreAlbum: state.isMoreAlbum,
            pageVideo: state.pageVideo,
            isMoreVideo: state.isMoreVideo,
            pageGroup: state.pageGroup,
            isMoreGroup: state.isMoreGroup);
      }
    }
  }

  getListPagePined(id) async {
    var response = await PageApi().getListPostPagePinedApi(id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            rolePage: state.rolePage,
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: state.pageReview,
            pageDetail: state.pageDetail,
            isMoreReview: state.isMoreReview,
            pagePined: response,
            pagePhoto: state.pagePhoto,
            isMorePhoto: state.isMorePhoto,
            pageAlbum: state.pageAlbum,
            isMoreAlbum: state.isMoreAlbum,
            pageVideo: state.pageVideo,
            isMoreVideo: state.isMoreVideo,
            pageGroup: state.pageGroup,
            isMoreGroup: state.isMoreGroup);
      }
    }
  }

  getListPageMedia(params, id) async {
    var response = await PageApi().getListMediaPageApi(params, id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            rolePage: state.rolePage,
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: state.pageReview,
            pageDetail: state.pageDetail,
            isMoreReview: state.isMoreReview,
            pagePined: state.pagePined,
            pagePhoto: state.pagePhoto +
                (params['media_type'] == 'image' ? response : []),
            isMorePhoto: params['media_type'] == 'image'
                ? response.length < params['limit']
                    ? false
                    : true
                : state.isMorePhoto,
            pageAlbum: state.pageAlbum,
            isMoreAlbum: state.isMoreAlbum,
            pageVideo: state.pageVideo +
                (params['media_type'] == 'video' ? response : []),
            isMoreVideo: params['media_type'] == 'video'
                ? response.length < params['limit']
                    ? false
                    : true
                : state.isMoreVideo,
            pageGroup: state.pageGroup,
            isMoreGroup: state.isMoreGroup);
      }
    }
  }

  getListPageAlbum(params, id) async {
    var response = await PageApi().getListAlbumPageApi(params, id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            rolePage: state.rolePage,
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: state.pageReview,
            isMoreReview: state.isMoreReview,
            pagePined: state.pagePined,
            pageDetail: state.pageDetail,
            pagePhoto: state.pagePhoto,
            isMorePhoto: state.isMorePhoto,
            pageAlbum: state.pageAlbum + response,
            isMoreAlbum: response.length < params['limit'] ? false : true,
            pageVideo: state.pageVideo,
            isMoreVideo: state.isMoreVideo,
            pageGroup: state.pageGroup,
            isMoreGroup: state.isMoreGroup);
      }
    }
  }

  deleteReviewPost(id) async {
    if (mounted) {
      state = state.copyWith(
          rolePage: state.rolePage,
          pageFeed: state.pageFeed,
          pageDetail: state.pageDetail,
          isMoreFeed: state.isMoreFeed,
          pageReview:
              state.pageReview.where((element) => element['id'] != id).toList(),
          isMoreReview: state.isMoreReview,
          pagePined: state.pagePined,
          pagePhoto: state.pagePhoto,
          isMorePhoto: state.isMorePhoto,
          pageAlbum: state.pageAlbum,
          isMoreAlbum: state.isMoreAlbum,
          pageVideo: state.pageVideo,
          isMoreVideo: state.isMoreVideo,
          pageGroup: state.pageGroup,
          isMoreGroup: state.isMoreGroup);
    }
  }

  switchToRolePage(role) async {
    if (mounted) {
      state = state.copyWith(
          rolePage: role,
          pageFeed: state.pageFeed,
          isMoreFeed: state.isMoreFeed,
          pageReview: state.pageReview,
          pageDetail: state.pageDetail,
          isMoreReview: state.isMoreReview,
          pagePined: state.pagePined,
          pagePhoto: state.pagePhoto,
          isMorePhoto: state.isMorePhoto,
          pageAlbum: state.pageAlbum,
          isMoreAlbum: state.isMoreAlbum,
          pageVideo: state.pageVideo,
          isMoreVideo: state.isMoreVideo,
          pageGroup: state.pageGroup,
          isMoreGroup: state.isMoreGroup);
    }
  }
}
