// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';

@immutable
class UserPublicPostState {
  final String who_can_follow_me;
  final String public_post_comment;
  final String public_post_notification;
  final String public_profile_info;
  final bool off_preview;
  final bool comment_ranking;

  const UserPublicPostState({
    this.who_can_follow_me = "public",
    this.public_post_comment = "friend_of_friend",
    this.public_post_notification = "friend_of_friend",
    this.public_profile_info = "friend_of_friend",
    this.off_preview = true,
    this.comment_ranking = true,
  });

  UserPublicPostState copyWith({
    String who_can_follow_me = "public",
    String public_post_comment = "friend_of_friend",
    String public_post_notification = "friend_of_friend",
    String public_profile_info = "friend_of_friend",
    bool off_preview = true,
    bool comment_ranking = true,
  }) {
    return UserPublicPostState(
      who_can_follow_me: who_can_follow_me,
      public_post_comment: public_post_comment,
      public_post_notification: public_post_notification,
      public_profile_info: public_profile_info,
      off_preview: off_preview,
      comment_ranking: comment_ranking,
    );
  }
}

final userPublicPostControllerProvider =
    StateNotifierProvider<UserPublicPostController, UserPublicPostState>((ref) {
  return UserPublicPostController();
});

class UserPublicPostController extends StateNotifier<UserPublicPostState> {
  UserPublicPostController() : super(const UserPublicPostState());

  getUserPublicPostSetting() async {
    var response = await UserPageApi().getTagSetting();
    if (response.isNotEmpty) {
      state = state.copyWith(
        who_can_follow_me: response["who_can_follow_me"],
        public_post_comment: response["public_post_comment"],
        public_post_notification: response["public_post_notification"],
        public_profile_info: response["public_profile_info"],
        off_preview: response["off_preview"],
        comment_ranking: response["comment_ranking"],
      );
    }
  }

  updateWhoCanFollow(String value) async {
    state = state.copyWith(
      who_can_follow_me: value,
      public_post_comment: state.public_post_comment,
      public_post_notification: state.public_post_notification,
      public_profile_info: state.public_profile_info,
      off_preview: state.off_preview,
      comment_ranking: state.comment_ranking,
    );
  }

  updatePostComment(String value) async {
    state = state.copyWith(
      who_can_follow_me: state.who_can_follow_me,
      public_post_comment: value,
      public_post_notification: state.public_post_notification,
      public_profile_info: state.public_profile_info,
      off_preview: state.off_preview,
      comment_ranking: state.comment_ranking,
    );
  }

  void updatePostNotification(String newStatus) {
    state = state.copyWith(
      who_can_follow_me: state.who_can_follow_me,
      public_post_comment: state.public_post_comment,
      public_post_notification: newStatus,
      public_profile_info: state.public_profile_info,
      off_preview: state.off_preview,
      comment_ranking: state.comment_ranking,
    );
  }

  void updateProfileInfo(String newStatus) {
    state = state.copyWith(
      who_can_follow_me: state.who_can_follow_me,
      public_post_comment: state.public_post_comment,
      public_post_notification: state.public_post_notification,
      public_profile_info: newStatus,
      off_preview: state.off_preview,
      comment_ranking: state.comment_ranking,
    );
  }

  void updateOffPreview(bool newStatus) {
    state = state.copyWith(
      who_can_follow_me: state.who_can_follow_me,
      public_post_comment: state.public_post_comment,
      public_post_notification: state.public_post_notification,
      public_profile_info: state.public_profile_info,
      off_preview: newStatus,
      comment_ranking: state.comment_ranking,
    );
  }

  void updateCommentRanking(bool newStatus) {
    state = state.copyWith(
      who_can_follow_me: state.who_can_follow_me,
      public_post_comment: state.public_post_comment,
      public_post_notification: state.public_post_notification,
      public_profile_info: state.public_profile_info,
      off_preview: state.off_preview,
      comment_ranking: newStatus,
    );
  }
}
