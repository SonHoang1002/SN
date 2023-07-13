import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/order_product_apis.dart';

class OrderState {
  List<dynamic> order;
  OrderState({this.order = const []});
  OrderState copyWith(List<dynamic> newOrder) {
    return OrderState(order: newOrder);
  }
}

final orderProvider = StateNotifierProvider<OrderController, OrderState>(
    (ref) => OrderController());

class OrderController extends StateNotifier<OrderState> {
  OrderController() : super(OrderState());

  getOrder() async {
    final response = await OrderApis().getOrderApi();
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
