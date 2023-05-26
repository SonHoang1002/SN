import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerHasController extends ConsumerStatefulWidget {
  final dynamic media;
  final Widget? overlayWidget;
  final double? aspectRatio;
  final ValueNotifier<int>? videoPositionNotifier;
  const VideoPlayerHasController(
      {Key? key,
      this.media,
      this.overlayWidget,
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
  late BetterPlayerControllerNotifier betterPlayerControllerNotifier;

  @override
  void initState() {
    super.initState();
    betterPlayerControllerNotifier =
        ref.read(betterPlayerControllerProvider.notifier);
    if (mounted) {
      BetterState betterState = ref
          .read(betterPlayerControllerProvider)
          .firstWhere((element) => element.videoId == widget.media['id'],
              orElse: () => const BetterState(
                  videoId: '',
                  videoPlayerController: null,
                  chewieController: null));

      if (betterState.videoId != '') return;
      Future.delayed(Duration.zero, () {
        betterPlayerControllerNotifier.initializeBetterPlayerController(
            widget.media['id'],
            widget.media['remote_url'] ?? widget.media['url'],
            widget.overlayWidget);
      });
    }
  }

  @override
  void dispose() {
    // if (!isVisible) {
    //   betterPlayerControllerNotifier
    //       .disposeBetterPlayerController(widget.media['id']);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BetterState betterState = ref
        .watch(betterPlayerControllerProvider)
        .firstWhere((element) => element.videoId == widget.media['id'],
            orElse: () => const BetterState(
                videoId: '',
                videoPlayerController: null,
                chewieController: null));

    return betterState.videoPlayerController != null &&
            betterState.videoPlayerController!.value.isInitialized &&
            betterState.chewieController != null
        ? VisibilityDetector(
            onVisibilityChanged: (visibilityInfo) {
              if (mounted) {
                setState(() {
                  isVisible = visibilityInfo.visibleFraction == 1;

                  if (isVisible) {
                    betterState.videoPlayerController!.play();
                  } else {
                    betterState.videoPlayerController!.pause();
                  }
                });
              }
            },
            key: Key(widget.media['id']),
            child: AspectRatio(
                aspectRatio:
                    betterState.videoPlayerController!.value.aspectRatio,
                child: Material(
                    child: Chewie(controller: betterState.chewieController!))))
        : Container();
  }
}
