import 'package:market_place/apis/api_root.dart';

class ProductsApi {
  Future getProductsApi() async {
    return await Api().getRequestBase('/api/v1/products', null);
  }

  Future postCreateProductApi(dynamic data) async {
    return await Api().postRequestBase("/api/v1/products", data);
  }

  Future deleteProductApi(dynamic id) async {
    return await Api().deleteRequestBase("/api/v1/products/$id", null);
  }

  Future updateProductApi(dynamic id, dynamic data) async {
    return await Api().patchRequestBase("/api/v1/products/$id", data);
  }

  Future getUserProductList(
    dynamic pageId,
  ) async {
    return await Api().getRequestBase("/api/v1/products?page_id=$pageId", null);
  }
}
