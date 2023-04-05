import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerHasController extends StatefulWidget {
  final dynamic media;
  const VideoPlayerHasController({Key? key, this.media}) : super(key: key);

  @override
  State<VideoPlayerHasController> createState() =>
      _VideoPlayerHasControllerState();
}

class _VideoPlayerHasControllerState extends State<VideoPlayerHasController> {
  late BetterPlayerController betterPlayerController;
  double aspectRatio = 1;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      BetterPlayerConfiguration betterPlayerConfiguration =
          BetterPlayerConfiguration(
              autoPlay: true, autoDispose: true, aspectRatio: aspectRatio);
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.media['remote_url'] ?? widget.media['url'],
        useAsmsSubtitles: true,
      );
      betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);

      betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          onVideoInitialized();
        }
      });

      betterPlayerController.setupDataSource(dataSource);
    }
  }

  void onVideoInitialized() {
    var videoPlayerController = betterPlayerController.videoPlayerController;
    Size? videoDimensions = videoPlayerController!.value.size;
    double aspectRatio = videoDimensions!.width / videoDimensions.height;
    setState(() {
      aspectRatio = aspectRatio;
    });
  }

  @override
  void dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: betterPlayerController);
  }
}
