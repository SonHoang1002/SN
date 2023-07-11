import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:market_place/apis/api_root.dart';

class DetailProductApi {
  Future getDetailProductApi(id) async { 
    return await Api().getRequestBase("/api/v1/products/$id", null);
  }
}
