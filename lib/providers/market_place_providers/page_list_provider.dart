import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_place/apis/market_place_apis/page_list_api.dart';

final pageListProvider =
    StateNotifierProvider<PageListController, PageListState>(
        (ref) => PageListController());

class PageListController extends StateNotifier<PageListState> {
  PageListController() : super(PageListState());
  getPageList() async {
    List response = await PageListApi().getPageListApi() ?? [];
    state = state.copyWith(response);
  }
}

class PageListState {
  List<dynamic> listPage;
  PageListState({this.listPage = const []});
  PageListState copyWith(List<dynamic> list) {
    return PageListState(listPage: list);
  }
}
