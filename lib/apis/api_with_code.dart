import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import '../material_app_theme.dart';

class ApiWithCode {
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

  Future getRequestBaseWithCode(
      String path, Map<String, dynamic>? params) async {
    try {
      var userToken = await SecureStorage().getKeyStorage("token");

      Dio dio = await getDio(userToken);
      var response = await dio.get(path, queryParameters: params);
      if (response.statusCode == 200) {
        return response;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        logOutWhenTokenError();
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
    navigateToSecondPageByNameWithoutContext('/login');
  }
}
