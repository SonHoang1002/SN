import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';

class UserWatchHistoryState {
  final List<dynamic> history;
  const UserWatchHistoryState({this.history = const []});

  UserWatchHistoryState copyWith({
    List<dynamic> history = const [],
  }) {
    return UserWatchHistoryState(
      history: history,
    );
  }
}

class UserWatchController extends StateNotifier<UserWatchHistoryState> {
  UserWatchController() : super(const UserWatchHistoryState());

  Future<void> getInviteListPage(page) async {
    var response = await UserPageApi().getWatchHistories({"page": page});
    if (response != null) {
      state = state.copyWith(
        history: [...state.history, ...response],
      );
    }
  }

  void reset() {
    state = const UserWatchHistoryState();
  }
}

final userWatchControllerProvider =
    StateNotifierProvider<UserWatchController, UserWatchHistoryState>((ref) {
  return UserWatchController();
});
