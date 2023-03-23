import 'package:social_network_app_mobile/apis/api_root.dart';

class OrderApis {
  Future getOrderApi() async {
    return await Api().getRequestBase('/api/v1/orders', null);
  }

  Future verifyFinishOrderApi(dynamic id, dynamic data) async {
    return await Api()
        .postRequestBase("/api/v1/orders/$id/verify_delivered", data);
  }

  Future updateStatusOrderApi(dynamic id, dynamic data) async {
    return await Api().patchRequestBase("/api/v1/orders/$id", data);
  }
  // Future updateProductApi(dynamic id) async {
  //   return await Api().postRequestBase("/api/v1/orders/$id", null);
  // }
}
