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
    final size = MediaQuery.of(context).size;
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
      case 3:
        if (getAspectMedia(medias[0]) > 1) {
          return Expanded(
            child: Column(
              children: [
                GirdviewBuilderMedia(
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio:
                        double.parse(getAspectMedia(medias[0]).toString()),
                    medias: medias.sublist(0, 1)),
                const SizedBox(
                  height: 2,
                ),
                GirdviewBuilderMedia(
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 2,
                    aspectRatio: 1,
                    medias: medias.sublist(1, 3)),
              ],
            ),
          );
        } else {
          return Expanded(
              child: Row(
            children: [
              SizedBox(
                width: size.width * 0.6 - 1,
                child: GirdviewBuilderMedia(
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: 0.749,
                    medias: medias.sublist(0, 1)),
              ),
              const SizedBox(
                width: 1,
              ),
              SizedBox(
                width: size.width * 0.4,
                child: GirdviewBuilderMedia(
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: double.parse(
                        getAspectMedia(medias.sublist(1, 3)[0]).toString()),
                    medias: medias.sublist(1, 3)),
              )
            ],
          ));
        }

      default:
        return const SizedBox();
    }
  }
}
