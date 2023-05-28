import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/events_api.dart';

@immutable
class ShareState {
  final List shareGroup;

  const ShareState({
    this.shareGroup = const [],
  });

  ShareState copyWith({
    List shareGroup = const [],
  }) {
    return ShareState(
      shareGroup: shareGroup,
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
      state = state.copyWith(
        shareGroup: response,
      );
    }
  }
}
