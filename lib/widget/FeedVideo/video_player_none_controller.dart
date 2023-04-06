import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_suggest.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerNoneController extends StatefulWidget {
  final String path;
  final String type;
  final dynamic media;
  final dynamic post;
  final double? aspectRatio;
  const VideoPlayerNoneController(
      {Key? key,
      required this.path,
      required this.type,
      this.media,
      this.aspectRatio,
      this.post})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerNoneControllerState createState() =>
      _VideoPlayerNoneControllerState();
}

class _VideoPlayerNoneControllerState extends State<VideoPlayerNoneController> {
  late VideoPlayerController videoPlayerController;
  final ValueNotifier<int> videoPositionNotifier = ValueNotifier<int>(0);
  bool isVisible = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    videoPlayerController = (widget.path.startsWith('http')
        ? VideoPlayerController.network(widget.path)
        : VideoPlayerController.asset(widget.path))
      ..initialize().then((value) {
        videoPlayerController.setLooping(true);
      })
      ..addListener(() {
        videoPositionNotifier.value =
            videoPlayerController.value.position.inSeconds;
      });
  }

  @override
  Widget build(BuildContext context) {
    print('videoPositionNotifier, ${videoPositionNotifier.value}');

    return VisibilityDetector(
        onVisibilityChanged: (visibilityInfo) {
          if (mounted) {
            setState(() {
              isVisible = visibilityInfo.visibleFraction > 0.5;
              if (isVisible) {
                videoPlayerController.play();
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
                                    post: widget.post,
                                    media: widget.media,
                                    videoPositionNotifier:
                                        videoPositionNotifier)));
                      },
                child: Hero(
                    tag: widget.path,
                    child: AspectRatio(
                        aspectRatio: widget.aspectRatio ??
                            videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController)))),
            Positioned(
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
