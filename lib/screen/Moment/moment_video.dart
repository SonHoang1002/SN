import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/video_description.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MomentVideo extends ConsumerStatefulWidget {
  const MomentVideo({Key? key, this.moment, this.type}) : super(key: key);
  final dynamic moment;
  final String? type;

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<MomentVideo> createState() => _MomentVideoState();
}

class _MomentVideoState extends ConsumerState<MomentVideo>
    with TickerProviderStateMixin {
  late VideoPlayerController videoPlayerController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _xPosition = 0;
  double _yPosition = 0;
  bool isShowPlaying = true;
  bool isVisible = false;
  bool isDragSlider = false;

  bool _sliderChanging = false;
  double _sliderValue = 0;

  dynamic imageThumbnail;

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
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
        setState(() {
          isShowPlaying = false;
        });
      })
      ..addListener(() {
        if (!_sliderChanging && mounted) {
          setState(() {
            _sliderValue =
                videoPlayerController.value.position.inSeconds.toDouble();
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    videoPlayerController.dispose();
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
    Future.delayed(Duration.zero, () {
      ref.read(momentControllerProvider.notifier).updateReaction(
            widget.moment['viewer_reaction'] == 'love' ? null : 'love',
            widget.moment['id'],
          );
    });
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

  handleSlider(data) {
    setState(() {
      isDragSlider = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                    child: Center(
                      child: videoPlayerController.value.aspectRatio >= 0.6
                          ? AspectRatio(
                              aspectRatio:
                                  videoPlayerController.value.aspectRatio,
                              child: renderVideoMoment(size,
                                  videoPlayerController.value.aspectRatio),
                            )
                          : renderVideoMoment(
                              size, videoPlayerController.value.aspectRatio),
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
            if (widget.type != 'momentFeed')
              _sliderChanging
                  ? Positioned(
                      bottom: 30,
                      child: SizedBox(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatDuration(
                                  Duration(seconds: _sliderValue.round())),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              '/',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              formatDuration(Duration(
                                  seconds: videoPlayerController
                                      .value.duration.inSeconds)),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ))
                  : const SizedBox(),
            if (widget.type != 'momentFeed')
              Stack(
                children: [
                  isDragSlider
                      ? Container()
                      : Positioned(
                          bottom: 0,
                          left: 0,
                          child: VideoDescription(
                            moment: widget.moment,
                          )),
                  Positioned(
                      bottom: -23,
                      left: -23,
                      right: -23,
                      child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: _sliderChanging ? 2 : 0.3,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 1.5,
                            ),
                          ),
                          child: SizedBox(
                            child: Slider(
                              activeColor: Colors.white
                                  .withOpacity(_sliderChanging ? 1 : 0.8),
                              inactiveColor: Colors.white.withOpacity(0.4),
                              value: _sliderValue,
                              min: 0,
                              max: videoPlayerController
                                  .value.duration.inSeconds
                                  .toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  _sliderChanging = true;
                                  _sliderValue = value;
                                });
                                handleSlider(true);
                              },
                              onChangeEnd: (value) {
                                videoPlayerController
                                    .seekTo(Duration(seconds: value.toInt()));
                                setState(() {
                                  _sliderChanging = false;
                                });
                                handleSlider(false);
                              },
                            ),
                          ))),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget renderVideoMoment(Size size, double ratio) {
    return VideoPlayer(
      videoPlayerController,
    );
    // : ImageCacheRender(
    //     width: size.width,
    //     height: size.height,
    //     path: widget.moment['media_attachments'][0]['preview_url'],
    //   );
  }
}
