import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

class ProductCategoriesApi {
  Future getListProductCategoriesApi() async {
    return await Api()
        .getRequestBase('/api/v1/product_categories', null);
    
  }
}
