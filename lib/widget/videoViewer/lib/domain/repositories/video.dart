import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/bloc/controller.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/bloc/metadata.dart';
import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/entities/styles/video_viewer.dart';



abstract class VideoQueryRepository {
  String durationFormatter(Duration duration);
  VideoViewerStyle videoStyle(BuildContext context, {bool listen = false});
  VideoViewerController video(BuildContext context, {bool listen = false});
  VideoViewerMetadata videoMetadata(BuildContext context,
      {bool listen = false});
}
