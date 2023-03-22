import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/widgets/transitions.dart';

class VideoCoreBuffering extends StatelessWidget {
  const VideoCoreBuffering({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = VideoQuery();
    final video = query.video(context, listen: true);
    final style = query.videoStyle(context);

    return CustomOpacityTransition(
      visible: video.isBuffering,
      child: style.buffering,
    );
  }
}
