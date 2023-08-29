import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';

class PageRoleState {
  List<dynamic> accounts;
  List<dynamic> invites;
  PageRoleState({
    this.accounts = const [],
    this.invites = const [],
  });

  PageRoleState copyWith({
    List<dynamic> accounts = const [],
    List<dynamic> invites = const [],
  }) {
    return PageRoleState(
      accounts: accounts,
      invites: invites,
    );
  }
}

class PageRoleController extends StateNotifier<PageRoleState> {
  PageRoleController() : super(PageRoleState());

  Future<void> getInviteListPage(id) async {
    var response = await PageApi().getListInvitePage(id);
    if (response != null) {
      state = state.copyWith(
        invites: response,
        accounts: state.accounts,
      );
    }
  }

  Future<void> getAdminListPage(id) async {
    var response = await PageApi().getListAdminPage(id);
    if (response != null) {
      state = state.copyWith(accounts: response, invites: state.invites);
    }
  }

  void reset() {
    state = PageRoleState();
  }
}

final pageRoleControllerProvider =
    StateNotifierProvider<PageRoleController, PageRoleState>((ref) {
  return PageRoleController();
});
