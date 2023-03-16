import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/events_api.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';

@immutable
class FriendState {
  final List friendExcludes;
  final List friendIncludes;

  const FriendState({
    this.friendExcludes = const [],
    this.friendIncludes = const [],
  });

  FriendState copyWith({
    List friendExcludes = const [],
    List friendIncludes = const [],
  }) {
    return FriendState(
      friendExcludes: friendExcludes,
      friendIncludes: friendIncludes,
    );
  }
}

final friendControllerProvider =
StateNotifierProvider<FriendController, FriendState>(
        (ref) => FriendController());

class FriendController extends StateNotifier<FriendState> {
  FriendController() : super(const FriendState());

  getListFriendExcludes(params) async {
    var response = await FriendsApi().getListFriendsApi(params);
    if (response['data'].isNotEmpty) {
      state = state.copyWith(
          friendExcludes: [...response['data']],
        );
    }
  }
}
