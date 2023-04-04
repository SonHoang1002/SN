import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class PageState {
  final List pageFeed;
  final bool isMoreFeed;
  final List pageReview;
  final bool isMoreReview;

  const PageState(
      {this.pageFeed = const [],
      this.isMoreFeed = true,
      this.pageReview = const [],
      this.isMoreReview = true});

  PageState copyWith(
      {List pageFeed = const [],
      bool isMoreFeed = true,
      List pageReview = const [],
      bool isMoreReview = true}) {
    return PageState(
        pageFeed: pageFeed,
        isMoreFeed: isMoreFeed,
        pageReview: pageReview,
        isMoreReview: isMoreReview);
  }
}

final pageControllerProvider =
    StateNotifierProvider.autoDispose<PageController, PageState>((ref) {
  ref.read(meControllerProvider);
  return PageController();
});

class PageController extends StateNotifier<PageState> {
  PageController() : super(const PageState());

  getListPageReview(params, id) async {
    var response = await PageApi().getListReviewPageApi(params, id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            pageFeed: state.pageFeed,
            isMoreFeed: state.isMoreFeed,
            pageReview: checkObjectUniqueInList(
                params['page'] == '0'
                    ? response + state.pageReview
                    : state.pageReview + response,
                'id'),
            isMoreReview: response.isEmpty ? false : true);
      }
    }
  }

  getListPageFeed(params, id) async {
    var response = await PageApi().getListPostPageApi(params, id);
    if (response != null) {
      if (mounted) {
        state = state.copyWith(
            pageFeed: checkObjectUniqueInList(state.pageFeed + response, 'id'),
            isMoreFeed: response.length < params['limit'] ? false : true,
            pageReview: state.pageReview,
            isMoreReview: state.isMoreReview);
      }
    }
  }

  deleteReviewPost(id) async {
    if (mounted) {
      state = state.copyWith(
          pageFeed: state.pageFeed,
          isMoreFeed: state.isMoreFeed,
          pageReview:
              state.pageReview.where((element) => element['id'] != id).toList(),
          isMoreReview: state.isMoreReview);
    }
  }
}
