import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      BetterState betterState = ref
          .read(betterPlayerControllerProvider)
          .firstWhere((element) => element.videoId == widget.media['id'],
              orElse: () =>
                  const BetterState(videoId: '', betterPlayerController: null));
      if (betterState.videoId != '') return;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    BetterPlayerController? betterPlayerController = ref
        .watch(betterPlayerControllerProvider)
        .firstWhere((element) => element.videoId == widget.media['id'],
            orElse: () =>
                const BetterState(videoId: '', betterPlayerController: null))
        .betterPlayerController;

    return betterPlayerController != null
        ? VisibilityDetector(
            onVisibilityChanged: (visibilityInfo) {
              if (mounted) {
                setState(() {
                  isVisible = visibilityInfo.visibleFraction == 1;

                  if (isVisible) {
                    betterPlayerController.play();
                  } else {
                    betterPlayerController.pause();
                  }
                });
              }
            },
            key: Key(widget.media['id']),
            child: BetterPlayer(controller: betterPlayerController))
        : Container();
  }
}
