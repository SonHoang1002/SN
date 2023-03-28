import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_none_controller.dart';

class WatchDetail extends StatefulWidget {
  final dynamic media;
  const WatchDetail({Key? key, this.media}) : super(key: key);

  @override
  State<WatchDetail> createState() => _WatchDetailState();
}

class _WatchDetailState extends State<WatchDetail> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String averageColor = widget.media['meta']['original']['average_color'];

    return Scaffold(
      body: Container(
        color: Color(int.parse('0xFF${averageColor.substring(1)}')),
        child: Center(
            child: VideoPlayerNoneController(
                media: widget.media,
                path: widget.media['remote_url'] ?? widget.media['url'],
                type: 'local')),
      ),
    );
  }
}
