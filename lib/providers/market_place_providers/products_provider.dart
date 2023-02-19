import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';

class SuggestProductsState {
  List<dynamic> listSuggest;
  SuggestProductsState({this.listSuggest = const []});
  SuggestProductsState copyWith(List<dynamic> list) {
    return SuggestProductsState(listSuggest: list);
  }
}

final suggestProductsProvider =
    StateNotifierProvider<SuggestProductsController, SuggestProductsState>(
        (ref) => SuggestProductsController());

class SuggestProductsController extends StateNotifier<SuggestProductsState> {
  SuggestProductsController() : super(SuggestProductsState());

  getSuggestProducts(
    // {int? count}
    ) async {
    List<dynamic> response =
        await SuggestProductsApi().getListSuggestProductsApi();

    // List<dynamic> data =
    //     count != null ? response.take(count).toList() : response;

    state = state.copyWith(response);
  }
}
