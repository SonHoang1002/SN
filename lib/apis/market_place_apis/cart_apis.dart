import 'dart:convert';

import 'package:social_network_app_mobile/apis/api_root.dart';

class CartProductApi {
  Future postCartProductApi(dynamic data) async {
    return await Api().postRequestBase("/api/v1/shopping_carts", data);
  }

  Future updateQuantityProductApi(dynamic id, dynamic data) async {
    return await Api().patchRequestBase("/api/v1/shopping_carts/$id", data);
  }

  Future getCartProductApi() async {
    return await Api().getRequestBase("/api/v1/shopping_carts", null);
  }

  Future deleteCartProductApi(dynamic id, dynamic data) async {
    final response =
        await Api().deleteRequestBase("/api/v1/shopping_carts/$id", data);
    return response;
  }
}
