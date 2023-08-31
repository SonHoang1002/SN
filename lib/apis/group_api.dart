import 'package:social_network_app_mobile/apis/api_root.dart';

class GroupApi {
  fetchListGroupAdminMember(params) async {
    return await Api().getRequestBase('/api/v1/groups', params);
  }

  Future fetchGroupDetail(id) async {
    return await Api().getRequestBase('/api/v1/groups/$id', null);
  }

  Future fetchGroupRole(id) async {
    return await Api().getRequestBase('/api/v1/groups/$id/accounts', null);
  }

  Future joinGroupRequest(id) async {
    return await Api().postRequestBase('/api/v1/groups/$id/accounts', null);
  }

  Future removeGroupRequest(id) async {
    return await Api().deleteRequestBase('/api/v1/groups/$id/leave', null);
  }

  Future fetchCategories(params) async {
    return await Api().getRequestBase('/api/v1/categories', params);
  }

  Future createGroup(data) async {
    return await Api().postRequestBase('/api/v1/groups', data);
  }

  fetchListGroupFeed(params) async {
    return await Api()
        .getRequestBase('/api/v1/timelines/group_collection', params);
  }

  fetchListSuggestions(params) async {
    return await Api().getRequestBase('/api/v1/suggestions/group', params);
  }

  fetchListInviteGroup(params) async {
    final response =
        await Api().getRequestBase('/api/v1/group_invitations', params);
    return response;
  }

  fetchListJoinRequest(params) async {
    return await Api().getRequestBase('/api/v1/group_join_requests', params);
  }

  fetchListGroupPins(id) async {
    return await Api().getRequestBase('/api/v1/groups/$id/pins', null);
  }

  fetchGroupFeed(params, id) async {
    return await Api().getRequestBase('/api/v1/timelines/group/$id', params);
  }

  updateLinkedGroup(id, params) async {
    return await Api().postRequestBase('/api/v1/pages/$id/link_group', params);
  }

  removeLinkedGroup(id, params) async {
    return await Api()
        .deleteRequestBase('/api/v1/pages/$id/remove_linked_group', params);
  }

  getMemberQuestion(dynamic id) async {
    return await Api()
        .getRequestBase("/api/v1/groups/$id/member_questions", null);
  }

  fetchJoinRequest(dynamic id) async {
    return await Api().getRequestBase("/api/v1/groups/$id/join_requests", null);
  }

  fetchPendingStatus(dynamic id) async {
    return await Api()
        .getRequestBase("/api/v1/groups/$id/pending_statuses", null);
  }

  fetchUpdatePendingStatus(
      String groupId, String postId, dynamic params) async {
    return await Api().patchRequestBase(
        "/api/v1/groups/$groupId/pending_statuses?status_id=$postId", params);
  }

  fetchPostUpdateJoinRequest(dynamic groupId, dynamic params) async {
    final response = await Api()
        .postRequestBase("/api/v1/groups/$groupId/invitations/respond", params);
    return response;
  }

  fetchMediaImage(params, dynamic id) async {
    return await Api()
        .getRequestBase("/api/v1/groups/$id/media_attachments", params);
  }

  fetchAlbum(params, dynamic id) async {
    return await Api().getRequestBase("/api/v1/groups/$id/albums", params);
  }

  fetchDetailAlbum(params, dynamic id) async {
    return await Api()
        .getRequestBase("/api/v1/albums/$id/media_attachments", params);
  }

  fetchReportedStatus(dynamic id) async {
    return await Api()
        .getRequestBase("/api/v1/groups/$id/reported_statuses", null);
  }

  fetchStatusAlert(dynamic id) async {
    return await Api().getRequestBase("/api/v1/groups/$id/status_alerts", null);
  }

  fetchScheduledStatus(dynamic id) async {
    return await Api()
        .getRequestBase("/api/v1/groups/$id/scheduled_statuses", null);
  }

  fetchRules(dynamic id) async {
    return await Api().getRequestBase("/api/v1/groups/$id/rules", null);
  }

  getGroupRelationship(dynamic groupId, dynamic params) async {
    return await Api().postRequestBase("/api/v1/group_relationships", params);
  }

  updateGroupDetails(id, params) async {
    return await Api().patchRequestBase("/api/v1/groups/$id", params);
  }
}
