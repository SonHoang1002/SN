import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class WatchSuggest extends ConsumerStatefulWidget {
  final dynamic media;
  final dynamic post;
  final String? preType;
  final Function? updateData;
  const WatchSuggest(
      {Key? key, this.media, this.post, this.preType, this.updateData})
      : super(key: key);

  @override
  ConsumerState<WatchSuggest> createState() => _WatchSuggestState();
}

class _WatchSuggestState extends ConsumerState<WatchSuggest> {
  List listPostMedia = [];
  dynamic watchPost;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(widget.post);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        watchPost =
            ref.read(currentPostControllerProvider).currentPost ?? widget.post;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    listPostMedia = [];
    watchPost = null;
  }

  updateNewPost(dynamic newData) {
    setState(() {
      watchPost = ref.watch(currentPostControllerProvider).currentPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    watchPost =
        ref.watch(currentPostControllerProvider).currentPost ?? widget.post;
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
      body: (watchPost ?? widget.post) != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostHeader(
                        post: watchPost ?? widget.post,
                        textColor: white,
                        type: postDetail,
                        updateDataFunction: updateNewPost,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      PostContent(
                        post: watchPost ?? widget.post,
                        textColor: white,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Stack(
                        children: [
                          Hero(
                            tag: widget.media['remote_url'] ??
                                widget.media['url'],
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
                                            post: watchPost ?? widget.post,
                                            media: widget.media,
                                            type: postWatchDetail,
                                            preType: widget.preType,
                                            updateDataFunction: () {
                                              widget.updateData != null
                                                  ? widget.updateData!()
                                                  : null;
                                            },
                                          )));
                            },
                          ))
                        ],
                      ),
                      PostFooter(
                        post: watchPost ?? widget.post,
                        type: postWatch,
                        updateDataFunction: updateNewPost,
                        preType: widget.preType,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Center(
              child: buildCircularProgressIndicator(),
            ),
    );
  }
}
