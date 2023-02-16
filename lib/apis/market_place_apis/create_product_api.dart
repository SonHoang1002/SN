import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

class CreateProductApi {
  Future postCreateProductApi(dynamic data) async {
    return await Api().postRequestBase("/api/v1/products", data);
  }
}
