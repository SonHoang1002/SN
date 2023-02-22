// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:social_network_app_mobile/apis/market_place_apis/cart_apis.dart';

// final cartProductsProvider =
//     StateNotifierProvider<CartProductsController, CartProductsState>(
//         (ref) => CartProductsController());

// class CartProductsController extends StateNotifier<CartProductsState> {
//   CartProductsController() : super(CartProductsState());

//   initCartProductList() async {
//     final response = await CartProductApi().getCartProductApi();
//     state = state.copyWith(response);
//   }

//   updateCartProductList(List<dynamic> newList) async {
//     print("cart updateCartProductList :${newList}");
//     state = state.copyWith([]);
//     state = state.copyWith(newList);
//   }

//   updateCartQuantity(dynamic data) async {
//     final response = await CartProductApi().updateQuantityProductApi(data);
//     print("cart: ${response}");
//   }

//   deleteCartProduct(dynamic data) async {
//     final response = await CartProductApi().deleteCartProductApi(data);
//     print("cart: ${response}");
//   }
// }

// class CartProductsState {
//   List<dynamic> listCart;
//   CartProductsState({this.listCart = const []});
//   CartProductsState copyWith(List<dynamic> list) {
//     return CartProductsState(listCart: list);
//   }
// }

// final checkBoxCartProductsProvider =

//     StateNotifierProvider<CheckBoxCartProductsController, CheckBoxCartProductsState>(
//         (ref) => CheckBoxCartProductsController());

// class CheckBoxCartProductsController extends StateNotifier<CheckBoxCartProductsState> {
//   CheckBoxCartProductsController() : super(CheckBoxCartProductsState());

//   initCheckBoxCartProductList() async {
//     state = state.copyWith([]);
//   }

//   updateCheckBoxCartProductList(List<dynamic> newCheckBoxList) async {
//     print("cart newCheckBoxList :${newCheckBoxList}");
//     state = state.copyWith(newCheckBoxList);
//   }

// }
// class CheckBoxCartProductsState {
//   List<dynamic> listCartCheckbox;
//   CheckBoxCartProductsState({this.listCartCheckbox = const []});
//   CheckBoxCartProductsState copyWith(List<dynamic> list) {
//     return CheckBoxCartProductsState(listCartCheckbox: list);
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/cart_apis.dart';

final cartProductsProvider =
    StateNotifierProvider<CartProductsController, CartProductsState>(
        (ref) => CartProductsController());

class CartProductsController extends StateNotifier<CartProductsState> {
  CartProductsController() : super(CartProductsState());

  initCartProductList() async {
    final response = await CartProductApi().getCartProductApi();
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

  updateCartQuantity(dynamic data) async {
    final response = await CartProductApi().updateQuantityProductApi(data);
    print("cart:updateCartQuantity: ${response}");
  }

  deleteCartProduct(dynamic data) async {
    print("cart data of deleleApi :$data");
    final response = await CartProductApi().deleteCartProductApi(data);
    print("cart:delete: ${response}");
  }
}

class CartProductsState {
  List<dynamic> listCart;
  CartProductsState({this.listCart = const []});
  CartProductsState copyWith(List<dynamic> list) {
    return CartProductsState(listCart: list);
  }
}

// final checkBoxCartProductsProvider =

//     StateNotifierProvider<CheckBoxCartProductsController, CheckBoxCartProductsState>(
//         (ref) => CheckBoxCartProductsController());

// class CheckBoxCartProductsController extends StateNotifier<CheckBoxCartProductsState> {
//   CheckBoxCartProductsController() : super(CheckBoxCartProductsState());

//   initCheckBoxCartProductList() async {
//     state = state.copyWith([]);
//   }

//   updateCheckBoxCartProductList(List<dynamic> newCheckBoxList) async {
//     print("cart newCheckBoxList :${newCheckBoxList}");
//     state = state.copyWith(newCheckBoxList);
//   }

// }
// class CheckBoxCartProductsState {
//   List<dynamic> listCartCheckbox;
//   CheckBoxCartProductsState({this.listCartCheckbox = const []});
//   CheckBoxCartProductsState copyWith(List<dynamic> list) {
//     return CheckBoxCartProductsState(listCartCheckbox: list);
//   }
// }
