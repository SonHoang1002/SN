import 'package:social_network_app_mobile/apis/api_root.dart';

class GroupApi {
  fetchListGroupAdminMember(params) async {
    return await Api().getRequestBase('/api/v1/groups', params);
  }

  fetchListGroupFeed(params) async {
    return await Api()
        .getRequestBase('/api/v1/timelines/group_collection', params);
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
}
