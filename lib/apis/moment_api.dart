import 'api_root.dart';

class MomentApi {
  Future getListMomentFollow(params) async {
    return await Api().getRequestBase('/api/v1/timelines/moment', params);
  }

  Future getListMomentSuggest(params) async {
    return await Api().getRequestBase('/api/v1/suggestions/moment', params);
  }
}
