
import 'package:social_network_app_mobile/apis/api_root.dart';

class DetailProductApi {
  Future getDetailProductApi(id) async { 
    return await Api().getRequestBase("/api/v1/products/$id", null);
  }
}
