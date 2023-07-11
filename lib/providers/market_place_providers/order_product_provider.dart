import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_place/apis/market_place_apis/order_product_apis.dart';

class SellerOrderState {
  List<Map<String, dynamic>> sellerOrder;
  SellerOrderState({this.sellerOrder = const []});
  SellerOrderState copyWith(List<Map<String, dynamic>> newOrder) {
    return SellerOrderState(sellerOrder: newOrder);
  }
}

final orderSellerProvider =
    StateNotifierProvider<SellerOrderController, SellerOrderState>(
        (ref) => SellerOrderController());

class SellerOrderController extends StateNotifier<SellerOrderState> {
  SellerOrderController() : super(SellerOrderState());

  getSellerOrder(dynamic pageId) async {
    final response = await OrderApis().getSellerOrderApi(pageId);
    if (response == null) {
      state = state.copyWith([]);
      return;
    }
    state = state.copyWith(response.cast<Map<String, dynamic>>().toList());
  }

  getBuyerOrder() async {
    final response = await OrderApis().getBuyerOrdersApi();
    if (response == null) {
      state = state.copyWith([]);
      return;
    }
    state = state.copyWith(response.cast<Map<String, dynamic>>().toList());
  }
}

// buyer
class BuyerOrderState {
  List<Map<String, dynamic>> buyerOrder;
  BuyerOrderState({this.buyerOrder = const []});
  BuyerOrderState copyWith(List<Map<String, dynamic>> newOrder) {
    return BuyerOrderState(buyerOrder: newOrder);
  }
}

final orderBuyerProvider =
    StateNotifierProvider<BuyerOrderController, BuyerOrderState>(
        (ref) => BuyerOrderController());

class BuyerOrderController extends StateNotifier<BuyerOrderState> {
  BuyerOrderController() : super(BuyerOrderState());

  getBuyerOrder({dynamic limit}) async {
    final response = await OrderApis().getBuyerOrdersApi();
    if (response == null) {
      state = state.copyWith([]);
      return;
    }
    state = state.copyWith(response.cast<Map<String, dynamic>>().toList());
  }

  createBuyerOrder(dynamic data) async {
    final response = await OrderApis().createBuyerOrderApi(data);
  }
}
