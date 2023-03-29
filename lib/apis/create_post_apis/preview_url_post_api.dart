import 'package:social_network_app_mobile/apis/api_root.dart';

class PreviewUrlPostApi {
  Future getPreviewUrlPost(dynamic url) async {
    return await Api().getRequestBase(
        "/api/v1/fetch-url/grab?urls[]=$url", null);
  }
}
