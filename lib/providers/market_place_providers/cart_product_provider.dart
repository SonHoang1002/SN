import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/cart_apis.dart';

final cartProductsProvider =
    StateNotifierProvider<CartProductsController, CartProductsState>(
        (ref) => CartProductsController());

class CartProductsController extends StateNotifier<CartProductsState> {
  CartProductsController() : super(CartProductsState());

  initCartProductList() async {
    final response = await CartProductApi().getCartProductApi() ?? [];
    for (int i = 0; i < response.length; i++) {
      response[i]["check"] = false;
      for (int j = 0; j < response[i]["items"].length; j++) {
        response[i]["items"][j]["check"] = false;
      }
    }
    state = state.copyWith(response);
  }

  updateCartProductList(List<dynamic> newList) async {
    state = state.copyWith(newList);
  }

  updateCartQuantity( dynamic data) async {
    final response = await CartProductApi().updateQuantityProductApi( data);
  }

  deleteCartProduct(dynamic id, dynamic data) async {
    final response = await CartProductApi().deleteCartProductApi(id, data);
  }

  dynamic getCartCounter(List<dynamic> cartList) {
    dynamic counter = 0;
    cartList.forEach((element) {
      counter += element["items"].length;
    });
    return counter;
  }
}

class CartProductsState {
  List<dynamic> listCart;
  CartProductsState({this.listCart = const []});
  CartProductsState copyWith(List<dynamic> list) {
    return CartProductsState(listCart: list);
  }
}
