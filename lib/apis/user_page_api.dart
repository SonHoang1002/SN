import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import 'api_root.dart';

class UserPageApi {
  Future getListPostApi(accountId, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$accountId/statuses', params);
  }

  Future getListLifeEvent(accountId) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$accountId/life_events', null);
  }

  Future getAccountInfor(idUser) async {
    return await Api().getRequestBase('/api/v1/accounts/$idUser', null);
  }

  Future getAccountAboutInformation(idUser) async {
    return await Api().getRequestBase('/api/v1/accounts/$idUser/abouts', null);
  }

  Future updateOtherInformation(idUser, data) async {
    return Api().postRequestBase('/api/v1/account_general_infomation', data);
  }

  Future getUserMedia(idUser, params) async {
    return Api()
        .getRequestBase('/api/v1/accounts/$idUser/media_attachments', params);
  }

  Future getUserAlbum(idUser, params) async {
    return Api().getRequestBase('/api/v1/accounts/$idUser/albums', params);
  }

  Future getUserMediaAlbum(idAlbum, params) async {
    return Api()
        .getRequestBase('/api/v1/albums/$idAlbum/media_attachments', params);
  }

  Future getUserFriend(idUser, params) async {
    return Api().getRequestBase('/api/v1/accounts/$idUser/friendships', params);
  }

  Future getUserFeatureContent(idUser) async {
    return Api()
        .getRequestBase('/api/v1/accounts/$idUser/featured_contents', null);
  }

  Future getUserFeatureContentMedia(idUser, idEntity) async {
    return Api().getRequestBase(
        '/api/v1/accounts/$idUser/featured_contents/$idEntity/media_attachments',
        null);
  }
}

class UserPageCredentical {
  getDio(userToken) {
    BaseOptions options = BaseOptions(
      baseUrl: baseRoot,
      connectTimeout: 30 * 1000,
      receiveTimeout: 30 * 1000,
      headers: {
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

  Future updateCredentialUser(data) async {
    try {
      var userToken = await SecureStorage().getKeyStorage("token");

      Dio dio = getDio(userToken);
      var response =
          await dio.patch('/api/v1/accounts/update_credentials', data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }
}
