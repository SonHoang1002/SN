import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageSettingsState {
  String visitor_posts;
  String age_restrictions;
  List<dynamic> cencored;

  PageSettingsState({
    this.visitor_posts = "",
    this.age_restrictions = "",
    this.cencored = const [],
  });

  PageSettingsState copyWith({
    String visitor_posts = "",
    List<dynamic> cencored = const [],
    String age_restrictions = "",
  }) {
    return PageSettingsState(
      visitor_posts: visitor_posts,
      cencored: cencored,
      age_restrictions: age_restrictions,
    );
  }
}

final pageSettingsControllerProvider =
    StateNotifierProvider<PageSettingsController, PageSettingsState>((ref) {
  return PageSettingsController();
});

class PageSettingsController extends StateNotifier<PageSettingsState> {
  PageSettingsController() : super(PageSettingsState());
  void updateState(PageSettingsState newList) {
    state = newList;
  }

  void updateCencored(List<dynamic> newCencoredList) {
    state = state.copyWith(cencored: newCencoredList);
  }
}
