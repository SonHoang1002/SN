import 'package:social_network_app_mobile/apis/api_root.dart';

class CategoryProductApis {
  

  Future getParentCategoryProductApi() async {
    return await Api().getRequestBase("/api/v1/product_categories", null);
  }
   Future getChildCategoryProductApi(dynamic id) async {
    return await Api().getRequestBase("/api/v1/product_categories/$id", null);
  }



}
