import 'package:flutter_riverpod/flutter_riverpod.dart';

final newProductDataProvider =
    StateNotifierProvider<NewProductDataController, NewProductDataState>(
        (ref) => NewProductDataController());

class NewProductDataController extends StateNotifier<NewProductDataState> {
  NewProductDataController() : super(NewProductDataState());
  updateNewProductData(Map<String, dynamic> newData) {
    state = state.copyWith(newData);
  }


}

class NewProductDataState {
  Map<String, dynamic> data;
  NewProductDataState({this.data = const {}});
  NewProductDataState copyWith(Map<String, dynamic> data) {
    return NewProductDataState(data: data);
  }
}
