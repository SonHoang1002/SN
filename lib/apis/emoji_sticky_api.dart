import 'package:social_network_app_mobile/apis/api_root.dart';

class EmojiStickyApi {
  Future<dynamic> fetchDataGifApi(params) async {
    return await Api().getRequestBase('/api/v1/gifts', params);
  }

  Future fetchStickyApi(url) async {
    return await Api().getRequestBase('/api/v1/$url', null);
  }

  getInventoryApi() {
    return fetchStickyApi("stickers/inventory");
  }

  getTagsKeywordApi() {
    return fetchStickyApi("tags/keyword");
  }

  getTrendingApi() {
    return fetchStickyApi("stickers/trendings");
  }

  getEmoticonApi() {
    return fetchStickyApi("stickers/tag2stickers/emotion");
  }

  getCategoryApi() {
    return fetchStickyApi("stickers/categories");
  }

  getPackFreeApi() {
    return fetchStickyApi("stickers/packs");
  }

  getPackDetailApi(id) {
    return fetchStickyApi("stickers/packs/$id");
  }
}
