import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';

class PageRoleState {
  List<dynamic> accounts;
  PageRoleState({
    this.accounts = const [],
  });

  PageRoleState copyWith({
    required List<dynamic> accounts,
  }) {
    return PageRoleState(
      accounts: accounts,
    );
  }
}

class PageRoleController extends StateNotifier<PageRoleState> {
  PageRoleController() : super(PageRoleState());

  Future<void> getInviteListPage(id) async {
    var response = await PageApi().getListInvitePage(id);
    if (response != null) {
      state = state.copyWith(
        accounts: response,
      );
    }
  }
}

final pageRoleControllerProvider =
    StateNotifierProvider<PageRoleController, PageRoleState>((ref) {
  return PageRoleController();
});
