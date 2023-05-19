import 'package:social_network_app_mobile/apis/api_root.dart';

class SearchApi {
  Future getListSearchApi(params) async {
    return await Api().getRequestBase('/api/v2/search', params);
  }

  Future getListSearchHistoriesApi(params) async {
    return await Api().getRequestBase('/api/v1/search_histories', params);
  }

  Future postSearchHistoriesApi(data) async {
    return await Api().postRequestBase('/api/v1/search_histories', data);
  }

  Future deleteSearchHistoriesApi(id) async {
    return await Api().deleteRequestBase('/api/v1/search_histories/$id', null);
  }
}
