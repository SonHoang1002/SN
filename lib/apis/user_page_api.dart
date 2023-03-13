import 'api_root.dart';

class UserPageApi {
  Future getListPostApi(accountId, params) async {
    return await Api()
        .getRequestBase('/api/v1/accounts/$accountId/statuses', params);
  }

  Future getAccountInfor(idUser) async {
    return await Api().getRequestBase('/api/v1/accounts/$idUser', null);
  }

  Future getAccountAboutInformation(idUser) async {
    return await Api().getRequestBase('/api/v1/accounts/$idUser/abouts', null);
  }

  Future updateOtherInformation(idUser, data) async {
    return Api().postRequestBase('/api/v1/account_general_infomation', data);
  }

  Future updateCredentialUser(data) async {
    return Api().postRequestBase('/api/v1/accounts/update_credentials', data);
  }

  Future getUserMedia(idUser, params) async {
    return Api()
        .getRequestBase('/api/v1/accounts/$idUser/media_attachments', params);
  }

  Future getUserAlbum(idUser, params) async {
    return Api().getRequestBase('/api/v1/accounts/$idUser/albums', params);
  }

  Future getUserMediaAlbum(idAlbum, params) async {
    return Api()
        .getRequestBase('/api/v1/albums/$idAlbum/media_attachments', params);
  }

  Future getUserFriend(idUser, params) async {
    return Api().getRequestBase('/api/v1/accounts/$idUser/friendships', params);
  }

  Future getUserFeatureContent(idUser) async {
    return Api()
        .getRequestBase('/api/v1/accounts/$idUser/featured_contents', null);
  }

  Future getUserFeatureContentMedia(idUser, idEntity) async {
    return Api().getRequestBase(
        '/api/v1/accounts/$idUser/featured_contents/$idEntity/media_attachments',
        null);
  }
}
