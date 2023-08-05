
import 'package:social_network_app_mobile/apis/api_root.dart';

class CampaineProductApi {
  Future getCampaineProductApi() async {
    return await Api().getRequestBase("/api/v1/campaigns", null);
  }
}
