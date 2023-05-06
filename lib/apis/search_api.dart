import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/apis/api_root.dart';

class SearchApi {
  Future getListSearchApi(params) async {
    return await Api().getRequestBase('/api/v2/search', params);
  }

  Future getListSearchHistoriesApi(params) async {
    return await Api().getRequestBase('/api/v1/search_histories', params);
  }
    Future deleteSearchHistoriesApi(id) async {
    return await Api().deleteRequestBase('/api/v1/search_histories/$id', null);
  }
}
