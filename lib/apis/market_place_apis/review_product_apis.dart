import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

class ReviewProductApi {
  Future getReviewProductApi(String id) async {
    return await Api()
        .getRequestBase('/api/v1/products/${id}/list_rating', null);
  }
    Future createReviewProductApi(dynamic id, dynamic data) async {
    return await Api()
        .postRequestBase('/api/v1/orders/$id/product_rating', data);
  }
}
