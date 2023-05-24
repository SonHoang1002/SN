import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:video_player/video_player.dart';

@immutable
class BetterState {
  final VideoPlayerController? videoPlayerController;
  final ChewieController? chewieController;
  final String videoId;

  const BetterState(
      {required this.videoPlayerController,
      required this.chewieController,
      this.videoId = ''});

  BetterState copyWith({
    VideoPlayerController? betterPlayerController,
    ChewieController? chewieController,
    String? videoId,
  }) {
    return BetterState(
      videoPlayerController: videoPlayerController,
      chewieController: chewieController,
      videoId: videoId!,
    );
  }
}

class BetterPlayerControllerNotifier extends StateNotifier<List<BetterState>> {
  BetterPlayerControllerNotifier() : super(const []);

  void initializeBetterPlayerController(String videoId, String path) {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.network(path);
    videoPlayerController.initialize().then((value) => state = state +
        [
          BetterState(
              videoId: videoId,
              videoPlayerController: videoPlayerController,
              chewieController: ChewieController(
                  showControlsOnInitialize: false,
                  videoPlayerController: videoPlayerController,
                  aspectRatio: videoPlayerController.value.aspectRatio))
        ]);
  }

  void disposeBetterPlayerController(String videoId) {
    state = state
        .map((betterState) {
          if (betterState.videoId == videoId) {
            betterState.videoPlayerController?.dispose();
            betterState.chewieController?.dispose();
          }
          return betterState;
        })
        .where((betterState) => betterState.videoId != videoId)
        .toList();
  }
}

final betterPlayerControllerProvider = StateNotifierProvider.autoDispose<
    BetterPlayerControllerNotifier,
    List<BetterState>>((ref) => BetterPlayerControllerNotifier());
