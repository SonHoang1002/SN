import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_suggest.dart';
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
  const VideoPlayerNoneController(
      {Key? key,
      this.timeStart,
      required this.path,
      required this.type,
      this.media,
      this.aspectRatio,
      this.post,
      this.isShowVolumn,
      this.isPause = false})
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final selectedVideo = ref.read(selectedVideoProvider);
    BetterState betterStatePlayer = ref.read(betterPlayerControllerProvider);

    videoPlayerController = (widget.path.startsWith('http')
        ? VideoPlayerController.network(widget.path)
        : VideoPlayerController.file(File(widget.path)))
      ..initialize().then((value) {
        videoPlayerController.setLooping(true);
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
      ..addListener(() {});

    if (widget.isPause == true) {
      videoPlayerController.pause();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.type == 'miniPlayer' && mounted) {
      ref.read(watchControllerProvider.notifier).updatePositionPlaying(
          videoPlayerController.value.position.inSeconds);
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
    return VisibilityDetector(
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
            GestureDetector(
                // onTap: () {
                //   widget.type == 'local'
                //       ? null
                //       : widget.post != null &&
                //               widget.post["post_type"] != null &&
                //               widget.post["post_type"] == 'moment'
                //           ? Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => Moment(
                //                         dataAdditional: widget.post,
                //                       )))
                //           : Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => WatchSuggest(
                //                       post: widget.post, media: widget.media)));
                // },
                child: Hero(
                    tag: widget.path,
                    child: AspectRatio(
                        aspectRatio: widget.aspectRatio ??
                            videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController)))),
            widget.isShowVolumn != null && widget.isShowVolumn == false
                ? const SizedBox()
                : Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          videoPlayerController.setVolume(_isMuted ? 0 : 1);
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
                    ))
          ],
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    videoPlayerController.pause();
    videoPlayerController.dispose();
    super.dispose();
  }
}
