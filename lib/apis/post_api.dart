import 'dart:convert';

import 'api_root.dart';

class PostApi {
  Future getListPostApi(params) async {
    return await Api().getRequestBase('/api/v1/timelines/home', params);
  }

  Future getListPostPinApi(accountId) async {
    return await Api().getRequestBase("/api/v1/accounts/$accountId/pin", null);
  }

  Future getListCommentPost(String postId, params) async {
    return await Api().getRequestBase('/api/v1/comments/$postId', params);
  }

  Future getPostDetailMedia(String postId) async {
    return await Api().getRequestBase('/api/v1/media/$postId', null);
  }

  Future createStatus(data) async {
    return await Api().postRequestBase('/api/v1/statuses', data);
  }

  Future updatePost(postId, data) async {
    return await Api().patchRequestBase('/api/v1/statuses/$postId', data);
  }

  Future pinPostApi(postId) async {
    return await Api().postRequestBase('/api/v1/statuses/$postId/pin', null);
  }

  Future unPinPostApi(postId) async {
    return await Api().postRequestBase('/api/v1/statuses/$postId/unpin', null);
  }

  Future savePostApi(postId) async {
    return await Api()
        .postRequestBase('/api/v1/statuses/$postId/bookmark', null);
  }

  Future turnOnNotification(postId) async {
    return Api().postRequestBase(
        '/api/v1/allow_notification_posts?status_id=$postId', null);
  }

  Future turnOffNotification(postId) async {
    return Api()
        .deleteRequestBase("/api/v1/allow_notification_posts/$postId", null);
  }

  Future deletePostApi(postId) async {
    return Api().deleteRequestBase("/api/v1/statuses/$postId", null);
  }

  Future reportPostApi(data) async {
    return await Api().postRequestBase("/api/v1/reports", data);
  }

  Future reactionPostApi(idPost, data) async {
    return await Api()
        .postRequestBase("/api/v1/statuses/$idPost/favourite", data);
  }

  Future unReactionPostApi(idPost) async {
    return await Api()
        .postRequestBase("/api/v1/statuses/$idPost/unfavourite", null);
  }

  Future getListFavourited(idPost, params) async {
    return await Api()
        .getRequestBase('/api/v1/statuses/$idPost/favourited_by', params);
  }

  Future getListPostReblog(idPost, params) async {
    return await Api()
        .getRequestBase('/api/v1/statuses/$idPost/reblog', params);
  }

  Future getListMomentUser(idUser) async {
    return await Api().getRequestBase(
        '/api/v1/accounts/$idUser/statuses?post_type_moment=true', null);
  }

  Future getListMomentPage(idPage) async {
    return await Api().getRequestBase(
        '/api/v1/accounts/$idPage/statuses?post_type_moment=true', null);
  }

  Future postCompleteTarget(dynamic postId) async {
    return await Api()
        .postRequestBase('/api/v1/statuses/$postId/complete_target', null);
  }

  Future signPollPost(dynamic pollId, dynamic params) async {
    return await Api().postRequestBase('/api/v1/polls/$pollId/votes', params);
  }

  Future updatePollPost(dynamic pollId, dynamic params) async {
    return await Api()
        .patchRequestBase('/api/v1/polls/$pollId/votes/123', params);
  }
}
