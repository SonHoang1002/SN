import 'api_root.dart';

class MomentApi {
  Future getListMomentFollow(params) async {
    return await Api().getRequestBase('/api/v1/timelines/moment', params);
  }

  Future getListMomentSuggest(params) async { 
    return await Api().getRequestBase('/api/v1/suggestions/moment', params);
  }

  Future getListMomentHashtag(hashtag, params) async {
    return await Api().getRequestBase('/api/v1/timelines/tag/$hashtag', params);
  }

  Future favoriteReactionMoment(id,data) async {
    return await Api().postRequestBase('/api/v1/statuses/$id/favourite', data);
  }

  Future unfavoriteReactionMoment(id) async {
    return await Api()
        .postRequestBase('/api/v1/statuses/$id/unfavourite', null);
  }

  Future followMomentUser(id) async {
    return await Api().postRequestBase("/api/v1/accounts/$id/follow", null);
  }

  Future followMomentPage(id) async {
    return await Api().postRequestBase("/api/v1/pages/$id/likes", null);
  }

  Future followMomentGroup(id) async {
    return await Api().postRequestBase("/api/v1/groups/$id/accounts", null);
  }
}
