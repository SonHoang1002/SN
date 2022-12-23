import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_player.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';
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
    List medias = widget.post['media_attachments'];

    return renderLayoutMedia(medias);
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  renderLayoutMedia(medias) {
    if (medias.length == 1) {
      if (checkIsImage(medias[0])) {
        return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage, image: medias[0]['url']);
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: FeedVideo(
              path:
                  'https://pt2.emso.vn/static/streaming-playlists/hls/424e4bc7-95b5-4fe0-b287-eaeff468caf3/659dc9e8-f9a3-4d76-a635-5da5cff560ae-master.m3u8',
              flickMultiManager: flickMultiManager,
              image:
                  'https://pt2.emso.vn/lazy-static/previews/a2aa536d-b8c9-4a71-a12e-ed1c91bc6224.jpg'),
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
  const FeedVideo({
    super.key,
    required this.path,
    this.flickMultiManager,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0) {
          flickMultiManager.pause();
        }
      },
      child: FlickMultiPlayer(
        url: path,
        flickMultiManager: flickMultiManager,
        image: image,
      ),
    );
  }
}
