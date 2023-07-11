import 'dart:convert';

import 'package:market_place/apis/api_root.dart';

class CategoryProductApis {
  Future getParentCategoryProductApi() async {
    return await Api().getRequestBase("/api/v1/product_categories", null);
  }

  Future getChildCategoryProductApi(dynamic id, dynamic params) async {
    final response =
        await Api().getRequestBase("/api/v1/product_categories/$id", params);
    return response;
  }
}
