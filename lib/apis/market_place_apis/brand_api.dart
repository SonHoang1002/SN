
import 'package:social_network_app_mobile/apis/api_root.dart';

class BrandProductApi {
// https://snapi.emso.asia/api/v1/list_brand_by_product_category?product_category_id=4636

  Future getBrandProduct(dynamic params) async {
    return await Api()
        .getRequestBase("/api/v1/list_brand_by_product_category?", params);
  }
}
