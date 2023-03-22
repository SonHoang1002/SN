import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_place/apis/market_place_apis/detail_product_api.dart';

class DetailProductState {
  Map<String, dynamic> detail;
  DetailProductState({this.detail = const {}});
  DetailProductState copyWith(Map<String, dynamic> list) {
    return DetailProductState(detail: list);
  }
}

final detailProductProvider =
    StateNotifierProvider<DetailProductController, DetailProductState>(
        (ref) => DetailProductController());

class DetailProductController extends StateNotifier<DetailProductState> {
  DetailProductController() : super(DetailProductState());

  getDetailProduct(id) async {
    final response = await DetailProductApi().getDetailProductApi(id);
    if (response == null) {
      state = state.copyWith({});
      return;
    }
    state = state.copyWith(response);
  }
}
