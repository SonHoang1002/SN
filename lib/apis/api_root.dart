import 'package:dio/dio.dart';
import 'package:social_network_app_mobile/apis/config.dart';

class Api {
  BaseOptions options = BaseOptions(
    baseUrl: baseRoot,
    connectTimeout: 30 * 1000,
    receiveTimeout: 30 * 1000,
    headers: {
      'authorization': 'Bearer $userToken',
      "Content-Type": "application/json",
    },
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

  Future postRequestBase(String path, data) async {
    try {
      Dio dio = getDio();
      var response = await dio.post(path, data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future patchRequestBase(String path, data) async {
    try {
      Dio dio = getDio();
      var response = await dio.patch(path, data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteRequestBase(String path, data) async {
    try {
      Dio dio = getDio();
      var response = await dio.delete(path, data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }
}
