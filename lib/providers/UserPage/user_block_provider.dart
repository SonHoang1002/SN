import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';

class UserBlockControllerState {
  final List<dynamic> data;

  const UserBlockControllerState({this.data = const []});

  UserBlockControllerState copyWith({
    List<dynamic> data = const [],
  }) {
    return UserBlockControllerState(data: data);
  }
}

class UserBlockController extends StateNotifier<UserBlockControllerState> {
  UserBlockController() : super(const UserBlockControllerState());

  Future<void> getUserBlockList() async {
    var response = await UserPageApi().getBlockUserList();
    if (response != null) {
      state = state.copyWith(
        data: response["data"],
      );
    }
  }

  Future<void> getUserMessageBlockList() async {
    var response = await UserPageApi().getBlockUserMessageList();
    if (response != null) {
      state = state.copyWith(
        data: response["data"],
      );
    }
  }

  Future<void> getUserPageBlockList() async {
    var response = await UserPageApi().getUserBlockPageList();
    if (response != null) {
      state = state.copyWith(
        data: response["data"],
      );
    }
  }
}

final userBlockControllerProvider =
    StateNotifierProvider<UserBlockController, UserBlockControllerState>((ref) {
  return UserBlockController();
});
