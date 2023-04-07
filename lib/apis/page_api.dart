import 'package:social_network_app_mobile/apis/api_root.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'dart:io';

import 'config.dart';

class PageApi {
  fetchListPageAdmin(params) async {
    return await Api().getRequestBase("/api/v1/pages", params);
  }

  fetchListPageLiked(params, id) async {
    return await Api()
        .getRequestBase("/api/v1/accounts/$id/page_likes", params);
  }

  fetchListPageInvitedLike() async {
    return await Api().getRequestBase("/api/v1/page_invitation_follows", null);
  }

  fetchListPageInvitedManage() async {
    return await Api().getRequestBase("/api/v1/page_invitations", null);
  }

  searchCategoryPage(params) async {
    return await Api().getRequestBase("/api/v1/page_categories", params);
  }

  Future getListPostPageApi(params, id) async {
    return await Api().getRequestBase('/api/v1/timelines/page/$id', params);
  }

  Future getListPostPagePinedApi(id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/pins', null);
  }

  Future getListReviewPageApi(params, id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/feedbacks', params);
  }

  Future getListMediaPageApi(params, id) async {
    return await Api()
        .getRequestBase('/api/v1/pages/$id/media_attachments', params);
  }

  Future getListAlbumPageApi(params, id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/albums', params);
  }

  Future handleDeleteReviewPageApi(idPage, idFeedback) async {
    return await Api()
        .deleteRequestBase('/api/v1/pages/$idPage/feedbacks/$idFeedback', null);
  }

  Future handleReviewPageApi(idPage, params) async {
    return await Api()
        .postRequestBase('/api/v1/pages/$idPage/feedbacks', params);
  }

  Future handleLikeFollowPage(idPage, action) async {
    return await Api().postRequestBase('/api/v1/pages/$idPage/$action', null);
  }

  Future<http.Response> createPage(data) async {
    // return await Api().postRequestBase("/api/v1/pages", params);
    var token = await SecureStorage().getKeyStorage("token");

    FormData formdata = FormData();
    formdata.addField('title', data['title']);
    formdata.addField('description', data['description']);

    for (int i = 0; i < data['page_category'].length; i++) {
      formdata.addField('page_category_ids[]', data['page_category'][i]);
    }

    if (data['avatar'] != null) {
      if (data['avatar']['file'] != null) {
        formdata.addFile('avatar[file]', data['avatar']['file']);
      }
      if (data['avatar']['id'] != null) {
        formdata.addField('avatar[id]', data['avatar']['id']);
      }
      formdata.addField('avatar[show_url]', data['avatar']['show_url']);
      formdata.addField('avatar[status]', data['avatar']['status']);
    }

    if (data['banner'] != null) {
      if (data['banner']['file'] != null) {
        formdata.addFile('banner[file]', data['banner']['file']);
      }
      if (data['banner']['id'] != null) {
        formdata.addField('banner[id]', data['banner']['id']);
      }
      formdata.addField('banner[show_url]', data['banner']['show_url']);
    }
    var uri = Uri.parse('$baseRoot/api/v1/pages');

    var request = http.MultipartRequest('post', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(formdata.fields)
      ..files.addAll(formdata.files);

    var response = await request.send();
    if (response.statusCode == 401) {
      logOutWhenTokenError();
    }
    return http.Response.fromStream(response);
  }
}

class FormData {
  List<http.MultipartFile> files = [];
  Map<String, String> fields = {};

  void addField(String key, String value) {
    fields[key] = value;
  }

  void addFile(String key, String filePath) {
    files.add(http.MultipartFile.fromBytes(
      key,
      File(filePath).readAsBytesSync(),
      filename: filePath.split('/').last,
      contentType: MediaType('application', 'octet-stream'),
    ));
  }
}
