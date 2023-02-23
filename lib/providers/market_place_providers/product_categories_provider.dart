import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/product_categories_api.dart';
import 'package:social_network_app_mobile/data/market_place_datas/product_categories_data.dart';

class ProductCategoriesState {
  List<dynamic> list;
  ProductCategoriesState({this.list = const []});
  ProductCategoriesState copyWith(
      {List<dynamic> list = const []}) {
    return ProductCategoriesState(list: list);
  }
}


final productCategoriesProvider =
    StateNotifierProvider<ProductCategoriesController, ProductCategoriesState>(
        (ref) => ProductCategoriesController());

class ProductCategoriesController
    extends StateNotifier<ProductCategoriesState> {
  ProductCategoriesController() : super(ProductCategoriesState());

  getListProductCategories() async {
    // final response = await ProductCategoriesApi().getListProductCategoriesApi();

    // List<dynamic> list = [];
    // productCategories.forEach((e) {
    //   list.add(dynamic.fromJson(e));
    // });
    state = state.copyWith(list: productCategories);
  }
}
