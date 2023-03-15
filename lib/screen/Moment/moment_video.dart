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

class _MomentVideoState extends State<MomentVideo> {
  late VideoPlayerController videoPlayerController;
  bool isShowPlaying = true;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
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
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
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
            isVisible = visibilityInfo.visibleFraction > 0;
            if (isVisible) {
              videoPlayerController.play();
            } else {
              videoPlayerController.pause();
            }
          });
        }
      },
      child: InkWell(
        onTap: () {
          setState(() {
            videoPlayerController.value.isPlaying
                ? videoPlayerController.pause()
                : videoPlayerController.play();
          });
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: VideoPlayer(
                videoPlayerController,
              ),
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(),
                child: isPlaying(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
