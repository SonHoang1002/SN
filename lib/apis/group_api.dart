import 'package:social_network_app_mobile/apis/api_root.dart';

class GroupApi {
  fetchListGroupAdminMember(params) async {
    return await Api().getRequestBase('/api/v1/groups', params);
  }
}
