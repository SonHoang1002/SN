import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/Create_product_api.dart';

final updateProductProvider =
    StateNotifierProvider<UpdateProductDataController, UpdateProductDataState>(
        (ref) => UpdateProductDataController());

class UpdateProductDataController extends StateNotifier<UpdateProductDataState> {
  UpdateProductDataController() : super(UpdateProductDataState());
  updateProductData(Map<String, dynamic> newData) {
    state = state.copyWith(newData);
    print("updateProduct provider: ${state.data}");
  }
}

class UpdateProductDataState {
  Map<String, dynamic> data;
  UpdateProductDataState({this.data = const {}});
  UpdateProductDataState copyWith(Map<String, dynamic> data) {
    return UpdateProductDataState(data: data);
  }
}
