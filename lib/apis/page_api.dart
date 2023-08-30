import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import 'api_with_code.dart';
import 'config.dart';

class PageApi {
  fetchListPageAdmin(params) async {
    return await Api().getRequestBase("/api/v1/pages", params);
  }

  fetchListPageSuggest(params) async {
    return await Api().getRequestBase("/api/v1/suggestions/page", params);
  }

  blockPage(data) async {
    return await Api().postRequestBase("/api/v1/block_pages", data);
  }

  fetchPageDetail(id) async {
    return await Api().getRequestBase("/api/v1/pages/$id", null);
  }

  fetchPageCategories(params) async {
    return await Api().getRequestBase("/api/v1/page_categories", params);
  }

  validPageUsername(params) async {
    return await ApiWithCode()
        .getRequestBaseWithCode("/api/v1/pages_validate_username", params);
  }

  fetchSearchPageDetail(id, params) async {
    return await Api()
        .getRequestBase("/api/v1/timelines/page/$id/search", params);
  }

  followPage(id) async {
    return await Api().getRequestBase("/api/v1/pages/$id/follows", null);
  }

  unfollowPage(id) async {
    return await Api().getRequestBase("/api/v1/pages/$id/follows", null);
  }

  fetchListPageLiked(params, id) async {
    return await Api()
        .getRequestBase("/api/v1/accounts/$id/page_likes", params);
  }

  createInviteLikePage(params, id) async {
    return await Api()
        .postRequestBase("/api/v1/pages/$id/invitation_follows", params);
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

  Future postInviteManage(data, id) async {
    return await Api().postRequestBaseWithParams(
        '/api/v1/pages/$id/invitations/invitations_respond', data);
  }

  Future postInviteLike(data, id) async {
    return await Api().postRequestBaseWithParams(
        '/api/v1/pages/$id/invitation_follows/invitation_follows_respond',
        data);
  }

  Future getListPostPagePinedApi(id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/pins', null);
  }

  Future getNotificationsPageApi(id) async {
    return await Api()
        .getRequestBase('/api/v1/pages/$id/setting_notifications', null);
  }

  Future updateNotificationsPage(params, id) async {
    return await Api()
        .patchRequestBase('/api/v1/pages/$id/setting_notifications', params);
  }

  Future getListAdminPage(id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/accounts', null);
  }

  Future getListInvitePage(id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/invitations', null);
  }

  Future sendInviteManagePage(id, params) async {
    return await Api()
        .postRequestBaseWithParams('/api/v1/pages/$id/invitations', params);
  }

  Future removeInviteManagePage(id, userId) async {
    return await Api()
        .deleteRequestBase('/api/v1/pages/$id/invitations/$userId', null);
  }

  Future removeUserManagePage(id, userId) async {
    return await Api()
        .deleteRequestBase('/api/v1/pages/$id/accounts/$userId', null);
  }

  Future updateUserManagePage(id, userId, params) async {
    return await Api()
        .patchRequestBase('/api/v1/pages/$id/accounts/$userId', params);
  }

  Future updatePageHolder(id, params) async {
    return await Api()
        .patchRequestBase('/api/v1/pages/$id/account_holder', params);
  }

  Future getPageLikeAccount(id) async {
    return await Api().getRequestBase(
        '/api/v1/pages/$id/likes', {"excluded_page_account": true});
  }

  Future getPageFollowerAccount(id) async {
    return await Api().getRequestBase(
        '/api/v1/pages/$id/follows', {"excluded_page_account": true});
  }

  Future getPageBlockAccount(id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/blocks', null);
  }

  Future pageBlockAccount(id, params) async {
    return await Api().postRequestBase('/api/v1/pages/$id/blocks', params);
  }

  Future unblockPage(id) async {
    return await Api().deleteRequestBase('/api/v1/block_pages/$id', null);
  }

  Future pageUnblockAccount(id, params) async {
    return await Api().deleteRequestBase('/api/v1/pages/$id/blocks', params);
  }

  Future pagePostMedia(data, id) async {
    return await Api().patchRequestBase('/api/v1/pages/$id', data);
  }

  Future getListReviewPageApi(params, id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/feedbacks', params);
  }

  Future getListMediaPageApi(params, id) async {
    return await Api()
        .getRequestBase('/api/v1/pages/$id/media_attachments', params);
  }

  Future getManagementHistory(params, id) async {
    return await Api()
        .getRequestBase('/api/v1/pages/$id/management_histories', params);
  }

  Future getListAlbumPageApi(params, id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/albums', params);
  }

  Future getListGroupPageApi(params, id) async {
    return await Api()
        .getRequestBase('/api/v1/pages/$id/linked_groups', params);
  }

  Future getListPhotoAlbumPageApi(params, id) async {
    return await Api()
        .getRequestBase('/api/v1/albums/$id/media_attachments', params);
  }

  Future handleDeleteReviewPageApi(idPage, idFeedback) async {
    return await Api()
        .deleteRequestBase('/api/v1/pages/$idPage/feedbacks/$idFeedback', null);
  }

  Future handleReviewPageApi(idPage, params) async {
    return await Api()
        .postRequestBase('/api/v1/pages/$idPage/feedbacks', params);
  }

  Future likePageSuggestion(idPage) async {
    return await Api().postRequestBase('/api/v1/pages/$idPage/likes', null);
  }

  Future unLikePageSuggestion(idPage) async {
    return await Api().postRequestBase('/api/v1/pages/$idPage/unlikes', null);
  }

  Future handleLikeFollowPage(idPage, action) async {
    return await Api().postRequestBase('/api/v1/pages/$idPage/$action', null);
  }

  Future handleBlockPage(params) async {
    return await Api().postRequestBase('/api/v1/block_pages', params);
  }

  Future getSettingsPage(id) async {
    return await Api().getRequestBase('/api/v1/pages/$id/settings', null);
  }

  Future updateSettingsPage(id, data) async {
    return await Api().patchRequestBase('/api/v1/pages/$id/settings', data);
  }

  Future activeEarnMoney(params) async {
    return await Api().postRequestBase('/api/v1/earn_moneys', params);
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
