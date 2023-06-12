import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:social_network_app_mobile/widgets/FeedVideo/flick_multiple_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

import 'portrait_controls.dart';

class FlickMultiPlayer extends StatefulWidget {
  const FlickMultiPlayer(
      {Key? key,
      required this.url,
      this.image,
      required this.flickMultiManager,
      this.type})
      : super(key: key);

  final String url;
  final String? image;
  final FlickMultiManager flickMultiManager;
  final String? type;

  @override
  // ignore: library_private_types_in_public_api
  _FlickMultiPlayerState createState() => _FlickMultiPlayerState();
}

class _FlickMultiPlayerState extends State<FlickMultiPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url)
        ..setLooping(true),
      autoPlay: false,
    );
    widget.flickMultiManager.init(flickManager);

    super.initState();
  }

  @override
  void dispose() {
    widget.flickMultiManager.remove(flickManager);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visiblityInfo) {
        if (visiblityInfo.visibleFraction > 0.5) {
          widget.flickMultiManager.play(flickManager);
        }
      },
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          videoFit: BoxFit.contain,
          playerLoadingFallback: Positioned.fill(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.network(
                    widget.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                ),
                const Positioned(
                  right: 10,
                  top: 10,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ],
            ),
          ),
          controls: FeedPlayerPortraitControls(
            type: widget.type,
            flickMultiManager: widget.flickMultiManager,
            flickManager: flickManager,
          ),
        ),
        flickVideoWithControlsFullscreen: FlickVideoWithControls(
          playerLoadingFallback: Center(
              child: Image.network(
            widget.image!,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          )),
          controls: const FlickLandscapeControls(),
          iconThemeData: const IconThemeData(
            size: 40,
            color: Colors.white,
          ),
          textStyle: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
