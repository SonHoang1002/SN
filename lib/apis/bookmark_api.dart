import 'package:social_network_app_mobile/apis/api_root.dart';

class BookmarkApi {
  Future<List> fetchBookmarkCollection() async {
    return await Api().getRequestBase('/api/v1/bookmark_collections', null);
  }

  Future<dynamic> bookmarkApi(data) async {
    return await Api().postRequestBase('/api/v1/bookmarks', data);
  }

  Future<dynamic> unBookmarkApi(data) async {
    return await Api().deleteRequestBase('/api/v1/bookmarks/1', data);
  }

  Future<dynamic> createBookmarkAlbum(data) async {
    return await Api().postRequestBase('/api/v1/bookmark_collections', data);
  }
}
