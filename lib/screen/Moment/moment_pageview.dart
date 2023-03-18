import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_video.dart';
import 'package:social_network_app_mobile/screen/Moment/video_description.dart';

class MomentPageview extends StatelessWidget {
  final List momentRender;
  final Function handlePageChange;
  final int? initialPage;
  const MomentPageview(
      {Key? key,
      required this.momentRender,
      required this.handlePageChange,
      this.initialPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreloadPageView.builder(
      controller: PreloadPageController(initialPage: initialPage ?? 0),
      itemCount: momentRender.length,
      scrollDirection: Axis.vertical,
      preloadPagesCount: 5,
      onPageChanged: (value) {
        handlePageChange(value);
      },
      itemBuilder: (context, index) {
        return Stack(
          children: [
            MomentVideo(moment: momentRender[index]),
            Positioned(
                bottom: 15,
                left: 15,
                child: VideoDescription(moment: momentRender[index])),
          ],
        );
      },
    );
  }
}
