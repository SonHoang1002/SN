import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:social_network_app_mobile/apis/config.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import 'api_root.dart';

class UserPageApi {
  // 300ms - 8 s
  Future getListPostApi(accountId, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$accountId/statuses', params);
  }

// 500ms - 1.5 s
  Future getListLifeEvent(accountId) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$accountId/life_events', null);
  }

  // 284 ms
  Future getAccountInfor(idUser) async {
    return await Api().getRequestBase('/api/v1/accounts/$idUser', null);
  }

  // 131ms
  Future getAccountAboutInformation(idUser) async {
    return await Api().getRequestBase('/api/v1/accounts/$idUser/abouts', null);
  }

  Future updateOtherInformation(idUser, data) async {
    return await Api()
        .postRequestBase('/api/v1/account_general_infomation', data);
  }

  Future getUserMedia(idUser, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$idUser/media_attachments', params);
  }

  Future getUserAlbum(idUser, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$idUser/albums', params);
  }

  Future getUserMediaAlbum(idAlbum, params) async {
    return await Api()
        .getRequestBase('/api/v1/albums/$idAlbum/media_attachments', params);
  }

//1,2 s
  Future getUserFriend(idUser, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$idUser/friendships', params);
  }

//345ms
  Future getUserFeatureContent(idUser) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$idUser/featured_contents', null);
  }

  Future getUserFeatureContentMedia(idUser, idEntity) async {
    return await Api().getRequestBase(
        '/api/v1/accounts/$idUser/featured_contents/$idEntity/media_attachments',
        null);
  }

  Future getHobbiesByCategories(String keyword) async {
    return await Api()
        .getRequestBase('/api/v1/categories', {"keyword": keyword});
  }

  Future getMediaAttachment(String userId, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$userId/media_attachments', params);
  }

  Future createNoticeCollection(data) async {
    return await Api()
        .postRequestBase('/api/v1/account_featured_contents', data);
  }

  Future getLivingPlaceByKeyword(String keyword) async {
    return await Api().getRequestBase('/api/v1/places', {"keyword": keyword});
  }

  Future changePassword(params) async {
    return await Api().postRequestBase('/api/v1/change_password', params);
  }

  Future forgotPassword(params) async {
    return await Api().postRequestBase('/api/v1/forgot_password', params);
  }

  Future sendReconfirmation(params) async {
    return await Api().postRequestBase('/api/v1/reconfirmation', params);
  }

  Future getWatchHistory(params) async {
    return await Api().getRequestBase('/api/v1/watch_histories', params);
  }

  Future removeWatchHistory(id) async {
    return await Api().deleteRequestBase('/api/v1/watch_histories/$id', null);
  }

  Future getSearchHistory(params) async {
    return await Api().getRequestBase('/api/v1/search_histories', params);
  }

  Future removeSearchHistory(id) async {
    return await Api().deleteRequestBase('/api/v1/search_histories/$id', null);
  }

  Future getLikePage(id, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$id/page_likes', params);
  }

  Future suspendUser() async {
    return await Api().postRequestBase('/api/v1/suspend', null);
  }

  Future getTagSetting() async {
    return await Api().getRequestBase('/api/v1/account_settings', null);
  }

  Future updateTagSetting(params) async {
    return await Api().postRequestBase('/api/v1/account_settings', params);
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

  Future checkUsername(data) async {
    return await Api().getRequestBase('/api/v1/validate_username', data);
  }
}
