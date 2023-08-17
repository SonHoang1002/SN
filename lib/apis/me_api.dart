import 'dart:convert';

import 'package:social_network_app_mobile/apis/api_root.dart';
import 'package:social_network_app_mobile/helper/common.dart';

class MeApi {
  fetchDataMeApi() async {
    final response = await Api().getRequestBase("/api/v1/me", null);
    return response;
  }
}
