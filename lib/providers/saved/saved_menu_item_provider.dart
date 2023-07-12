import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/screens/Saved/func.dart';

import '../../constant/common.dart';

class SavedMenuItemState {
  final List bookmarks; // all bookmark from database
  final List bmCollections; // all collection
  final List currentCltBookmarks; // bookmarks of one collection

  const SavedMenuItemState({
    this.bookmarks = const [],
    this.bmCollections = const [],
    this.currentCltBookmarks = const [],
  });

  SavedMenuItemState copyWith({
    bookmarks = const [],
    bmCollections = const [],
    currentCltBookmarks = const [],
  }) {
    return SavedMenuItemState(
      bookmarks: bookmarks,
      bmCollections: bmCollections,
      currentCltBookmarks: currentCltBookmarks,
    );
  }
}

final savedControllerProvider =
    StateNotifierProvider<SavedController, SavedMenuItemState>(
  (ref) => SavedController(),
);

class SavedController extends StateNotifier<SavedMenuItemState> {
  SavedController() : super(const SavedMenuItemState());

  initBookmark() async {
    // get all bookmark of users
    var allBookmark = await BookmarkApi().fetchAllBookmark();

    // get all collection of users
    var allCollection = await BookmarkApi().fetchBookmarkCollection();

    var renderCollections = [];

    for (var i = 0; i < allCollection.length; i++) {
      final collection = allCollection[i];
      final bookmarkCollections = await BookmarkApi()
          .getBookmarkOfOneCollection(collection['id'], null);

      if (bookmarkCollections.isEmpty) {
        collection['mediaWidget'] = ExtendedImage.network(
          linkBannerDefault,
          fit: BoxFit.cover,
        );
      } else {
        collection['mediaWidget'] = handleMedia(bookmarkCollections.first);
      }
      renderCollections.add(collection);
    }
    if (mounted) {
      state = state.copyWith(
        bmCollections: renderCollections,
        bookmarks: allBookmark,
      );
    }
  }

  updateAfterUnBookmard(bookmarkId) async {
    state = state.copyWith(
      bmCollections: state.bmCollections,
      bookmarks: state.bookmarks
          .where((element) => element['id'] != bookmarkId)
          .toList(),
      currentCltBookmarks: state.currentCltBookmarks
          .where((element) => element['id'] != bookmarkId)
          .toList(),
    );
  }

  updateAfterAddingNewCollection(String collectionName, id) async {
    state = state.copyWith(
      bookmarks: state.bookmarks,
      bmCollections: [
        {
          "mediaWidget": ExtendedImage.network(
            linkBannerDefault,
            fit: BoxFit.cover,
          ),
          "name": collectionName,
          "id": id,
        },
        ...state.bmCollections
      ],
      currentCltBookmarks: state.currentCltBookmarks,
    );
  }

  fetchBookmarkOfOneCollection(dynamic collectionId) async {
    final bmResponse = await BookmarkApi().getBookmarkOfOneCollection(
      collectionId,
      null,
    );
    state = state.copyWith(
      bookmarks: state.bookmarks,
      bmCollections: state.bmCollections,
      currentCltBookmarks: bmResponse,
    );
  }

  fetchAllBookmark() async {
    // get all bookmark of users
    var bmResult = await BookmarkApi().fetchAllBookmark();
    state = state.copyWith(
      bookmarks: bmResult,
      bmCollections: state.bmCollections,
      currentCltBookmarks: state.currentCltBookmarks,
    );
  }

  deleteOneCollection(collectionId) async {
    var response = await BookmarkApi().deleteBookmarkCollection(collectionId);
    state = state.copyWith(
      bookmarks: state.bookmarks,
      bmCollections: state.bmCollections
          .where((element) => element['id'] != collectionId)
          .toList(),
      currentCltBookmarks: state.currentCltBookmarks,
    );
  }

  renameOneCollection(collectionId, String newName) async {
    var response = await BookmarkApi().renameCollection(collectionId, newName);
    var index = state.bmCollections.indexWhere(
      (element) => element['id'] == collectionId,
    );
    var newArray = state.bmCollections;
    newArray[index]['name'] = newName;

    state = state.copyWith(
      bookmarks: state.bookmarks,
      bmCollections: newArray,
      currentCltBookmarks: state.currentCltBookmarks,
    );
  }
}
