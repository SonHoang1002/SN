import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageNotificationsProvider = StateNotifierProvider<
    PageNotificationsController,
    List<PageNotificationsState>>((ref) => PageNotificationsController());

class PageNotificationsController
    extends StateNotifier<List<PageNotificationsState>> {
  PageNotificationsController() : super(/* PageMesssagesState() */ []);

  /* getPageMesssagesStateItem() async {
    final response = await PageListApi().getPageListApi();

    state = state.copyWith("data", "data");
  } */
  void updateState(List<PageNotificationsState> newList) {
    state = newList;
  }

  void addPost(PageNotificationsState post) {
    state = [...state, post];
  }

  void removePost(int id) {
    state = [...state.where((element) => element.index != id)];
  }

  void update(int id, String newQuestion, String newResponse) {
    final updatedList = <PageNotificationsState>[];
    for (var i = 0; i < state.length; i++) {
      if (state[i].index == id) {
        state[i].question = newQuestion;
        state[i].response = newResponse;
      }
      updatedList.add(state[i]);
    }
    state = updatedList;
  }
}

class PageNotificationsState {
  int? index;
  String? question;
  String? response;
  bool? isNew;

  PageNotificationsState(
      {this.index, this.question, this.response, this.isNew});

  PageNotificationsState copyWith(
      int index, String data1, String data2, bool isNew) {
    return PageNotificationsState(
        index: index, question: data1, response: data2, isNew: isNew);
  }
}
