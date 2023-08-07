
import 'package:social_network_app_mobile/apis/api_root.dart';

class DeliveryAddressApis {
  Future postDeliveryAddressApi(dynamic data) async { 
    return await Api().postRequestBase("/api/v1/delivery_addresses", data);
  }

  Future updateDeliveryAddressApi(dynamic id, dynamic data) async {
    return await Api().patchRequestBase("/api/v1/delivery_addresses/$id", data);
  }

  Future getDeliveryAddressApi() async {
    return await Api().getRequestBase("/api/v1/delivery_addresses", null);
  }

  Future deleteDeliveryAddressApi(dynamic data) async {
    return await Api().deleteRequestBase("/api/v1/delivery_addresses/2", data);
  }
}
