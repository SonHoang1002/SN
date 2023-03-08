import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/Create_product_api.dart';

class CreateProductState {
  Map<String, dynamic> data;
  CreateProductState({this.data = const {}});
  CreateProductState copyWith(Map<String, dynamic> newData) {
    return CreateProductState(data: newData);
  }
}

final createProductProvider =
    StateNotifierProvider<CreateProductController, CreateProductState>(
        (ref) => CreateProductController());

class CreateProductController extends StateNotifier<CreateProductState> {
  CreateProductController() : super(CreateProductState());

  postCreateProduct(Map<String, dynamic> data) async {
    final response = await CreateProductApi().getListCreateProductApi(data);
    print(response);
  }
}

final updateProductDataProvider =
    StateNotifierProvider<NewProductDataController, NewProductDataState>(
        (ref) => NewProductDataController());

class NewProductDataController extends StateNotifier<NewProductDataState> {
  NewProductDataController() : super(NewProductDataState());
  updateNewProductData(Map<String, dynamic> newData) {
    
    state = state.copyWith(newData);
    print("state: ${state.data}");
  }
}

class NewProductDataState {
  Map<String, dynamic> data;
  NewProductDataState({this.data = const {}});
  NewProductDataState copyWith(Map<String, dynamic> data) {
    return NewProductDataState(data: data);
  }
}
