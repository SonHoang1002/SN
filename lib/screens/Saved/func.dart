dynamic getBookmarkImageUrl(bookmark) {
  String type = bookmark['status'] == null ? 'page' : 'status';
  dynamic imageUrl;
  if (type == 'status') {
    if (bookmark[type]['card'] != null) {
      imageUrl = bookmark[type]['card']['image'];
    } else if (bookmark[type]['account']['avatar_media'] != null) {
      imageUrl = bookmark[type]['account']['avatar_media']['url'];
    } else {
      imageUrl = bookmark[type]['account']['avatar_static'];
    }
  } else {
    if (bookmark[type]['avatar_media'] != null) {
      imageUrl = bookmark[type]['avatar_media']['url'];
    } else {
      imageUrl = bookmark[type]['avatar_media']['show_url'];
    }
  }
  return imageUrl;
}

dynamic convertItem(bookmark) {
  String type = bookmark['status'] == null ? 'page' : 'status';
  if (type == 'status') {
    return {
      "type": 'status',
      "id": bookmark['id'],
      "bookmark_id": bookmark['status']['id'],
      "imageUrl": getBookmarkImageUrl(bookmark),
      "content": bookmark['status']['content'],
      "author": bookmark['status']['account']['display_name'],
    };
  } else {
    return {
      "type": 'page',
      "id": bookmark['id'],
      "bookmark_id": bookmark['page']['id'],
      "imageUrl": getBookmarkImageUrl(bookmark),
      "content": bookmark['page']['title'],
      "author": ""
    };
  }
}
