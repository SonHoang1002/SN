import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class WatchSuggest extends StatefulWidget {
  final dynamic media;
  const WatchSuggest({Key? key, this.media}) : super(key: key);

  @override
  State<WatchSuggest> createState() => _WatchSuggestState();
}

class _WatchSuggestState extends State<WatchSuggest> {
  List listPostMedia = [];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(iconColor: white),
            const AppBarTitle(title: "Video khác", textColor: white),
            Container()
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.media['remote_url'] ?? widget.media['url'],
              child: GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WatchDetail(
                                media: widget.media,
                              )));
                },
                child: VideoPlayerHasController(
                  media: widget.media,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
