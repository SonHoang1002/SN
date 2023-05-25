import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_controller.dart';

class WatchDetail extends StatefulWidget {
  final dynamic media;
  final dynamic post;
  const WatchDetail({Key? key, this.media, this.post}) : super(key: key);

  @override
  State<WatchDetail> createState() => _WatchDetailState();
}

class _WatchDetailState extends State<WatchDetail> {
  double topPosition = 0;
  double leftPosition = 0;
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    String averageColor = widget.media['meta']['original']['average_color'];

    return Scaffold(
        body: Container(
      color: Color(int.parse('0xFF${averageColor.substring(1)}')),
      child: Center(
        child: Dismissible(
            direction: DismissDirection.vertical,
            key: const Key('page2'),
            resizeDuration: const Duration(milliseconds: 1),
            onDismissed: (direction) {
              Navigator.pop(context);
            },
            child: Hero(
              tag: widget.media['remote_url'] ?? widget.media['url'],
              child: VideoPlayerHasController(
                media: widget.media,
              ),
            )),
      ),
    ));
  }
}
