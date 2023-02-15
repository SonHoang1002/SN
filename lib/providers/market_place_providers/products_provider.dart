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

  getSuggestProducts() async {
    final response = await SuggestProductsApi().getListSuggestProductsApi();
    final data = List.from(response);
    print("data[0]['product_variants']: ${data[0]["product_variants"]}");
    state = state.copyWith(response);
  }
}
