import 'package:social_network_app_mobile/apis/api_root.dart';

class ProvincesApi {
  Future getProvinces(dynamic params) async {
    return await Api().getRequestBase('/api/v1/provinces', params);
  }
}
