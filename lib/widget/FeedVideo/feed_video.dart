import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedVideo extends StatefulWidget {
  final String path;
  final dynamic flickMultiManager;
  final String image;
  final String? type;

  const FeedVideo({
    super.key,
    required this.path,
    this.flickMultiManager,
    required this.image,
    this.type,
  });

  @override
  State<FeedVideo> createState() => _FeedVideoState();
}

class _FeedVideoState extends State<FeedVideo> {
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(widget.flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          widget.flickMultiManager.pause();
        }
      },
      child: FlickMultiPlayer(
          url: widget.path,
          flickMultiManager: widget.flickMultiManager,
          image: widget.image,
          type: widget.type),
    );
  }
}
