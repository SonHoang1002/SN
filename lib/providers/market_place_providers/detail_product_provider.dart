import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/detail_product_api.dart';

class DetailProductState {
  dynamic detail;
  DetailProductState({this.detail = const {}});
  DetailProductState copyWith(dynamic list) {
    return DetailProductState(detail: list);
  }
}

final detailProductProvider =
    StateNotifierProvider<DetailProductController, DetailProductState>(
        (ref) => DetailProductController());

class DetailProductController extends StateNotifier<DetailProductState> {
  DetailProductController() : super(DetailProductState());

  getDetailProduct(String id) async {
    final response = await DetailProductApi().getDetailProductApi(id);
    final data = List.from(response);
    print("data1: ${data}");
    // state = state.copyWith(response);
  }
}
