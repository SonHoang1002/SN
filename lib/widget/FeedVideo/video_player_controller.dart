import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class VideoPlayerHasController extends StatefulWidget {
  final dynamic media;
  final double? aspectRatio;
  const VideoPlayerHasController({Key? key, this.media, this.aspectRatio})
      : super(key: key);

  @override
  State<VideoPlayerHasController> createState() =>
      _VideoPlayerHasControllerState();
}

class _VideoPlayerHasControllerState extends State<VideoPlayerHasController> {
  late BetterPlayerController betterPlayerController;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      BetterPlayerConfiguration betterPlayerConfiguration =
          BetterPlayerConfiguration(
              autoPlay: true,
              autoDispose: true,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                  enableFullscreen: true,
                  enableMute: true,
                  enablePlaybackSpeed: true,
                  enableProgressBar: true,
                  enableSubtitles: true,
                  enableQualities: true,
                  textColor: Colors.white,
                  iconsColor: Colors.white,
                  progressBarPlayedColor: secondaryColor,
                  progressBarBufferedColor: Colors.white.withOpacity(0.5),
                  progressBarBackgroundColor: Colors.grey,
                  playIcon: CupertinoIcons.play_arrow_solid,
                  pauseIcon: CupertinoIcons.pause_fill,
                  fullscreenEnableIcon: CupertinoIcons.fullscreen,
                  fullscreenDisableIcon: CupertinoIcons.fullscreen_exit,
                  controlBarColor: Colors.black.withOpacity(0.3),
                  unMuteIcon: CupertinoIcons.speaker_slash_fill,
                  muteIcon: CupertinoIcons.speaker_2_fill,
                  skipBackIcon: CupertinoIcons.gobackward_10,
                  skipForwardIcon: CupertinoIcons.goforward_10,
                  showControlsOnInitialize: false,
                  overflowModalColor: Colors.grey.shade900,
                  overflowModalTextColor: white,
                  overflowMenuIconsColor: white),
              translations: [
            BetterPlayerTranslations(
              overflowMenuPlaybackSpeed: 'Tốc độ phát',
              overflowMenuSubtitles: 'Phụ đề',
              overflowMenuQuality: 'Chất lượng',
              overflowMenuAudioTracks: 'Âm thanh',
            )
          ]);
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.media['remote_url'] ?? widget.media['url'],
        useAsmsSubtitles: true,
      );
      betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);

      betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized &&
            mounted) {
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
    betterPlayerController.setOverriddenAspectRatio(aspectRatio);
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
