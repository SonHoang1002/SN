import 'package:better_player/better_player.dart';
import 'package:better_player/src/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WatchDetail extends StatefulWidget {
  final dynamic media;
  const WatchDetail({Key? key, this.media}) : super(key: key);

  @override
  State<WatchDetail> createState() => _WatchDetailState();
}

class _WatchDetailState extends State<WatchDetail> {
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
    print('aspectRatio, $aspectRatio');
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
    String averageColor = widget.media['meta']['original']['average_color'];

    return Scaffold(
      body: Container(
        color: Color(int.parse('0xFF${averageColor.substring(1)}')),
        child: Center(
          child: BetterPlayer(controller: betterPlayerController),
        ),
      ),
    );
  }
}
