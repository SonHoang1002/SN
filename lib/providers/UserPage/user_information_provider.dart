import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

@immutable
class UserInformationState {
  final dynamic userInfor;
  final dynamic userMoreInfor;
  final List friends;
  final List featureContent;

  const UserInformationState(
      {this.userInfor = const {},
      this.userMoreInfor = const {},
      this.friends = const [],
      this.featureContent = const []});

  UserInformationState copyWith(
      {dynamic userInfor = const {},
      dynamic userMoreInfor = const {},
      List friends = const [],
      List featureContent = const []}) {
    return UserInformationState(
        userInfor: userInfor,
        userMoreInfor: userMoreInfor,
        friends: friends,
        featureContent: featureContent);
  }
}

final userInformationProvider = StateNotifierProvider.autoDispose<
    UserInformationController, UserInformationState>((ref) {
  ref.read(meControllerProvider);

  return UserInformationController();
});

class UserInformationController extends StateNotifier<UserInformationState> {
  UserInformationController() : super(const UserInformationState());

  getUserInformation(idUser) async {
    var response = await UserPageApi().getAccountInfor(idUser);

    if (response != null && mounted) {
      state = state.copyWith(
          userInfor: response,
          userMoreInfor: state.userMoreInfor,
          friends: state.friends,
          featureContent: state.featureContent);
    }
  }

  getUserMoreInformation(idUser) async {
    var response = await UserPageApi().getAccountAboutInformation(idUser);

    if (response != null && mounted) {
      state = state.copyWith(
          userInfor: state.userInfor,
          userMoreInfor: response,
          friends: state.friends,
          featureContent: state.featureContent);
    }
  }

  getUserFriend(idUser, params) async {
    var response = await UserPageApi().getUserFriend(idUser, params);

    if (response != null && mounted) {
      state = state.copyWith(
          userInfor: state.userInfor,
          userMoreInfor: state.userMoreInfor,
          friends: response,
          featureContent: state.featureContent);
    }
  }

  getUserFeatureContent(idUser) async {
    var response = await UserPageApi().getUserFeatureContent(idUser);

    if (response != null && mounted) {
      state = state.copyWith(
          userInfor: state.userInfor,
          userMoreInfor: state.userMoreInfor,
          friends: state.friends,
          featureContent: response);
    }
  }
}
