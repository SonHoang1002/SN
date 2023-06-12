import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class WatchSuggest extends ConsumerStatefulWidget {
  final dynamic media;
  final dynamic post;
  const WatchSuggest({Key? key, this.media, this.post}) : super(key: key);

  @override
  ConsumerState<WatchSuggest> createState() => _WatchSuggestState();
}

class _WatchSuggestState extends ConsumerState<WatchSuggest> {
  List listPostMedia = [];

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostHeader(
                    post: widget.post, textColor: white, type: postDetail),
                const SizedBox(
                  height: 12.0,
                ),
                PostContent(
                  post: widget.post,
                  textColor: white,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Stack(
                  children: [
                    Hero(
                      tag: widget.media['remote_url'] ?? widget.media['url'],
                      child: VideoPlayerHasController(
                        media: widget.media,
                      ),
                    ),
                    Positioned.fill(child: GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WatchDetail(
                                    post: widget.post,
                                    media: widget.media,
                                    type: postWatchDetail)));
                      },
                    ))
                  ],
                ),
                PostFooter(
                  post: widget.post,
                  type: postWatch,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
