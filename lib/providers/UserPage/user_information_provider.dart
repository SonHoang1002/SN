import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class UserInformationState {
  final dynamic userInfor;
  final dynamic userMoreInfor;
  final List friends;
  final List friendsNear;
  final List featureContent;
  final List userLifeEvent;

  const UserInformationState({
    this.userInfor = const {},
    this.userMoreInfor = const {},
    this.friends = const [],
    this.friendsNear = const [],
    this.featureContent = const [],
    this.userLifeEvent = const [],
  });

  UserInformationState copyWith({
    dynamic userInfor = const {},
    dynamic userMoreInfor = const {},
    List friends = const [],
    List friendsNear = const [],
    List featureContent = const [],
    List userLifeEvent = const [],
  }) {
    return UserInformationState(
      userInfor: userInfor,
      userMoreInfor: userMoreInfor,
      friends: friends,
      friendsNear: friendsNear,
      featureContent: featureContent,
      userLifeEvent: userLifeEvent,
    );
  }
}

final userInformationProvider =
    StateNotifierProvider<UserInformationController, UserInformationState>(
        (ref) {
  ref.read(meControllerProvider);
  return UserInformationController();
});

class UserInformationController extends StateNotifier<UserInformationState> {
  UserInformationController() : super(const UserInformationState());

  getUserInformation(idUser) async {
    var response = await UserPageApi().getAccountInfor(idUser) ?? [];
    if (response != null && mounted) {
      state = state.copyWith(
        userInfor: response,
        userMoreInfor: state.userMoreInfor,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: state.userLifeEvent,
      );
    } else {
      state = state.copyWith(
        userInfor: response,
        userMoreInfor: state.userMoreInfor,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: state.userLifeEvent,
      );
    }
  }

  getUserLifeEvent(idUser) async {
    List response = await UserPageApi().getListLifeEvent(idUser) ?? [];
    if (response.isNotEmpty && mounted) {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: state.userMoreInfor,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: response,
      );
    } else {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: state.userMoreInfor,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: response,
      );
    }
  }

  getUserMoreInformation(idUser) async {
    var response = await UserPageApi().getAccountAboutInformation(idUser);
    if (response != null && mounted) {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: response,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: state.userLifeEvent,
      );
    } else {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: response,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: state.userLifeEvent,
      );
    }
  }

  getUserFriend(idUser, params) async {
    var response = await UserPageApi().getUserFriend(idUser, params);
    if (response != null && mounted) {
      state = state.copyWith(
          userInfor: state.userInfor,
          userMoreInfor: state.userMoreInfor,
          friends: params['order_by_column'] != null
              ? state.friends
              : state.friends + response,
          friendsNear: params['order_by_column'] != null
              ? state.friendsNear + response
              : state.friendsNear,
          featureContent: state.featureContent);
    }
  }

  getUserFeatureContent(idUser) async {
    var response = await UserPageApi().getUserFeatureContent(idUser) ?? [];
    if (response != null && mounted) {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: state.userMoreInfor,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: response,
        userLifeEvent: state.userLifeEvent,
      );
    } else {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: state.userMoreInfor,
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: response,
        userLifeEvent: state.userLifeEvent,
      );
    }
  }

  removeUserInfo() async {
    if (mounted) {
      state = state.copyWith(
        userInfor: {},
        userMoreInfor: {},
        friends: [],
        friendsNear: [],
      );
    }
  }

  updateDescription(userId, String newDescription) async {
    UserPageApi()
        .updateOtherInformation(userId, {"description": newDescription});
    if (mounted) {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: {
          ...state.userMoreInfor,
          "general_information": {
            ...state.userMoreInfor['general_information'],
            "description": newDescription,
          },
        },
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: state.userLifeEvent,
      );
    }
  }

  updateHobbies(newHobbies) async {
    if (mounted) {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: {
          ...state.userMoreInfor,
          "hobbies": newHobbies,
        },
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: state.userLifeEvent,
      );
    }
    List hobbyIds = newHobbies.map((e) => e['id']).toList();
    UserPageCredentical().updateCredentialUser({"hobby_ids": hobbyIds});
  }

  saveHobbiesTemporarily(newHobbies) {
    if (mounted) {
      state = state.copyWith(
        userInfor: state.userInfor,
        userMoreInfor: {
          ...state.userMoreInfor,
          "tempHobbies": newHobbies,
        },
        friends: state.friends,
        friendsNear: state.friendsNear,
        featureContent: state.featureContent,
        userLifeEvent: state.userLifeEvent,
      );
    }
  }
}
