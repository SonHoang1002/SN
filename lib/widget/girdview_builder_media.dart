import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:transparent_image/transparent_image.dart';

class GirdviewBuilderMedia extends StatelessWidget {
  final List medias;
  final double aspectRatio;
  final int crossAxisCount;
  final dynamic flickMultiManager;

  const GirdviewBuilderMedia(
      {Key? key,
      required this.aspectRatio,
      required this.medias,
      required this.crossAxisCount,
      this.flickMultiManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio),
        itemCount: medias.length,
        itemBuilder: (context, indexBg) => checkIsImage(medias[indexBg])
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: medias[indexBg]['url'],
                imageErrorBuilder: (context, error, stackTrace) =>
                    const SizedBox(),
              )
            : FeedVideo(
                path: medias[indexBg]['remote_url'] ?? medias[indexBg]['url'],
                flickMultiManager: flickMultiManager,
                image: medias[indexBg]['preview_remote_url'] ??
                    medias[indexBg]['preview_url']));
  }
}
