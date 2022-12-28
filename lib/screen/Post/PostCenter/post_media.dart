import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_player.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

    return renderLayoutMedia(medias);
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  renderLayoutMedia(medias) {
    if (medias.length == 1) {
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
              image:
                  medias[0]['preview_remote_url'] ?? medias[0]['preview_url']),
        );
      }
    } else {
      return const SizedBox();
    }
  }
}

class FeedVideo extends StatelessWidget {
  final String path;
  final dynamic flickMultiManager;
  final String image;
  final String? type;

  const FeedVideo({
    super.key,
    required this.path,
    this.flickMultiManager,
    required this.image,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction < 0.3) {
          flickMultiManager.pause();
        }
      },
      child: FlickMultiPlayer(
          url: path,
          flickMultiManager: flickMultiManager,
          image: image,
          type: type),
    );
  }
}
