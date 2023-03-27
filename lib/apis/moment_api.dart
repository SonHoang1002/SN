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

  Future favoriteReactionMoment(id) async {
    return await Api().postRequestBase('/api/v1/statuses/$id/favourite', null);
  }

  Future unfavoriteReactionMoment(id) async {
    return await Api()
        .postRequestBase('/api/v1/statuses/$id/unfavourite', null);
  }
}
