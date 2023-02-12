import 'package:social_network_app_mobile/apis/api_root.dart';

class CommonApi {
  Future<dynamic> fetchDataEmojiApi() async {
    return await Api().getRequestBase(
        '/api/v1/status_activity?page=1&per_page=300&type=emoji&keyword=',
        null);
  }

  Future<dynamic> fetchDataActivityListApi(idParent) async {
    return await Api().getRequestBase(
        '/api/v1/status_activity/$idParent/list?page=1&per_page=200&keyword=',
        null);
  }

  Future fetchDataLocation(params) async {
    return await Api().getRequestBase('/api/v1/places', params);
  }
}
