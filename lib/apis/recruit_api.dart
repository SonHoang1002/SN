import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

final recruitApiProvider = Provider((ref) {
  return RecruitApi();
});

class RecruitApi {
  Future getListRecruitApi(params) async {
    return await Api().getRequestBase('/api/v1/recruits', params);
  }
  Future getDetailRecruitApi(id) async {
    return await Api().getRequestBase('/api/v1/recruits/$id', {});
  }
}
