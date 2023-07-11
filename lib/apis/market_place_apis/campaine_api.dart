import 'dart:convert';

import 'package:market_place/apis/api_root.dart';

class CampaineProductApi {
  Future getCampaineProductApi() async {
    return await Api().getRequestBase("/api/v1/campaigns", null);
  }
}
