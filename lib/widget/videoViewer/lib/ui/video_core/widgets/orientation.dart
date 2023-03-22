import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';

class VideoCoreOrientation extends StatelessWidget {
  const VideoCoreOrientation({Key? key, this.builder}) : super(key: key);

  final Widget Function(bool)? builder;

  @override
  Widget build(BuildContext _) {
    return OrientationBuilder(builder: (context, Orientation orientation) {
      final video = VideoQuery().video(context, listen: false);
      return builder!(
        video.isFullScreen && orientation == Orientation.landscape,
      );
    });
  }
}
