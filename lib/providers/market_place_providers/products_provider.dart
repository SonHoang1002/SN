import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';

class ProductsState {
  List<dynamic> list;
  ProductsState({this.list = const []});
  ProductsState copyWith(List<dynamic> list) {
    return ProductsState(list: list);
  }
}

final productsProvider =
    StateNotifierProvider<ProductsController, ProductsState>(
        (ref) => ProductsController());

class ProductsController extends StateNotifier<ProductsState> {
  ProductsController() : super(ProductsState());

  getProducts() async {
    List<dynamic> response = await ProductsApi().getProductsApi();
    state = state.copyWith(response);
  }

  getUserProductList(dynamic pageId) async {
    List<dynamic> response = await ProductsApi().getUserProductList(pageId);
    state = state.copyWith(response);
  }

  deleteProduct(dynamic id) {
    final response = ProductsApi().deleteProductApi(id);
  }

  updateProductData(List<dynamic> newData) {
    state = state.copyWith(newData);
  }

  dynamic createProduct(dynamic data) async {
    final response = await ProductsApi().postCreateProductApi(data);
    return response;
  }
}
