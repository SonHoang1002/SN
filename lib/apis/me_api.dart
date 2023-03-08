import 'package:social_network_app_mobile/apis/api_root.dart';

class MeApi {
  fetchDataMeApi() async {
    return await Api().getRequestBase("/api/v1/me", null);
  }
}
