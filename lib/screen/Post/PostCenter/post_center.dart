import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/widget/Map/map_widget_item.dart';

import '../../../theme/colors.dart';
import 'PostType/avatar_banner.dart';
import 'PostType/post_share_event.dart';
import 'PostType/post_share_group.dart';
import 'PostType/post_share_page.dart';
import 'PostType/post_target.dart';
import 'post_card.dart';
import 'post_content.dart';
import 'post_life_event.dart';
import 'post_media.dart';
import 'post_poll_center.dart';
import 'post_share.dart';

class PostCenter extends StatefulWidget {
  final dynamic post;
  final String? type;
  final dynamic data;
  const PostCenter({Key? key, this.post, this.type, this.data})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostCenterState createState() => _PostCenterState();
}

class _PostCenterState extends State<PostCenter> {
  @override
  Widget build(BuildContext context) {
    String postType = widget.post['post_type'] ?? '';
    return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.type == 'rating'
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Row(
                      children: List.generate(
                        5,
                        (index) => index < int.parse(widget.data['rating'])
                            ? const Icon(Icons.star,
                                size: 20, color: Colors.yellow)
                            : const Icon(
                                Icons.star_border,
                                size: 20,
                                color: greyColor,
                              ),
                      ),
                    ),
                  )
                : const SizedBox(),
            PostContent(
              post: widget.post,
            ),
            (widget.post['card'] != null ||
                    widget.post['poll'] != null ||
                    widget.post['life_event'] != null ||
                    postType == postAvatarAccount ||
                    postType == postBannerAccount)
                ? const SizedBox()
                : PostMedia(post: widget.post, type: widget.type),
            widget.post['card'] != null &&
                    widget.post['media_attachments'].length == 0
                ? PostCard(post: widget.post)
                : const SizedBox(),
            widget.post['poll'] != null
                ? PostPollCenter(post: widget.post)
                : const SizedBox(),
            widget.post['life_event'] != null
                ? PostLifeEvent(post: widget.post)
                : const SizedBox(),
            widget.post['shared_group'] != null
                ? PostShareGroup(post: widget.post)
                : const SizedBox(),
            widget.post['shared_page'] != null
                ? PostSharePage(post: widget.post)
                : const SizedBox(),
            widget.post['reblog'] != null
                ? PostShare(post: widget.post)
                : const SizedBox(),
            widget.post['place'] != null
                ? MapWidgetItem(checkin: widget.post['place'])
                : const SizedBox(),
            postType != '' ? renderPostType(postType) : const SizedBox(),
          ],
        ));
  }

  renderPostType(postType) {
    if ([postAvatarAccount, postBannerAccount].contains(postType)) {
      return AvatarBanner(postType: postType, post: widget.post);
    } else if ([postTarget, postVisibleQuestion].contains(postType)) {
      return PostTarget(
        post: widget.post,
        type: postType == postVisibleQuestion ? postQuestionAnwer : postTarget,
        statusQuestion: widget.post['status_question'],
      );
    } else if (postType == postShareEvent) {
      return PostShareEvent(post: widget.post);
    } else {
      return const SizedBox();
    }
  }
}
