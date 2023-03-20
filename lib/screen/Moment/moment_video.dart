import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MomentVideo extends StatefulWidget {
  const MomentVideo({Key? key, this.moment}) : super(key: key);
  final dynamic moment;

  @override
  // ignore: library_private_types_in_public_api
  _MomentVideoState createState() => _MomentVideoState();
}

class _MomentVideoState extends State<MomentVideo>
    with TickerProviderStateMixin {
  late VideoPlayerController videoPlayerController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _xPosition = 0;
  double _yPosition = 0;
  bool isShowPlaying = true;
  bool isVisible = false;
  bool isDrag = false;
  double position = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    videoPlayerController = VideoPlayerController.network(
        widget.moment['media_attachments'][0]['url'])
      ..initialize().then((value) {
        if (isVisible) {
          videoPlayerController.play();
        }
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
        setState(() {
          isShowPlaying = false;
        });
      })
      ..addListener(() {
        final bool isPlaying = videoPlayerController.value.isPlaying;
        final bool isEndOfVideo = videoPlayerController.value.position ==
            videoPlayerController.value.duration;
        if (isPlaying && !isEndOfVideo) {
          setState(() {
            position = videoPlayerController.value.position.inMilliseconds
                    .toDouble() /
                videoPlayerController.value.duration.inMilliseconds.toDouble();
          });
        }
      });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      if (videoPlayerController.value.isPlaying) {
        setState(() {
          position = videoPlayerController.value.position.inMilliseconds
                  .toDouble() /
              videoPlayerController.value.duration.inMilliseconds.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    videoPlayerController.dispose();
    _timer.cancel();
    super.dispose();
  }

  _handleOnDoubleTap(TapDownDetails tapDetails) {
    setState(() {
      _xPosition = tapDetails.globalPosition.dx;
      _yPosition = tapDetails.globalPosition.dy;
    });

    _animationController
        .forward()
        .then((value) => _animationController.repeat(max: 0));
  }

  Widget isPlaying() {
    return videoPlayerController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('moment_video_${widget.moment['id']}'),
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
      child: GestureDetector(
        onTap: () {
          setState(() {
            videoPlayerController.value.isPlaying
                ? videoPlayerController.pause()
                : videoPlayerController.play();
          });
        },
        onDoubleTapDown: (TapDownDetails tapDetails) {
          _handleOnDoubleTap(tapDetails);
        },
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: VideoPlayer(
                      videoPlayerController,
                    )),
                if (_xPosition != 0 && _yPosition != 0)
                  Positioned(
                    left: _xPosition - 50,
                    top: _yPosition - 50,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                            opacity: 1 - _animation.value == 1
                                ? 0
                                : 1 - _animation.value,
                            child: Transform.scale(
                              scale: 1 + 2 * _animation.value,
                              child: const Icon(
                                Icons.favorite,
                                size: 100,
                                color: Colors.pink,
                              ),
                            ));
                      },
                    ),
                  ),
              ],
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(),
                child: isPlaying(),
              ),
            ),
            // Positioned(
            //   bottom: -9,
            //   child: SliderTheme(
            //       data: const SliderThemeData(
            //         trackHeight: 2.0,
            //         thumbShape: RoundSliderThumbShape(
            //           enabledThumbRadius: 0,
            //         ),
            //       ),
            //       child: SizedBox(
            //         width: size.width,
            //         height: 20.0,
            //         child: Expanded(
            //           child: Slider(
            //             activeColor: Colors.white,
            //             inactiveColor: Colors.white.withOpacity(0.5),
            //             value: position,
            //             min: 0.0,
            //             max: videoPlayerController.value.duration.inMilliseconds
            //                 .toDouble(),
            //             onChanged: (double value) {
            //               setState(() {
            //                 position = value;
            //                 final Duration duration =
            //                     videoPlayerController.value.duration;
            //                 final newPosition =
            //                     duration.inMilliseconds * value.toInt();
            //                 videoPlayerController
            //                     .seekTo(Duration(milliseconds: newPosition));
            //               });
            //             },
            //           ),
            //         ),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
