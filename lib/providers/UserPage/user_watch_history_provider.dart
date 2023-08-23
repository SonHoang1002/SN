import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';

class UserHistoryControllerState {
  final List<dynamic> history;
  final Map<String, dynamic> likePages;
  const UserHistoryControllerState(
      {this.history = const [], this.likePages = const {}});

  UserHistoryControllerState copyWith({
    List<dynamic> history = const [],
    Map<String, dynamic> likePages = const {},
  }) {
    return UserHistoryControllerState(history: history, likePages: likePages);
  }
}

class UserHistoryController extends StateNotifier<UserHistoryControllerState> {
  UserHistoryController() : super(const UserHistoryControllerState());

  Future<void> getInviteListPage(page) async {
    var response = await UserPageApi()
        .getWatchHistory({"page": page, "post_type": "moment"});
    if (response != null) {
      state = state.copyWith(
        history: response,
      );
    }
  }

  Future<void> addInviteListPage(page) async {
    var response = await UserPageApi()
        .getWatchHistory({"page": page, "post_type": "moment"});
    if (response != null) {
      state = state.copyWith(
        history: [...state.history, ...response],
      );
    }
  }

  void resetList() {
    state = const UserHistoryControllerState();
  }

  void removeItem(int id) {
    state = state.copyWith(
      history: state.history.where((item) => item['id'] != id).toList(),
    );
  }

  Future<void> getSearchHistoryList(params) async {
    var response = await UserPageApi().getSearchHistory(params);
    if (response != null) {
      state = state.copyWith(
        history: response,
      );
    }
  }

  Future<void> addSearchHistoryList(params) async {
    var response = await UserPageApi().getSearchHistory(params);
    if (response != null) {
      state = state.copyWith(
        history: [...state.history, ...response],
      );
    }
  }

  Future<void> getPageLikeHistoryList(id, params) async {
    var response = await UserPageApi().getLikePage(id, params);
    if (response != null) {
      state = state.copyWith(
        likePages: response,
      );
    }
  }

  Future<void> addPageLikeHistoryList(id, params) async {
    var response = await UserPageApi().getLikePage(id, params);
    if (response != null) {
      state = state.copyWith(
        likePages: {
          'data': [...state.likePages['data'], ...response['data']],
          'meta': state.likePages['meta'],
        },
      );
    }
  }

  void removePageItem(String id) {
    state.copyWith(
      likePages: {
        'data': state.likePages['data']
          ..removeWhere((map) => map['page']['id'] == id),
        'meta': state.likePages['meta'],
      },
    );
  }
}

final userHistoryControllerProvider =
    StateNotifierProvider<UserHistoryController, UserHistoryControllerState>(
        (ref) {
  return UserHistoryController();
});
