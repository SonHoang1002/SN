import 'package:social_network_app_mobile/apis/api_root.dart';

class DeliveryAddressApis{
  Future postDeliveryAddressApi(dynamic data) async {
    return await Api().postRequestBase("/api/v1/delivery_addresses", data);
    // https://mangxahoi.atlassian.net/wiki/spaces/SN/pages/23298051/Th+m+s+a+x+a+a+ch+giao+h+ng
  }

  Future updateDeliveryAddressApi(dynamic data) async {
    return await Api().patchRequestBase("/api/v1/delivery_addresses/2", data);
  }

  Future getDeliveryAddressApi() async {
    return await Api().getRequestBase("/api/v1/delivery_addresses", null);
  }

  Future deleteDeliveryAddressApi(dynamic data) async {
    return await Api().deleteRequestBase("/api/v1/delivery_addresses/2", data);
  }
}