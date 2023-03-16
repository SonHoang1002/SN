import 'package:social_network_app_mobile/apis/api_root.dart';

class FriendsApi {
  Future getListFriendApi(idUser, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$idUser/friendships', params);
  }
  Future getListFriendsApi(params) async {
    return await Api()
        .getRequestBase('/api/v1/friendships', params);
  }
}
