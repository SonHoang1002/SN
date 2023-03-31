import 'package:flutter_riverpod/flutter_riverpod.dart';
final updateProductProvider =
    StateNotifierProvider<UpdateProductDataController, UpdateProductDataState>(
        (ref) => UpdateProductDataController());

class UpdateProductDataController extends StateNotifier<UpdateProductDataState> {
  UpdateProductDataController() : super(UpdateProductDataState());
  updateProductData(Map<String, dynamic> newData) {
    state = state.copyWith(newData); 
  }
}

class UpdateProductDataState {
  Map<String, dynamic> data;
  UpdateProductDataState({this.data = const {}});
  UpdateProductDataState copyWith(Map<String, dynamic> data) {
    return UpdateProductDataState(data: data);
  }
}
