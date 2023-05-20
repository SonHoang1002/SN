import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class VideoPlayerHasController extends ConsumerStatefulWidget {
  final dynamic media;
  final double? aspectRatio;
  final ValueNotifier<int>? videoPositionNotifier;
  final bool? isHiddenControl;
  const VideoPlayerHasController(
      {Key? key,
      this.media,
      this.isHiddenControl,
      this.aspectRatio,
      this.videoPositionNotifier})
      : super(key: key);

  @override
  ConsumerState<VideoPlayerHasController> createState() =>
      _VideoPlayerHasControllerState();
}

class _VideoPlayerHasControllerState
    extends ConsumerState<VideoPlayerHasController> {
  // late BetterPlayerController betterPlayerController;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () {
        ref
            .read(betterPlayerControllerProvider.notifier)
            .initializeBetterPlayerController(
                widget.media['id'],
                BetterPlayerDataSource(
                  BetterPlayerDataSourceType.network,
                  widget.media['remote_url'] ?? widget.media['url'],
                ),
                widget.isHiddenControl ?? true);
      });
      //   BetterPlayerConfiguration betterPlayerConfiguration =
      //       BetterPlayerConfiguration(
      //           autoPlay: true,
      //           autoDispose: true,
      //           controlsConfiguration: BetterPlayerControlsConfiguration(
      //               showControls: widget.isHiddenControl ?? true,
      //               playerTheme: BetterPlayerTheme.material,
      //               enableFullscreen: true,
      //               enableMute: true,
      //               enablePlaybackSpeed: true,
      //               enableProgressBar: true,
      //               enableSubtitles: true,
      //               enableQualities: true,
      //               textColor: Colors.white,
      //               iconsColor: Colors.white,
      //               progressBarPlayedColor: secondaryColor,
      //               progressBarBufferedColor: Colors.white.withOpacity(0.5),
      //               progressBarBackgroundColor: Colors.grey,
      //               playIcon: CupertinoIcons.play_arrow_solid,
      //               pauseIcon: CupertinoIcons.pause_fill,
      //               fullscreenEnableIcon: CupertinoIcons.fullscreen,
      //               fullscreenDisableIcon: CupertinoIcons.fullscreen_exit,
      //               controlBarColor: Colors.black.withOpacity(0.3),
      //               unMuteIcon: CupertinoIcons.speaker_slash_fill,
      //               muteIcon: CupertinoIcons.speaker_2_fill,
      //               skipBackIcon: CupertinoIcons.gobackward_10,
      //               skipForwardIcon: CupertinoIcons.goforward_10,
      //               showControlsOnInitialize: false,
      //               overflowModalColor: Colors.grey.shade900,
      //               overflowModalTextColor: white,
      //               overflowMenuIcon: CupertinoIcons.ellipsis_vertical,
      //               overflowMenuIconsColor: white),
      //           translations: [
      //         BetterPlayerTranslations(
      //           overflowMenuPlaybackSpeed: 'Tốc độ phát',
      //           overflowMenuSubtitles: 'Phụ đề',
      //           overflowMenuQuality: 'Chất lượng',
      //           overflowMenuAudioTracks: 'Âm thanh',
      //         )
      //       ]);
      //   BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      //     BetterPlayerDataSourceType.network,
      //     widget.media['remote_url'] ?? widget.media['url'],
      //   );
      //   betterPlayerController =
      //       BetterPlayerController(betterPlayerConfiguration);

      //   betterPlayerController.addEventsListener((event) {
      //     if (event.betterPlayerEventType == BetterPlayerEventType.initialized &&
      //         mounted) {
      //       onVideoInitialized();
      //     }
      //   });

      //   betterPlayerController.setupDataSource(dataSource);
      // }
    }

    // void onVideoInitialized() async {
    //   var videoPlayerController = betterPlayerController.videoPlayerController;
    //   Size? videoDimensions = videoPlayerController!.value.size;
    //   double aspectRatio = videoDimensions!.width / videoDimensions.height;
    //   betterPlayerController.setOverriddenAspectRatio(aspectRatio);
    //   await betterPlayerController
    //       .seekTo(Duration(seconds: ref.read(watchControllerProvider).position));
    //   await betterPlayerController.play();

    //   betterPlayerController.addEventsListener((event) {
    //     if (betterPlayerController.videoPlayerController != null && mounted) {
    //       ref.read(watchControllerProvider.notifier).updatePositionPlaying(
    //           betterPlayerController
    //               .videoPlayerController!.value.position.inSeconds);
    //     }
    //   });
  }

  @override
  void dispose() {
    // betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BetterPlayerController betterPlayerController =
        ref.watch(betterPlayerControllerProvider).betterPlayerController!;
    return BetterPlayer(controller: betterPlayerController);
  }
}
