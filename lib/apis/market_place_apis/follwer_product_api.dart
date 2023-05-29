import 'package:market_place/apis/api_root.dart';

class FollwerProductsApi {
  Future postFollwerProductsApi(dynamic id) async {
    return await Api().postRequestBase('/api/v1/products/$id/product_followers', null);
  }
  Future deleteFollwerProductsApi(dynamic id) async {
    return await Api().deleteRequestBase('/api/v1/products/$id/product_followers/1', null);
  }
    Future getFollwerProductsApi() async {
    return await Api().getRequestBase('/api/v1/products?limit=10&following=true', null);
  }
}