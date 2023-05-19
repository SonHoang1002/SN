import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_suggest.dart';
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
  const VideoPlayerNoneController(
      {Key? key,
      required this.path,
      required this.type,
      this.media,
      this.aspectRatio,
      this.post,
      this.isShowVolumn})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerNoneControllerState createState() =>
      _VideoPlayerNoneControllerState();
}

class _VideoPlayerNoneControllerState
    extends ConsumerState<VideoPlayerNoneController> {
  late VideoPlayerController videoPlayerController;
  bool isVisible = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    videoPlayerController = (widget.path.startsWith('http')
        ? VideoPlayerController.network(widget.path)
        : VideoPlayerController.asset(widget.path))
      ..initialize().then((value) {
        if (widget.isShowVolumn != null && widget.isShowVolumn == false) {
          videoPlayerController.seekTo(
              Duration(seconds: ref.read(watchControllerProvider).position));
        }
        videoPlayerController.setLooping(true);
      })
      ..addListener(() {
        if (mounted) {
          ref.read(watchControllerProvider.notifier).updatePositonPlaying(
              videoPlayerController.value.position.inSeconds);
        }
      });
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
                    widget.media['id']) {
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
        key: Key(widget.media['id'] ?? widget.path),
        child: Stack(
          children: [
            GestureDetector(
                onTap: widget.type == 'local'
                    ? null
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WatchSuggest(
                                    post: widget.post, media: widget.media)));
                      },
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
    super.dispose();
    videoPlayerController.dispose();
  }
}
