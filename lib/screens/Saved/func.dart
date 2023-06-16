import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/providers/saved/saved_menu_item_provider.dart';

import '../../constant/common.dart';

Widget handleImage(bookmark) {
  String imageUrl = '';
  if (bookmark['status'] != null &&
      bookmark['status']['media_attachments'].isNotEmpty) {
    var media = bookmark['status']['media_attachments'][0];
    if (media['url'].contains('.mp4') || media['url'].contains('.mov')) {
      // video, current: image mock data
      return ExtendedImage.network(
        defaultCollectionImage,
        fit: BoxFit.cover,
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
    if (bookmark['status']['card'] != null) {
      imageUrl = bookmark['status']['card']['image'] ??
          bookmark['status']['card']['url'];
    } else if (bookmark['status']['reblog'] != null &&
        bookmark['status']['reblog']['card'] != null) {
      imageUrl = bookmark['status']['reblog']['card']['image'] ??
          bookmark['status']['reblog']['card']['url'];
    } else {
      imageUrl = bookmark['status']['account']['avatar_media']['url'];
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
  }
}

dynamic convertItem(bookmark) {
  String type = bookmark['status'] == null ? 'page' : 'status';
  if (type == 'status') {
    return {
      "type": 'status',
      "id": bookmark['id'],
      "bookmark_id": bookmark['status']['id'],
      "imageWidget": handleImage(bookmark),
      "content": bookmark['status']['content'],
      "author": bookmark['status']['account']['display_name'],
    };
  } else {
    return {
      "type": 'page',
      "id": bookmark['id'],
      "bookmark_id":
          bookmark['page'] == null ? 'not_found' : bookmark['page']['id'],
      "imageWidget": handleImage(bookmark),
      "content": bookmark['page']['title'],
      "author": ""
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
