import 'package:social_network_app_mobile/apis/api_root.dart';

class PageApi {
  fetchListPageAdmin(params) async {
    return await Api().getRequestBase("/api/v1/pages", params);
  }
}
