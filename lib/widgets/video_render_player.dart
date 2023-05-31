import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerRender extends StatefulWidget {
  final String path;
  final bool? autoPlay;
  const VideoPlayerRender({
    Key? key,
    required this.path,
    this.autoPlay,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerRenderState createState() => _VideoPlayerRenderState();
}

class _VideoPlayerRenderState extends State<VideoPlayerRender> {
  late FlickManager flickManager;
  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    try {
      flickManager = FlickManager(
        autoPlay: widget.autoPlay ?? false,
        videoPlayerController: VideoPlayerController.network(
          widget.path,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickManager: flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.fitHeight,
        controls: FlickPortraitControls(
          progressBarSettings:
              FlickProgressBarSettings(playedColor: Colors.green),
        ),
      ),
      // flickVideoWithControls: const FlickVideoWithControls(
      //   closedCaptionTextStyle: TextStyle(fontSize: 8),
      //   controls: FlickPortraitControls(),
      // ),
      // flickVideoWithControlsFullscreen: const FlickVideoWithControls(
      //   controls: FlickLandscapeControls(),
      // )
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
}
