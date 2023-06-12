import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class BetterPlayerControllerNotifier extends StateNotifier<BetterState> {
  BetterPlayerControllerNotifier()
      : super(const BetterState(
            chewieController: null, videoPlayerController: null, videoId: ''));

  void initializeBetterPlayerController(
      String videoId,
      VideoPlayerController videoPlayerController,
      ChewieController chewieController) {
    state = BetterState(
        videoId: videoId,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController);
  }
}

final betterPlayerControllerProvider =
    StateNotifierProvider<BetterPlayerControllerNotifier, BetterState>(
        (ref) => BetterPlayerControllerNotifier());
