import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';
import 'package:social_network_app_mobile/helper/common.dart'; 

class ProductsState {
  final List<dynamic> list;
  final bool isMore;
  ProductsState({this.list = const [], this.isMore = true});
  ProductsState copyWith({List<dynamic> list = const [], bool isMore = true}) {
    return ProductsState(list: list, isMore: isMore);
  }
}

final productsProvider =
    StateNotifierProvider<ProductsController, ProductsState>(
        (ref) => ProductsController());

class ProductsController extends StateNotifier<ProductsState> {
  ProductsController() : super(ProductsState());

  getProductsSearch(dynamic params) async {
    final response = await ProductsApi().getProductSearchApi(params) ?? [];
    state = state.copyWith(
        list: checkObjectUniqueInList(state.list + response, "id"),
        isMore: response.isNotEmpty);
  }

  getProducts(dynamic params) async {
    final response = await ProductsApi().getProductsApi(params);
    state = state.copyWith(
        list: checkObjectUniqueInList(state.list + response, "id"),
        isMore: response.isNotEmpty);
  }

  getUserProductList(dynamic pageId) async {
    List<dynamic> response = await ProductsApi().getUserProductList(pageId);
    state = state.copyWith(list: response, isMore: response.isNotEmpty);
  }

  deleteProduct(dynamic id) {
    final response = ProductsApi().deleteProductApi(id);
  }

  updateProductData(List<dynamic> newData) {
    state = state.copyWith(list: newData);
  }

  dynamic createProduct(dynamic data) async {
     final response = await ProductsApi().postCreateProductApi(data);
    return response;
  }
}
