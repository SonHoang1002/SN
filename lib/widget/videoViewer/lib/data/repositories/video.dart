import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/bloc/controller.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/bloc/metadata.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/entities/styles/video_viewer.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/repositories/video.dart';



class VideoQuery extends VideoQueryRepository {
  @override
  VideoViewerMetadata videoMetadata(
    BuildContext context, {
    bool listen = false,
  }) {
    return Provider.of<VideoViewerMetadata>(context, listen: listen);
  }

  @override
  VideoViewerController video(BuildContext context, {bool listen = false}) {
    return Provider.of<VideoViewerController>(context, listen: listen);
  }

  @override
  VideoViewerStyle videoStyle(BuildContext context, {bool listen = false}) {
    return Provider.of<VideoViewerMetadata>(context, listen: listen).style;
  }

  @override
  String durationFormatter(Duration duration) {
    final int hours = duration.inHours;
    final String formatter = [
      if (hours != 0) hours,
      duration.inMinutes,
      duration.inSeconds
    ]
        .map((seg) => seg.abs().remainder(60).toString().padLeft(2, '0'))
        .join(':');
    return duration.inSeconds < 0 ? "-$formatter" : formatter;
  }
}
