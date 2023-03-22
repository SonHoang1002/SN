import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

final eventApiProvider = Provider((ref) {
  return EventApi();
});

class EventApi {
  Future getListEventApi(params) async {
    return await Api().getRequestBase('/api/v1/events', params);
  }
  Future getListEventInviteApi(params) async {
    return await Api().getRequestBase('/api/v1/event_invitations', params);
  }
  Future getListEventInviteHostsApi() async {
    return await Api().getRequestBase('/api/v1/event_invitation_hosts', {});
  }
  Future getEventHostApi(id) async {
    return await Api().getRequestBase('/api/v1/events/$id/hosts', {});
  }

  Future getEventSuggestedApi(params) async {
    return await Api().getRequestBase('/api/v1/suggestions/event', params);
  }

  Future getEventDetailApi(id) async {
    return await Api().getRequestBase('/api/v1/events/$id', {});
  }

  Future statusEventApi(id, data) async {
    return await Api().postRequestBase('/api/v1/events/$id/accounts', data);
  }
  Future statusEventHostInviteApi(id, data) async {
    return await Api().postRequestBase('/api/v1/events/$id/invitation_hosts/invitations_respond', data);
  }

  Future sendInvitationFriendEventApi(id, data) async {
    return await Api().postRequestBase('/api/v1/events/$id/invitations', data);
  }
}
