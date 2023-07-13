import 'dart:convert';

import 'package:social_network_app_mobile/apis/api_root.dart';

class ProductsApi {
  Future getProductSearchApi(dynamic params) async {
    final response =
        await Api().getRequestBase('/api/v1/product_search', params);
    return response;
  }

  Future getProductsApi(dynamic params) async {
    return await Api().getRequestBase('/api/v1/products', params);
  }

  Future postCreateProductApi(dynamic data) async {
    return await Api().postRequestBase("/api/v1/products", data);
  }

  Future deleteProductApi(dynamic id) async {
    return await Api().deleteRequestBase("/api/v1/products/$id", null);
  }
  

  Future updateProductApi(dynamic id, dynamic data) async { 
    final response = await Api().patchRequestBase("/api/v1/products/$id", data);
    return response;
  }

  Future getUserProductList(
    dynamic pageId,
  ) async {
    return await Api().getRequestBase("/api/v1/products?page_id=$pageId", null);
  }
}
