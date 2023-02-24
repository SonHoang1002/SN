import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/search_product_api.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';

// search list is choosen
class SearchedProductsState {
  List<dynamic> listSearched;
  SearchedProductsState({this.listSearched = const []});
  SearchedProductsState copyWith(List<dynamic> list) {
    return SearchedProductsState(listSearched: list);
  }
}

final searchedProductItemProvider =
    StateNotifierProvider<SearchedProductsController, SearchedProductsState>(
        (ref) => SearchedProductsController());

class SearchedProductsController extends StateNotifier<SearchedProductsState> {
  SearchedProductsController() : super(SearchedProductsState());

  addSearchedProduct(dynamic data) async {
    var searchedList = state.listSearched;
    searchedList.add(data);
    state = state.copyWith(searchedList);
  }

  getSearchedProductList(dynamic data) async {
    // state = state.copyWith();
  }

  deleteSearchedProduct(dynamic data) async {
    // state = state.copyWith(response);
  }
}

// get serach List
class SearchProductsState {
  List<dynamic> listSearch;
  SearchProductsState({this.listSearch = const []});
  SearchProductsState copyWith(List<dynamic> list) {
    return SearchProductsState(listSearch: list);
  }
}

final searchProductsProvider =
    StateNotifierProvider<SearchProductsController, SearchProductsState>(
        (ref) => SearchProductsController());

class SearchProductsController extends StateNotifier<SearchProductsState> {
  SearchProductsController() : super(SearchProductsState());

  getSearchProducts(dynamic searchValue) async {
    final data = {
      "q": searchValue,
      "limit": 10,
    };
    final response = SearchProductsApi().searchProduct(data);
    state = state.copyWith(response as List<dynamic>);
  }
}
