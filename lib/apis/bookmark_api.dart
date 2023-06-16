import 'package:social_network_app_mobile/apis/api_root.dart';

class BookmarkApi {
  Future<List> fetchBookmarkCollection() async {
    return await Api().getRequestBase('/api/v1/bookmark_collections', null);
  }

  Future<List> fetchAllBookmark() async {
    return await Api().getRequestBase('/api/v1/bookmarks', null);
  }

  Future<List> getBookmarkOfOneCollection(id, params) async {
    return await Api().getRequestBase(
      '/api/v1/bookmarks?bookmark_collection_id=$id',
      params,
    );
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

  Future<dynamic> deleteBookmarkCollection(collectionId) async {
    return await Api()
        .deleteRequestBase('/api/v1/bookmark_collections/$collectionId', null);
  }

  Future<dynamic> renameCollection(collectionId, String newName) async {
    return await Api().patchRequestBase(
      '/api/v1/bookmark_collections/$collectionId',
      {"name": newName},
    );
  }
}
