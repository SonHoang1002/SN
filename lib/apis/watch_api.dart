import 'api_root.dart';

class WatchApi {
  Future getListWatchSuggest(params) async {
    return await Api().getRequestBase('/api/v1/suggestions/watch', params);
  }

  Future getListWatchFollow(params) async {
    return await Api().getRequestBase('/api/v1/timelines/watch', params);
  }
}
