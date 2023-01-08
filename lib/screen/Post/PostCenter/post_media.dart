import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/girdview_builder_media.dart';
import 'package:transparent_image/transparent_image.dart';

class PostMedia extends StatefulWidget {
  final dynamic post;
  const PostMedia({Key? key, this.post}) : super(key: key);

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    List medias = widget.post['media_attachments'] ?? [];

    return medias.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: renderLayoutMedia(medias),
          )
        : const SizedBox();
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  getAspectMedia(media) {
    return checkIsImage(media)
        ? media['meta']['original']['aspect']
        : 1 / media['meta']['original']['aspect'];
  }

  renderLayoutMedia(medias) {
    switch (medias.length) {
      case 1:
        if (checkIsImage(medias[0])) {
          return ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor:
                  medias[0]['meta']['original']['aspect'] < 0.4 ? 0.6 : 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: medias[0]['url'],
                  imageErrorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FeedVideo(
                path: medias[0]['remote_url'] ?? medias[0]['url'],
                flickMultiManager: flickMultiManager,
                image: medias[0]['preview_remote_url'] ??
                    medias[0]['preview_url']),
          );
        }
      case 2:
        return GirdviewBuilderMedia(
            flickMultiManager: flickMultiManager,
            crossAxisCount: getAspectMedia(medias[0]) > 1 ? 1 : 2,
            aspectRatio: double.parse(getAspectMedia(medias[0]).toString()),
            medias: medias);
      default:
        return const SizedBox();
    }
  }
}
