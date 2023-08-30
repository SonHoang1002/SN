import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/type_constant.dart';
import 'package:social_network_app_mobile/providers/disable_moment_provider.dart';
import 'package:social_network_app_mobile/providers/disable_watch_provider.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/custom_video_elements/video_custom_control.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerHasController extends ConsumerStatefulWidget {
  final dynamic media;
  final Widget? overlayWidget;
  final double? aspectRatio;
  final bool? hasDispose;
  final String? type;
  final ValueNotifier<int>? videoPositionNotifier;
  final bool? isHiddenControl;
  final double? timeStart;
  final Function? handleAction;
  final Function? onDoubleTapAction;
  final bool? isFocus;

  const VideoPlayerHasController(
      {Key? key,
      this.media,
      this.type,
      this.handleAction,
      this.overlayWidget,
      this.aspectRatio,
      this.hasDispose = false,
      this.isHiddenControl,
      this.timeStart,
      this.videoPositionNotifier,
      this.isFocus,
      this.onDoubleTapAction})
      : super(key: key);

  @override
  ConsumerState<VideoPlayerHasController> createState() =>
      _VideoPlayerHasControllerState();
}

class _VideoPlayerHasControllerState
    extends ConsumerState<VideoPlayerHasController>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  bool isVisible = false;
  BetterState? betterPlayer;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    betterPlayer = ref.read(betterPlayerControllerProvider);
    if (betterPlayer!.videoId == widget.media['id']) {
      videoPlayerController = betterPlayer!.videoPlayerController;
      chewieController = betterPlayer!.chewieController;
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.media['remote_url'] ?? widget.media['url']),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      )..initialize().then((value) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              setState(() {
                chewieController = ChewieController(
                    placeholder: Container(
                        decoration: BoxDecoration(
                      color: Color(int.parse(
                          '0xFF${(widget.media?['meta']?['small']?['average_color']).substring(1)}')),
                    )),
                    showControlsOnInitialize: false,
                    videoPlayerController: videoPlayerController!,
                    showControls: true,
                    customControls: CustomControlVideo(
                      backgroundColor: const Color.fromRGBO(41, 41, 41, 0.7),
                      iconColor: const Color.fromARGB(255, 200, 200, 200),
                      onDoubleTapAction: widget.onDoubleTapAction,
                    ),
                    aspectRatio: videoPlayerController!.value.aspectRatio,
                    progressIndicatorDelay: const Duration(seconds: 10));
              });
            }
          });
        });
    }
  }

  @override
  void dispose() {
    widget.hasDispose == true
        ? WidgetsBinding.instance.removeObserver(this)
        : null;

    if (betterPlayer!.videoPlayerController != null &&
        betterPlayer!.videoId != widget.media['id']) {
      chewieController!.pause();
      videoPlayerController?.dispose();
      chewieController?.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isHiddenControl != null && !widget.isHiddenControl!) {
      setState(() {
        chewieController = ChewieController(
            placeholder: Container(
                decoration: BoxDecoration(
              color: Color(int.parse(
                  '0xFF${(widget.media?['meta']?['small']?['average_color']).substring(1)}')),
            )),
            showControlsOnInitialize: true,
            videoPlayerController: videoPlayerController!,
            showControls: true,
            customControls: CustomControlVideo(
              backgroundColor: const Color.fromRGBO(41, 41, 41, 0.7),
              iconColor: const Color.fromARGB(255, 200, 200, 200),
              onDoubleTapAction: widget.onDoubleTapAction,
            ),
            aspectRatio: videoPlayerController!.value.aspectRatio,
            progressIndicatorDelay: const Duration(seconds: 10));
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (chewieController != null && chewieController!.isPlaying) {
        chewieController!.pause();
      }
    }
  }

  bool checkLicenseVideoWithType() {
    print("widget.type ${widget.type}");
    if (widget.type == watchHome &&
        ref.watch(disableVideoController).isDisableWatchHome == true) {
      return false;
    }
    if (widget.type == watchFollow &&
        ref.watch(disableVideoController).isDisableWatchFollow == true) {
      return false;
    }
    if (widget.type == watchLive &&
        ref.watch(disableVideoController).isDisableWatchLive == true) {
      return false;
    }
    if (widget.type == watchProgram &&
        ref.watch(disableVideoController).isDisableWatchProgram == true) {
      return false;
    }
    if (widget.type == watchSaved &&
        ref.watch(disableVideoController).isDisableWatchSaved == true) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final selectedVideo = ref.watch(selectedVideoProvider);
    // widget.isFocus == true
    //     ? chewieController?.videoPlayerController.setVolume(5)
    //     : chewieController?.videoPlayerController.setVolume(0);
    return AspectRatio(
      aspectRatio:
          //  videoPlayerController!.value.aspectRatio > 1
          //     ? 1
          //     :
          // widget.aspectRatio ??
          videoPlayerController!.value.aspectRatio,
      child: VisibilityDetector(
          onVisibilityChanged: (visibilityInfo) {
            if (mounted && checkLicenseVideoWithType()) {
              setState(() {
                isVisible = visibilityInfo.visibleFraction > 0.85;
                if (chewieController == null) return;
                if (isVisible) {
                  if (selectedVideo != null) {
                    chewieController!.videoPlayerController.pause();
                  } else {
                    if (isPlaying && widget.isFocus == true) {
                      chewieController!.videoPlayerController.play();
                    }
                  }
                } else {
                  chewieController!.videoPlayerController.pause();
                }
              });
            }
          },
          key: Key(widget.media['id']),
          child: Stack(
            children: [
              chewieController != null
                  ? AspectRatio(
                      aspectRatio:
                          // widget.aspectRatio ??
                          videoPlayerController!.value.aspectRatio,
                      child: chewieController!
                              .videoPlayerController.value.isInitialized
                          ? selectedVideo != null &&
                                  widget.type != 'miniPlayer' &&
                                  widget.media['id'] ==
                                      (selectedVideo?['media_attachments']?[0]
                                          ?['id'])
                              ? Stack(
                                  children: [
                                    ImageCacheRender(
                                        path: (widget.media?[
                                                'preview_remote_url']) ??
                                            (widget.media?['preview_url'])),
                                    Positioned.fill(
                                        child: Container(
                                      color: Colors.black.withOpacity(0.4),
                                      child: const Center(
                                        child: Text("Đang phát",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: white,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ))
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Material(
                                        child: Chewie(
                                            controller: chewieController!)),
                                    widget.handleAction != null
                                        ? Positioned.fill(
                                            child: GestureDetector(
                                            onTap: () {
                                              if (betterPlayer!.videoId !=
                                                  widget.media['id']) {
                                                ref
                                                    .read(
                                                        betterPlayerControllerProvider
                                                            .notifier)
                                                    .initializeBetterPlayerController(
                                                        widget.media['id'],
                                                        videoPlayerController!,
                                                        chewieController!);
                                              }
                                              if (widget.handleAction != null) {
                                                widget.handleAction!();
                                              }
                                            },
                                            onDoubleTap: () {
                                              if (betterPlayer!.videoId !=
                                                  widget.media['id']) {
                                                ref
                                                    .read(
                                                        betterPlayerControllerProvider
                                                            .notifier)
                                                    .initializeBetterPlayerController(
                                                        widget.media['id'],
                                                        videoPlayerController!,
                                                        chewieController!);
                                              }
                                              if (widget.onDoubleTapAction !=
                                                  null) {
                                                widget.onDoubleTapAction!();
                                              }
                                            },
                                          ))
                                        : const SizedBox()
                                  ],
                                )
                          : AspectRatio(
                              aspectRatio:
                                  // widget.aspectRatio ??
                                  videoPlayerController!.value.aspectRatio,
                              child: ImageCacheRender(
                                  path: widget.media['preview_remote_url'] ??
                                      widget.media['preview_url']),
                            ))
                  : AspectRatio(
                      // aspectRatio: videoPlayerController!.value.aspectRatio,
                      aspectRatio:
                          // widget.aspectRatio ??
                          videoPlayerController!.value.aspectRatio,
                      child: ImageCacheRender(
                          path: widget.media['preview_remote_url'] ??
                              widget.media['preview_url']),
                    ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
