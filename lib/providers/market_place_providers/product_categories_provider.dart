import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/category_product_apis.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/product_categories_api.dart';
import 'package:social_network_app_mobile/data/market_place_datas/product_categories_data.dart';

class ProductParentCategoriesState {
  List<dynamic> parentList;
  ProductParentCategoriesState({this.parentList = const []});
  ProductParentCategoriesState copyWith({List<dynamic> list = const []}) {
    return ProductParentCategoriesState(parentList: list);
  }
}

final parentCategoryController = StateNotifierProvider<
    ProductParentCategoriesController,
    ProductParentCategoriesState>((ref) => ProductParentCategoriesController());

class ProductParentCategoriesController
    extends StateNotifier<ProductParentCategoriesState> {
  ProductParentCategoriesController() : super(ProductParentCategoriesState());

  getParentProductCategories() async {
    final response = await CategoryProductApis().getParentCategoryProductApi();
    state = state.copyWith(list: response);
  }
}

class ProductChildCategoriesState {
  List<dynamic> childList;
  ProductChildCategoriesState({this.childList = const []});
  ProductChildCategoriesState copyWith({List<dynamic> list = const []}) {
    return ProductChildCategoriesState(childList: list);
  }
}

final childCategoryController = StateNotifierProvider<
    ProductChildCategoriesController,
    ProductChildCategoriesState>((ref) => ProductChildCategoriesController());

class ProductChildCategoriesController
    extends StateNotifier<ProductChildCategoriesState> {
  ProductChildCategoriesController() : super(ProductChildCategoriesState());

  getChildProductCategories(dynamic id) async {
    final response = await CategoryProductApis().getChildCategoryProductApi(id);
    state = state.copyWith(list: response);
  }
}
