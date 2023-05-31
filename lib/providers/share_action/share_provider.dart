import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/events_api.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';

@immutable
class ShareState {
  final List shareGroup;
  final List shareFriend;

  const ShareState({
    this.shareGroup = const [],
    this.shareFriend = const [],
  });

  ShareState copyWith({
    List shareGroup = const [],
    List shareFriend = const [],
  }) {
    return ShareState(
      shareGroup: shareGroup,
      shareFriend: shareFriend,
    );
  }
}

final shareControllerProvider =
    StateNotifierProvider<ShareController, ShareState>(
        (ref) => ShareController());

class ShareController extends StateNotifier<ShareState> {
  ShareController() : super(const ShareState());

  getShareGroup(params) async {
    List response = await EventApi().getGroupSuggestedApi(params);
    if (response.isNotEmpty && mounted) {
      state =
          state.copyWith(shareGroup: response, shareFriend: state.shareFriend);
    }
  }

  getShareFriend(params) async {
    var response = await FriendsApi().getListFriendsApi(params);
    if (response != null && mounted) {
      state = state.copyWith(
        shareGroup: state.shareGroup,
        shareFriend: response['data'],
      );
    }
  }
}
