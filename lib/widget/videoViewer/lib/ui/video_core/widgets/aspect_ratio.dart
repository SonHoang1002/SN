import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';

class VideoCoreAspectRadio extends StatelessWidget {
  const VideoCoreAspectRadio({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = VideoQuery().video(context).video!;
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: child,
    );
  }
}
