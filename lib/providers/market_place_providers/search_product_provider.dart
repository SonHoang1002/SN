import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/search_product_api.dart';

// history search
class HistorySearchedState {
  List<dynamic> listSearched;
  HistorySearchedState({this.listSearched = const []});
  HistorySearchedState copyWith(List<dynamic> list) {
    return HistorySearchedState(listSearched: list);
  }
}

final searchedHistoryProvider =
    StateNotifierProvider<HistorySearchedController, HistorySearchedState>(
        (ref) => HistorySearchedController());

class HistorySearchedController extends StateNotifier<HistorySearchedState> {
  HistorySearchedController() : super(HistorySearchedState());

  getHistorySearch({dynamic data}) async {
    final response = await SearchProductsApi().searchHistoryProduct(data);
    state = state.copyWith(response);
  }
}
