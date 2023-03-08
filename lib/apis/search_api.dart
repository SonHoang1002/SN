import 'package:social_network_app_mobile/apis/api_root.dart';

class SearchApi {
  Future getListSearchApi(params) async {
    return await Api().getRequestBase('/api/v2/search', params);
  }
}
