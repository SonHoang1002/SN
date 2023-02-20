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
}
