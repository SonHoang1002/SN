import 'dart:convert';

import 'package:market_place/apis/api_root.dart';

class OrderApis {
  Future getOrderCount() async {
    return await Api().getRequestBase('/api/v1/count_orders', null);
  }

  // người mua
  Future getBuyerOrdersApi(
      {dynamic limit = 10,
      dynamic status,
      dynamic payment_status,
      dynamic maxId}) async {
    return await Api().getRequestBase('/api/v1/orders', {
      "only_current_user": true,
      "status": status,
      "limit": limit,
      "payment_status": payment_status,
      "max_id": maxId
    });
  }

  //Người mua xác nhận đã nhận được hàng
  Future postBuyerVerifyOrderApi(dynamic id, dynamic data) async {
     final response = await Api()
        .postRequestBase("/api/v1/orders/$id/verify_delivered", data);
     return response;
  }

  // người bán
  Future getSellerOrderApi(dynamic pageId) async {
    return await Api()
        .getRequestBase('/api/v1/orders?page_id=$pageId&limit=1000', null);
  }

  Future createBuyerOrderApi(dynamic data) async {
    return await Api().postRequestBase('/api/v1/orders', data);
  }

  Future updateStatusSellerOrderApi(dynamic id, dynamic data) async {
    return await Api().patchRequestBase("/api/v1/orders/$id", data);
  }
}
