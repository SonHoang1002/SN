import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

final growApiProvider = Provider((ref) {
  return GrowApi();
});

class GrowApi {
  Future getListGrowApi(params) async {
    return await Api().getRequestBase('/api/v1/projects', params);
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

  Future getGrowTransactionsApi(params) async {
    return await Api().getRequestBase('/api/v1/transactions', {});
  }
}
