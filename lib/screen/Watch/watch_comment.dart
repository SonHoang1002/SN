import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_controller.dart';

class WatchComment extends StatefulWidget {
  final dynamic post;
  const WatchComment({Key? key, this.post}) : super(key: key);

  @override
  State<WatchComment> createState() => _WatchCommentState();
}

class _WatchCommentState extends State<WatchComment> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () {
        showBarModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child:
                        CommentPostModal(post: widget.post, type: postWatch)))
            .whenComplete(() => Navigator.pop(context));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Transform.scale(
                scale: 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: VideoPlayerHasController(
                    media: widget.post['media_attachments'][0],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
