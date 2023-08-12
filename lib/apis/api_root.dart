import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import '../material_app_theme.dart';

class Api {
  getDio(userToken) {
    BaseOptions options = BaseOptions(
      baseUrl: baseRoot,
      connectTimeout: 30 * 1000,
      receiveTimeout: 30 * 1000,
      headers: userToken == null
          ? {'Content-Type': "application/json"}
          : {
              'authorization': 'Bearer $userToken',
              "Content-Type": "application/json",
            },
    );

    Dio dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return dio;
  }

  Future getRequestBase(String path, Map<String, dynamic>? params) async {
    try {
      var userToken = await SecureStorage().getKeyStorage("token");

      Dio dio = await getDio(userToken);
      var response = await dio.get(path, queryParameters: params);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        logOutWhenTokenError();
        return null;
      }
    }
    return null;
  }

  Future postRequestBase(String path, data) async {
    try {
      var userToken = await SecureStorage().getKeyStorage("token");
      Dio dio = await getDio(userToken);
      var response = await dio.post(path, data: data);
      return response.data;
    } on DioError catch (e) {
      return {
        "status_code": e.response?.statusCode,
        "content": e.response?.data
      };
      // if (e.response?.statusCode == 400) {
      //   Logger logger = Logger();
      //   logger.e(e.response?.data.toString());
      //   return {"status": e.response?.statusCode, "content": e.response?.data};
      // }
      // if (e.response?.statusCode == 401) {
      //   logOutWhenTokenError();
      // }
      // if (e.response?.statusCode == 422) {
      //   return e.response?.data;
      // }
      // if (e.response?.statusCode == 500) {
      //   Logger logger = Logger();
      //   String message = "Server đang có vấn đề. Hãy thử lại sau";
      //   logger.e(message);
      //   return {"status": e.response?.statusCode, "content": message};
      // } 
    }
  }

  Future postRequestBaseWithParams(String path, data) async {
    try {
      var userToken = await SecureStorage().getKeyStorage("token");
      Dio dio = await getDio(userToken);
      var response = await dio.post(
        path,
        queryParameters: data,
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        logOutWhenTokenError();
      }
    }
  }

  Future patchRequestBase(String path, data) async {
    try {
      var userToken = await SecureStorage().getKeyStorage("token");

      Dio dio = await getDio(userToken);
      var response = await dio.patch(path, data: data);
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        logOutWhenTokenError();
      }
    }
  }

  Future deleteRequestBase(String path, data) async {
    try {
      var userToken = await SecureStorage().getKeyStorage("token");

      Dio dio = await getDio(userToken);
      var response = await dio.delete(path, data: data);
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        logOutWhenTokenError();
      }
    }
  }

  Future postRequestBaseNoTokenDefault(String path, token, data) async {
    try {
      Dio dio = await getDio(token);
      var response = await dio.post(path, data: data);
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        logOutWhenTokenError();
      }
    }
  }
}

// case token changed while update password and logout other device
void logOutWhenTokenError() async {
  var newList = await SecureStorage().getKeyStorage('dataLogin');
  var id = await SecureStorage().getKeyStorage("userId");

  List listAccount = [];

  if (newList != null && newList != 'noData') {
    listAccount = jsonDecode(newList) ?? [];
  }

  if (id != null) {
    await SecureStorage().saveKeyStorage(
        jsonEncode(listAccount
            .map((element) =>
                element['id'] == id ? {...element, 'token': null} : element)
            .toList()),
        'dataLogin');
  }
  await SecureStorage().deleteKeyStorage('token');
  navigateToSecondPageByNameWithoutContext('/');
}
