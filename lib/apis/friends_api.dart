import 'package:social_network_app_mobile/apis/api_root.dart';

class FriendsApi {
  Future getListFriendApi(idUser, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$idUser/friendships', params);
  }

  Future getListFriendsApi(Map<String, dynamic>? params) async {
    return await Api().getRequestBase('/api/v1/friendships', params);
  }

  Future getListFriendRequestApi(params) async {
    return await Api().getRequestBase('/api/v1/friendship_requests', params);
  }

  Future sendFriendRequestApi(id) async {
    return await Api()
        .postRequestBase('/api/v1/accounts/$id/friendship_requests', null);
  }

  Future cancelFriendRequestApi(id) async {
    return await Api().postRequestBase(
        '/api/v1/accounts/$id/cancel_friendship_requests', null);
  }

  Future unfollow(id) async {
    return await Api().postRequestBase('/api/v1/accounts/$id/unfollow', null);
  }

  Future follow(id) async {
    return await Api().postRequestBase('/api/v1/accounts/$id/follow', null);
  }

  Future unfriend(id) async {
    return await Api().postRequestBase('/api/v1/accounts/$id/unfriend', null);
  }

  Future rejectFriendRequestApi(id) async {
    return await Api()
        .postRequestBase('/api/v1/accounts/$id/reject_friendship', null);
  }

  Future approveFriendRequestApi(id) async {
    return await Api()
        .postRequestBase('/api/v1/accounts/$id/approve_friendship', null);
  }

  Future getListFriendSuggestApi(params) async {
    return await Api().getRequestBase('/api/v1/friend_suggestions', params);
  }

  Future getListFriendInvitedApi(params) async {
    return await Api().getRequestBase('/api/v1/requested_friendships', params);
  }
}
