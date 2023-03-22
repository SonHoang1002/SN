import 'package:dio/dio.dart';
import 'package:market_place/constant/config.dart';
import 'package:market_place/screens/Auth/storage.dart';

class Api {
  Future<Dio> getDio() async {
    final primaryToken = await SecureStorage().getKeyStorage("token");
    final userToken =
        primaryToken != null && primaryToken != "" && primaryToken != "noData"
            ? primaryToken
            : "1WJ_KeBJDF9pLtaUeV33sXjCshUzEDcanptxXD0Vn7A";
    BaseOptions options = BaseOptions(
      baseUrl: urlSocialNetwork,
      connectTimeout: 30 * 1000,
      receiveTimeout: 30 * 1000,
      headers: {'authorization': 'Bearer ${userToken}'},
    );
    return Dio(options);
  }

  Future getRequestBase(String path, Map<String, dynamic>? params) async {
    try {
      Dio dio = await getDio();
      var response = await dio.get(path, queryParameters: params);
      return response.data;
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  Future postRequestBase(String path, data) async {
    try {
      Dio dio = await getDio();
      var response = await dio.post(path, data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future patchRequestBase(String path, data) async {
    try {
      Dio dio = await getDio();
      var response = await dio.patch(path, data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteRequestBase(String path, data) async {
    try {
      Dio dio = await getDio();
      var response = await dio.delete(path);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }
}
