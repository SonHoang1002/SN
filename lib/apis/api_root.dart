import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/model/post.dart';

class Api {
  BaseOptions options = BaseOptions(
    baseUrl: baseRoot,
    connectTimeout: 30 * 1000,
    receiveTimeout: 30 * 1000,
    headers: {'authorization': 'Bearer $userToken'},
  );

  Dio getDio() {
    return Dio(options);
  }

  Future getRequestBase(String path, Map<String, dynamic>? params) async {
    try {
      Dio dio = getDio();
      var response = await dio.get(path, queryParameters: params);
      return response.data;
    } on DioError catch (e) {
      print(e.toString());
    }
  }
}
