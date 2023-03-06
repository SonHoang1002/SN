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
    state = state.copyWith(response);
    print("order: $response");
  }
}
