import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

final recruitApiProvider = Provider((ref) {
  return RecruitApi();
});

class RecruitApi {
  Future getListRecruitApi(params) async {
    return await Api().getRequestBase('/api/v1/recruits', params);
  }

  Future getListRecruitInviteApi(params) async {
    return await Api().getRequestBase('/api/v1/recruit_invitations', params);
  }

  Future getListRecruitCVApi(id) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$id/account_resumes', null);
  }

  Future getDetailRecruitApi(id) async {
    return await Api().getRequestBase('/api/v1/recruits/$id', {});
  }

  Future recruitUpdateStatusApi(id) async {
    return await Api()
        .postRequestBase('/api/v1/recruits/$id/recruit_followers', null);
  }

  Future recruitDeleteStatusApi(id) async {
    return await Api()
        .deleteRequestBase('/api/v1/recruits/$id/recruit_followers', null);
  }
}
