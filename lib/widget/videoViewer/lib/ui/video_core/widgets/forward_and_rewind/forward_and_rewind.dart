import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/video_core/widgets/forward_and_rewind/layout.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/video_core/widgets/forward_and_rewind/ripple_side.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/widgets/transitions.dart';


class VideoCoreForwardAndRewind extends StatelessWidget {
  const VideoCoreForwardAndRewind({
    Key? key,
    required this.showRewind,
    required this.showForward,
    required this.forwardSeconds,
    required this.rewindSeconds,
  }) : super(key: key);

  final bool showRewind, showForward;
  final int rewindSeconds, forwardSeconds;

  @override
  Widget build(BuildContext context) {
    final lang = VideoQuery().videoMetadata(context).language;
    return VideoCoreForwardAndRewindLayout(
      rewind: CustomOpacityTransition(
        visible: showRewind,
        child: ForwardAndRewindRippleSide(
          text: "$rewindSeconds ${lang.seconds.toLowerCase()}",
          side: RippleSide.left,
        ),
      ),
      forward: CustomOpacityTransition(
        visible: showForward,
        child: ForwardAndRewindRippleSide(
          text: "$forwardSeconds ${lang.seconds.toLowerCase()}",
          side: RippleSide.right,
        ),
      ),
    );
  }
}
