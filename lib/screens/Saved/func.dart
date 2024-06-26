import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../constant/common.dart';

String mediaType = 'image';

Widget handleMedia(bookmark) {
  mediaType = 'image';
  String imageUrl = '';
  if (bookmark['status'] != null &&
      bookmark['status']['media_attachments'].isNotEmpty) {
    var media = bookmark['status']['media_attachments'][0];
    if (media['url'].contains('.mp4') || media['url'].contains('.mov')) {
      mediaType = 'video';
      return Image.network(
        media['preview_remote_url'] ?? media['preview_url'] ?? media['url'],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          mediaType = 'image';
          return ExtendedImage.network(
            linkAvatarDefault,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      imageUrl =
          media['preview_remote_url'] ?? media['preview_url'] ?? media['url'];
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: ((context, error, stackTrace) {
          imageUrl = bookmark['status']['account']['banner'] != null
              ? bookmark['status']['account']['banner']['preview_url']
              : linkBannerDefault;
          return ExtendedImage.network(
            imageUrl,
            fit: BoxFit.cover,
          );
        }),
      );
    }
  } else if (bookmark['page'] != null) {
    var pageMedia = bookmark['page']['avatar_media'];
    imageUrl =
        pageMedia['preview_url'] ?? pageMedia['show_url'] ?? pageMedia['url'];
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: ((context, error, stackTrace) {
        imageUrl = bookmark['page']['avatar_media'] != null
            ? bookmark['page']['avatar_media']['preview_url']
            : linkBannerDefault;
        return ExtendedImage.network(
          imageUrl,
          fit: BoxFit.cover,
        );
      }),
    );
  } else {
    try {
      if (bookmark['status'] != null && bookmark['status']['card'] != null) {
        imageUrl = bookmark['status']['card']['image'] ??
            bookmark['status']['card']['url'];
      } else if (bookmark['status']['reblog'] != null &&
          bookmark['status']['reblog']['card'] != null) {
        imageUrl = bookmark['status']['reblog']['card']['image'] ??
            bookmark['status']['reblog']['card']['url'];
      } else if (bookmark['status']['account']['avatar_media'] != null) {
        imageUrl = bookmark['status']['account']['avatar_media']['url'];
      } else {
        imageUrl = linkBannerDefault;
      }
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: ((context, error, stackTrace) {
          imageUrl = bookmark['status']['account']['banner'] != null
              ? bookmark['status']['account']['banner'].preview_url
              : linkBannerDefault;
          return ExtendedImage.network(
            imageUrl,
            fit: BoxFit.cover,
          );
        }),
      );
    } catch (e) {
      return ExtendedImage.network(
        linkBannerDefault,
        fit: BoxFit.cover,
      );
    }
  }
}

dynamic convertItem(bookmark) {
  String type = bookmark['status'] == null ? 'page' : 'status';
  if (type == 'status') {
    return {
      "type": 'status',
      "id": bookmark['id'] ?? "empty",
      "bookmark_id":
          bookmark['status'] != null ? bookmark['status']['id'] : "empty",
      "mediaWidget": handleMedia(bookmark),
      "mediaType": mediaType,
      "content":
          bookmark['status'] != null ? bookmark['status']['content'] : "empty",
      "author": bookmark['status']['account'] != null
          ? bookmark['status']['account']['display_name']
          : "empty",
      "data": bookmark['status'] ?? "empty",
    };
  } else {
    return {
      "type": 'page',
      "id": bookmark['id'] ?? "empty",
      "bookmark_id":
          bookmark['page'] == null ? 'not_found' : bookmark['page']['id'],
      "mediaWidget": handleMedia(bookmark),
      "content": bookmark['page'] != null ? bookmark['page']['title'] : "empty",
      "author": "",
      "data": bookmark['page'] ?? "empty",
      "mediaType": mediaType,
    };
  }
}

double getRateListView(int length) {
  if (length == 1) {
    return 0.3;
  } else if (length == 2) {
    return 0.6;
  } else {
    return 1;
  }
}
