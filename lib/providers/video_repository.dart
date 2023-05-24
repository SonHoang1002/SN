// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

@immutable
class BetterState {
  final BetterPlayerController? betterPlayerController;
  final String videoId;

  const BetterState({this.betterPlayerController, this.videoId = ''});

  BetterState copyWith({
    BetterPlayerController? betterPlayerController,
    String? videoId,
  }) {
    return BetterState(
      betterPlayerController: betterPlayerController!,
      videoId: videoId!,
    );
  }
}

class BetterPlayerControllerNotifier extends StateNotifier<List<BetterState>> {
  BetterPlayerControllerNotifier() : super(const []);

  void initializeBetterPlayerController(
      String videoId, BetterPlayerDataSource dataSource, isHiddenControl) {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            autoPlay: false,
            autoDispose: false,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                showControls: isHiddenControl,
                playerTheme: BetterPlayerTheme.material,
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
                overflowMenuIcon: CupertinoIcons.ellipsis_vertical,
                overflowMenuIconsColor: white),
            translations: [
          BetterPlayerTranslations(
            overflowMenuPlaybackSpeed: 'Tốc độ phát',
            overflowMenuSubtitles: 'Phụ đề',
            overflowMenuQuality: 'Chất lượng',
            overflowMenuAudioTracks: 'Âm thanh',
          )
        ]);
    BetterPlayerController betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );

    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized &&
          mounted) {
        onVideoInitialized(betterPlayerController);
      }
    });

    state = state +
        [
          BetterState(
              videoId: videoId, betterPlayerController: betterPlayerController)
        ];
  }
}

void onVideoInitialized(BetterPlayerController betterPlayerController) async {
  var videoPlayerController = betterPlayerController.videoPlayerController;
  Size? videoDimensions = videoPlayerController!.value.size;
  double aspectRatio = videoDimensions!.width / videoDimensions.height;
  betterPlayerController.setOverriddenAspectRatio(aspectRatio);
  await betterPlayerController.play();
}

final betterPlayerControllerProvider = StateNotifierProvider.autoDispose<
    BetterPlayerControllerNotifier,
    List<BetterState>>((ref) => BetterPlayerControllerNotifier());
