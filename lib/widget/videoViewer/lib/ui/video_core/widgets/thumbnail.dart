import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/data/repositories/video.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/widgets/play_and_pause.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/ui/widgets/transitions.dart';

class VideoCoreThumbnail extends StatelessWidget {
  const VideoCoreThumbnail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideoQuery query = VideoQuery();
    final controller = query.video(context, listen: true);
    final style = query.videoStyle(context);

    final Widget? thumbnail = style.thumbnail;

    return CustomOpacityTransition(
      visible: controller.isShowingThumbnail,
      child: Stack(children: [
        if (thumbnail != null) Positioned.fill(child: thumbnail),
        const Center(child: PlayAndPause(type: PlayAndPauseType.center)),
        Positioned.fill(
          child: GestureDetector(
            onTap: () async {
              await controller.play();
              controller.showAndHideOverlay();
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ]),
    );
  }
}
