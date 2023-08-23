// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';

@immutable
class UserTagState {
  final String allow_post_status;
  final String allow_view_status;
  final List monitored_keywords;
  final String allow_tagging;
  final String allow_view_tagging;
  final bool review_tag_on_profile;
  final bool review_tag_on_feed;

  const UserTagState({
    this.allow_post_status = "friend",
    this.allow_view_status = "friend",
    this.monitored_keywords = const [],
    this.allow_tagging = "public",
    this.allow_view_tagging = "friend",
    this.review_tag_on_profile = true,
    this.review_tag_on_feed = true,
  });

  UserTagState copyWith({
    String allow_post_status = "friend",
    String allow_view_status = "friend",
    List monitored_keywords = const [],
    String allow_tagging = "public",
    String allow_view_tagging = "friend",
    bool review_tag_on_profile = true,
    bool review_tag_on_feed = true,
  }) {
    return UserTagState(
      allow_post_status: allow_post_status,
      allow_view_status: allow_view_status,
      monitored_keywords: monitored_keywords,
      allow_tagging: allow_tagging,
      allow_view_tagging: allow_view_tagging,
      review_tag_on_profile: review_tag_on_profile,
      review_tag_on_feed: review_tag_on_feed,
    );
  }
}

final userTagControllerProvider =
    StateNotifierProvider<UserTagController, UserTagState>((ref) {
  return UserTagController();
});

class UserTagController extends StateNotifier<UserTagState> {
  UserTagController() : super(const UserTagState());

  getUserTagSetting() async {
    var response = await UserPageApi().getTagSetting();
    if (response.isNotEmpty) {
      state = state.copyWith(
        allow_post_status: response["allow_post_status"],
        allow_view_status: response["allow_view_status"],
        monitored_keywords: response["monitored_keywords"],
        allow_tagging: response["allow_tagging"],
        allow_view_tagging: response["allow_view_tagging"],
        review_tag_on_profile: response["review_tag_on_profile"],
        review_tag_on_feed: response["review_tag_on_feed"],
      );
    }
  }

  updateReviewProfile(bool value) async {
    var response = await UserPageApi().getTagSetting();
    if (response.isNotEmpty) {
      state = state.copyWith(
        allow_post_status: state.allow_post_status,
        allow_view_status: state.allow_view_status,
        monitored_keywords: state.monitored_keywords,
        allow_tagging: state.allow_tagging,
        allow_view_tagging: state.allow_view_tagging,
        review_tag_on_profile: value,
        review_tag_on_feed: state.review_tag_on_feed,
      );
    }
  }
}
