import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:social_network_app_mobile/screen/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerHasController extends ConsumerStatefulWidget {
  final dynamic media;
  final Widget? overlayWidget;
  final double? aspectRatio;
  final bool? hasDispose;
  final String? type;
  final ValueNotifier<int>? videoPositionNotifier;
  final bool? isHiddenControl;
  const VideoPlayerHasController(
      {Key? key,
      this.media,
      this.type,
      this.overlayWidget,
      this.aspectRatio,
      this.hasDispose,
      this.isHiddenControl,
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
            widget.media['id'] ?? "1111",
            widget.media['remote_url'] ?? widget.media['url'],
            widget.overlayWidget);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BetterState betterState = ref
        .watch(betterPlayerControllerProvider)
        .firstWhere((element) => element.videoId == widget.media['id'],
            orElse: () => const BetterState(
                videoPlayerController: null, chewieController: null));

    return betterState.videoPlayerController != null &&
            betterState.chewieController != null
        ? VisibilityDetector(
            onVisibilityChanged: (visibilityInfo) {
              if (mounted) {
                final selectedVideo = ref.watch(selectedVideoProvider);

                setState(() {
                  isVisible = visibilityInfo.visibleFraction == 1;

                  if (isVisible) {
                    if (selectedVideo != null && widget.type == 'miniPlayer') {
                      betterState.videoPlayerController!.pause();
                    } else {
                      betterState.videoPlayerController!.play();
                    }
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
                    child:
                        betterState.videoPlayerController!.value.isInitialized
                            ? Chewie(controller: betterState.chewieController!)
                            : ImageCacheRender(
                                path: widget.media['preview_remote_url'] ??
                                    widget.media['preview_url']))))
        : Container();
  }
}
