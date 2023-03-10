import 'package:social_network_app_mobile/apis/api_root.dart';

class ProductRatingApis {
  Future getDeliveryAddressApi(dynamic id) async {
    return await Api().getRequestBase("/api/v1/products/$id/list_rating", null);
  }
}
