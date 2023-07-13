import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';

@immutable
class FriendState {
  final List friendExcludes;
  final List friendRequest;
  final List friendInvited;
  final List friendSuggestions;
  final List friendIncludes;
  final List friends;

  const FriendState({
    this.friendExcludes = const [],
    this.friendIncludes = const [],
    this.friendRequest = const [],
    this.friendInvited = const [],
    this.friendSuggestions = const [],
    this.friends = const [],
  });

  FriendState copyWith({
    List friendExcludes = const [],
    List friendIncludes = const [],
    List friendRequest = const [],
    List friendInvited = const [],
    List friendSuggestions = const [],
    List friends = const [],
  }) {
    return FriendState(
        friendExcludes: friendExcludes,
        friendIncludes: friendIncludes,
        friendRequest: friendRequest,
        friendInvited: friendInvited,
        friendSuggestions: friendSuggestions,
        friends: friends);
  }
}

final friendControllerProvider =
    StateNotifierProvider<FriendController, FriendState>(
        (ref) => FriendController());

class FriendController extends StateNotifier<FriendState> {
  FriendController() : super(const FriendState());

  reset() {
    state = const FriendState();
  }

  getListFriendExcludes(params) async {
    var response = await FriendsApi().getListFriendsApi(params);
    if (response['data'].isNotEmpty) {
      state = state.copyWith(
          friendExcludes: [...response['data']],
          friendRequest: state.friendRequest,
          friendInvited: state.friendInvited,
          friendSuggestions: state.friendSuggestions,
          friends: state.friends);
    }
  }

  getListFriendRequest(params) async {
    var response = await FriendsApi().getListFriendRequestApi(params);
    if (response['data'].isNotEmpty) {
      state = state.copyWith(
        friendExcludes: state.friendExcludes,
        friendRequest: [...response['data']],
        friendInvited: state.friendInvited,
        friendSuggestions: state.friendSuggestions,
      );
    } else {
      state = state.copyWith(
          friendExcludes: state.friendExcludes,
          friendRequest: [...response['data']],
          friendInvited: state.friendInvited,
          friendSuggestions: state.friendSuggestions,
          friends: state.friends);
    }
  }

  getListFriendSuggest(params) async {
    List response = await FriendsApi().getListFriendSuggestApi(params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          friendExcludes: state.friendExcludes,
          friendRequest: state.friendRequest,
          friendInvited: state.friendInvited,
          friendSuggestions: response,
          friends: state.friends);
    }
  }

  statusFriendRequest(
    type,
    id,
  ) async {
    type == 'add'
        ? await FriendsApi().approveFriendRequestApi(id)
        : await FriendsApi().rejectFriendRequestApi(id);

    if (mounted) {
      state = state.copyWith(
        friendExcludes: state.friendExcludes,
        friendRequest: state.friendRequest,
        friendInvited: state.friendInvited,
        friendSuggestions: state.friendSuggestions,
        friends: state.friends,
      );
    }
  }

  removeFriendSuggest(params) async {
    state = state.copyWith(
      friendExcludes: state.friendExcludes,
      friendRequest: state.friendRequest,
      friendInvited: state.friendInvited,
      friendSuggestions: state.friendSuggestions
          .where((element) => element['id'] != params)
          .toList(),
      friends: state.friends,
    );
  }

  getListFriendRequested(params) async {
    var response = await FriendsApi().getListFriendInvitedApi(params);
    if (response['data'].isNotEmpty) {
      state = state.copyWith(
        friendExcludes: state.friendExcludes,
        friendRequest: state.friendRequest,
        friendInvited: [...response['data']],
        friendSuggestions: state.friendSuggestions,
        friends: state.friends,
      );
    }
  }

  getListFriends(idUser, params) async {
    List response = await FriendsApi().getListFriendApi(idUser, params);
    if (response.isNotEmpty) {
      state = state.copyWith(
          friendExcludes: state.friendExcludes,
          friendRequest: state.friendRequest,
          friendInvited: state.friendInvited,
          friendSuggestions: state.friendSuggestions,
          friends: response);
    }
  }
}
