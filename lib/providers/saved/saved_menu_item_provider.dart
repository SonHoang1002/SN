import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/screens/Saved/func.dart';

class SavedMenuItemState {
  final List bookmarks;
  final List bmCollections;

  const SavedMenuItemState({
    this.bookmarks = const [],
    this.bmCollections = const [],
  });

  SavedMenuItemState copyWith({
    bookmarks = const [],
    bmCollections = const [],
  }) {
    return SavedMenuItemState(
      bookmarks: bookmarks,
      bmCollections: bmCollections,
    );
  }
}

final savedControllerProvider =
    StateNotifierProvider<SavedController, SavedMenuItemState>(
  (ref) => SavedController(),
);

const String defaultCollectionImage =
    "https://snapi.emso.asia/system/media_attachments/files/108/927/296/811/310/650/small/6d639898340c58e6.jpg";

class SavedController extends StateNotifier<SavedMenuItemState> {
  SavedController() : super(const SavedMenuItemState());

  initBookmark() async {
    // get all bookmark of users
    var bmResult = await BookmarkApi().fetchAllBookmark();

    // get all collection of users
    var cltResult = await BookmarkApi().fetchBookmarkCollection();

    var renderCollections = [];

    for (var i = 0; i < cltResult.length; i++) {
      var collection = cltResult[i];
      var bookmarks = bmResult
          .where((e) =>
              e['bookmark_collection'] != null &&
              e['bookmark_collection']['id'] == collection['id'])
          .toList();

      if (bookmarks.isNotEmpty) {
        var earliest =
            DateTime.parse(bookmarks[0]['created_at']).millisecondsSinceEpoch;
        var index = 0;
        for (var j = 0; j < bookmarks.length; j++) {
          int createAt =
              DateTime.parse(bookmarks[j]['created_at']).millisecondsSinceEpoch;
          if (createAt <= earliest) {
            earliest = createAt;
            index = j;
          }
        }
        collection['imageUrl'] = getBookmarkImageUrl(bmResult[index]);
      } else {
        // collections has no bookmark -> default Image;
        collection['imageUrl'] = defaultCollectionImage;
      }

      renderCollections.add(collection);
    }
    if (mounted) {
      state = state.copyWith(
        bmCollections: renderCollections,
        bookmarks: bmResult,
      );
    }
  }

  updateAfterUnBookmard(bookmarkId) async {
    state = state.copyWith(
      bmCollections: state.bmCollections,
      bookmarks: state.bookmarks
          .where((element) => element['id'] != bookmarkId)
          .toList(),
    );
  }

  updateAfterAddingNewCollection(String collectionName, id) async {
    state = state.copyWith(
      bookmarks: state.bookmarks,
      bmCollections: [
        {
          "imageUrl": defaultCollectionImage,
          "name": collectionName,
          "id": id,
        },
        ...state.bmCollections
      ],
    );
  }
}
