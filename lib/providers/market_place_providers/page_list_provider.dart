import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/page_list_api.dart';

final pageListProvider =
    StateNotifierProvider<PageListController, PageListState>(
        (ref) => PageListController());

class PageListController extends StateNotifier<PageListState> {
  PageListController() : super(PageListState());
}

class PageListState {
  List<dynamic> listPage;
  PageListState({this.listPage = const []});
  PageListState copyWith(List<dynamic> list) {
    return PageListState(listPage: list);
  }
}
