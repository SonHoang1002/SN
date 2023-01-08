import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedVideo extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction < 0.3) {
          flickMultiManager.pause();
        }
      },
      child: FlickMultiPlayer(
          url: path,
          flickMultiManager: flickMultiManager,
          image: image,
          type: type),
    );
  }
}
