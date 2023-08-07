import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageMesssagesProvider =
    StateNotifierProvider<PageMesssagesController, List<PageMesssagesState>>(
        (ref) => PageMesssagesController());

class PageMesssagesController extends StateNotifier<List<PageMesssagesState>> {
  PageMesssagesController() : super(/* PageMesssagesState() */ []);

  /* getPageMesssagesStateItem() async {
    final response = await PageListApi().getPageListApi();

    state = state.copyWith("data", "data");
  } */
  void updateState(List<PageMesssagesState> newList) {
    state = newList;
  }

  void addPost(PageMesssagesState post) {
    state = [...state, post];
  }

  void removePost(int id) {
    state = [...state.where((element) => element.index != id)];
  }

  void update(int id, String newQuestion, String newResponse) {
    final updatedList = <PageMesssagesState>[];
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

class PageMesssagesState {
  int? index;
  String? question;
  String? response;
  bool? isNew;

  PageMesssagesState({this.index, this.question, this.response, this.isNew});

  PageMesssagesState copyWith(
      int index, String data1, String data2, bool isNew) {
    return PageMesssagesState(
        index: index, question: data1, response: data2, isNew: isNew);
  }
}
