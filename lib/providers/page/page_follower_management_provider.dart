import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';

class PageFollowersState {
  List<dynamic> like;
  List<dynamic> follower;
  List<dynamic> block;
  PageFollowersState({
    this.like = const [],
    this.follower = const [],
    this.block = const [],
  });

  PageFollowersState copyWith({
    List<dynamic> like = const [],
    List<dynamic> follower = const [],
    List<dynamic> block = const [],
  }) {
    return PageFollowersState(
      like: like,
      follower: follower,
      block: block,
    );
  }
}

class PageFollowersController extends StateNotifier<PageFollowersState> {
  PageFollowersController() : super(PageFollowersState());

  Future<void> getDataFollowPage(id) async {
    var response = await PageApi().getPageLikeAccount(id);
    var response2 = await PageApi().getPageFollowerAccount(id);
    var response3 = await PageApi().getPageBlockAccount(id);
    if (response != null) {
      state =
          state.copyWith(like: response, follower: response2, block: response3);
    }
  }

  void reset() {
    state = PageFollowersState();
  }
}

final pageFollowControllerProvider =
    StateNotifierProvider<PageFollowersController, PageFollowersState>((ref) {
  return PageFollowersController();
});
