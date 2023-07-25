import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoPlayerNoneController extends ConsumerStatefulWidget {
  final String path;
  final String type;
  final dynamic media;
  final dynamic post;
  final double? aspectRatio;
  final bool? isShowVolumn;
  final Duration? timeStart;
  final bool? isPause;
  final bool? isLooping;
  final int? index;
  final Function? onEnd;
  final bool removeObserver;
  const VideoPlayerNoneController(
      {Key? key,
      this.timeStart,
      required this.path,
      required this.type,
      this.media,
      this.aspectRatio,
      this.post,
      this.isShowVolumn,
      this.isPause = false,
      this.onEnd,
      this.index,
      this.isLooping = false,
      this.removeObserver = true})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerNoneControllerState createState() =>
      _VideoPlayerNoneControllerState();
}

class _VideoPlayerNoneControllerState
    extends ConsumerState<VideoPlayerNoneController>
    with WidgetsBindingObserver {
  late VideoPlayerController videoPlayerController;
  bool isVisible = false;
  bool _isMuted = false;
  bool isPlaying = true;
  bool _isLoading = true;
  Size? size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final selectedVideo = ref.read(selectedVideoProvider);
    BetterState betterStatePlayer = ref.read(betterPlayerControllerProvider);
    videoPlayerController = (widget.path.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(widget.path))
        : VideoPlayerController.file(io.File(widget.path)))
      ..initialize().then((value) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _isLoading = false;
          });
        });
        videoPlayerController.setLooping(widget.isLooping!);
        if (widget.timeStart != null) {
          videoPlayerController.seekTo(widget.timeStart!);
        }
        if (selectedVideo != null && widget.type == 'miniPlayer') {
          videoPlayerController.seekTo(Duration(
              seconds: betterStatePlayer
                      .videoPlayerController?.value.position.inSeconds ??
                  0));
        }
      })
      ..addListener(() {
        if (mounted) {
          ref.read(watchControllerProvider.notifier).updatePositionPlaying(
              videoPlayerController.value.position.inSeconds);
        }
      })
      ..addListener(_onEnd);
  }

  _onEnd() {
    if (widget.media != null &&
        widget.media['meta'] != null &&
        (widget.media['meta']['original']['duration'] - 1 ==
            videoPlayerController.value.position.inSeconds)) {
      widget.onEnd != null ? widget.onEnd!() : null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.sizeOf(context);
    if (widget.isPause == true) {
      videoPlayerController.pause();
    } else {
      if (isPlaying) {
        videoPlayerController.play();
      } else {
        videoPlayerController.pause();
      }
    }
    return AspectRatio(
      aspectRatio:
          widget.aspectRatio ?? videoPlayerController.value.aspectRatio,
      child: VisibilityDetector(
          onVisibilityChanged: (visibilityInfo) {
            if (mounted) {
              setState(() {
                isVisible = visibilityInfo.visibleFraction == 1;
                if (isVisible) {
                  videoPlayerController.play();
                  if (ref.read(watchControllerProvider).mediaSelected?['id'] ==
                      (widget.media?['id'] ?? 0)) {
                    videoPlayerController.seekTo(Duration(
                        seconds: ref.read(watchControllerProvider).position));
                  } else {
                    ref
                        .read(watchControllerProvider.notifier)
                        .updateMediaPlaying(widget.media);
                  }
                } else {
                  videoPlayerController.pause();
                }
              });
            }
          },
          key: Key(widget.media?['id'] ?? widget.path ?? '111'),
          child: Stack(
            children: [
              Hero(
                  tag: widget.path,
                  child: AspectRatio(
                      aspectRatio: widget.aspectRatio ??
                          videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController))),
              widget.isShowVolumn != null && widget.isShowVolumn == false
                  ? const SizedBox()
                  : Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMuted = !_isMuted;
                            if (widget.isPause == true) {
                              videoPlayerController.setVolume(0);
                            } else {
                              videoPlayerController.setVolume(_isMuted ? 0 : 1);
                            }
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              !_isMuted
                                  ? CupertinoIcons.speaker_2_fill
                                  : CupertinoIcons.speaker_slash_fill,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      )),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: isPlaying
                      ? const SizedBox(height: 40, width: 40)
                      : IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.play,
                            color: Colors.red,
                            size: 40,
                          ),
                          onPressed: () {
                            if (widget.isPause != true) {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            }
                          },
                        ),
                ),
              ),
              if (_isLoading)
                AspectRatio(
                    aspectRatio: widget.aspectRatio ??
                        videoPlayerController.value.aspectRatio,
                    child: Container(color: greyColor))
              // Container(
              //   height: double.parse((widget.media?['meta']?['small']
              //           ?['height'] *
              //       (size!.width / widget.media?['meta']?['small']?['width']))),
              //   width: size!.width,
              //   color:
              //       greyColor, // Hiệu ứng chờ (có thể thay đổi thành widget khác)
              // )
            ],
          )),
    );
  }

  @override
  void dispose() {
    widget.removeObserver == true
        ? WidgetsBinding.instance.removeObserver(this)
        : null;
    videoPlayerController.pause();
    videoPlayerController.dispose();
    super.dispose();
  }
}
