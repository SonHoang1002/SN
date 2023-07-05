import 'package:social_network_app_mobile/apis/api_root.dart';

class GroupApi {
  fetchListGroupAdminMember(params) async {
    return await Api().getRequestBase('/api/v1/groups', params);
  }

  Future fetchGroupDetail(id) async {
    return await Api().getRequestBase('/api/v1/groups/$id', null);
  }

  Future fetchGroupRole(params, id) async {
    return await Api().getRequestBase('/api/v1/groups/$id/accounts', params);
  }

  fetchListGroupFeed(params) async {
    return await Api()
        .getRequestBase('/api/v1/timelines/group_collection', params);
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
    return Api().getRequestBase("/api/v1/groups/$id/member_questions", null);
  }

  fetchJoinRequest(dynamic id) async {
    return Api().getRequestBase("/api/v1/groups/$id/join_requests", null);
  }

  fetchPendingStatus(dynamic id) async {
    return Api().getRequestBase("/api/v1/groups/$id/pending_statuses", null);
  }

  fetchReportedStatus(dynamic id) async {
    return Api().getRequestBase("/api/v1/groups/$id/reported_statuses", null);
  }

  fetchStatusAlert(dynamic id) async {
    return Api().getRequestBase("/api/v1/groups/$id/status_alerts", null);
  }

  fetchScheduledStatus(dynamic id) async {
    return Api().getRequestBase("/api/v1/groups/$id/scheduled_statuses", null);
  }

  fetchRules(dynamic id) async {
    return Api().getRequestBase("/api/v1/groups/$id/rules", null);
  }
}
