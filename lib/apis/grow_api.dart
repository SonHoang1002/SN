import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

final growApiProvider = Provider((ref) {
  return GrowApi();
});

class GrowApi {
  Future getListGrowApi(params) async {
    return await Api().getRequestBase('/api/v1/projects', params);
  }

  Future getListGrowInviteApi(params) async {
    return await Api().getRequestBase('/api/v1/project_invitations', params);
  }

  Future getListGrowInviteHostApi(params) async {
    return await Api()
        .getRequestBase('/api/v1/project_invitation_hosts', params);
  }

  Future statusInviteHost(params, id) async {
    return await Api().postRequestBase(
        '/api/v1/projects/$id/invitation_hosts/invitations_respond', params);
  }

  Future getDetailGrowApi(id) async {
    return await Api().getRequestBase('/api/v1/projects/$id', {});
  }

  Future statusGrowApi(id) async {
    return await Api()
        .postRequestBase('/api/v1/projects/$id/project_followers', {});
  }

  Future deleteStatusGrowApi(id) async {
    return await Api()
        .deleteRequestBase('/api/v1/projects/$id/project_followers', {});
  }

  Future getGrowHostApi(id) async {
    return await Api().getRequestBase('/api/v1/projects/$id/hosts', {});
  }

  Future getGrowPostApi(id, params) async {
    return await Api().getRequestBase('/api/v1/timelines/project/$id', params);
  }

  Future getGrowTransactionsApi(params) async {
    return await Api().getRequestBase('/api/v1/transactions', {});
  }

  Future transactionDonateApi(id, data) async {
    return await Api()
        .postRequestBase('/api/v1/projects/$id/transaction', data);
  }
}
