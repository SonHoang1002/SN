import 'api_root.dart';

class UserPageApi {
  Future getListPostApi(accountId, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$accountId/statuses', params);
  }
}
