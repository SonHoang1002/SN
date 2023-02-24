import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/Create_product_api.dart';

final newProductDataProvider =
    StateNotifierProvider<NewProductDataController, NewProductDataState>(
        (ref) => NewProductDataController());

class NewProductDataController extends StateNotifier<NewProductDataState> {
  NewProductDataController() : super(NewProductDataState());
  updateNewProductData(Map<String, dynamic> newData) {
    state = state.copyWith(newData);
    print("state: ${state.data}");
  }

  postCreateProduct(Map<String, dynamic> data) async {
    final response = await CreateProductApi().postCreateProductApi(data);
    print(response);
  }
}

class NewProductDataState {
  Map<String, dynamic> data;
  NewProductDataState({this.data = const {}});
  NewProductDataState copyWith(Map<String, dynamic> data) {
    return NewProductDataState(data: data);
  }
}
