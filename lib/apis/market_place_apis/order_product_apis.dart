import 'package:social_network_app_mobile/apis/api_root.dart';

class OrderApis {
  Future getOrderApi() async {
    return await Api().getRequestBase('/api/v1/orders', null);
  }

  // Future verifyFinishOrderApi(dynamic id, dynamic data) async { 
  // }
  Future getOrderCount() async {
    return await Api().getRequestBase('/api/v1/count_orders', null);
  }
  // người mua

  Future getBuySellerOrderApi({dynamic limit, dynamic status}) async {
    return await Api()
        .getRequestBase('/api/v1/orders?only_current_user=true', null);
  }

  Future getPaymentStatusBuyerApi(
      {dynamic limit, dynamic paymentStatus = "unpaid"}) async {
    return await Api().getRequestBase(
        '/api/v1/orders?only_current_user=true&payment_status=$paymentStatus',
        null);
  }

  Future getStatusBuyerApi(dynamic status, {dynamic limit}) async {
    return await Api().getRequestBase(
        '/api/v1/orders?only_current_user=true&status=$status', null);
  }

  //Người mua xác nhận đã nhận được hàng
  Future verifyBuyerOrderApi(dynamic id, dynamic data) async {
    return await Api()
        .postRequestBase("/api/v1/orders/$id/verify_delivered", data);
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
