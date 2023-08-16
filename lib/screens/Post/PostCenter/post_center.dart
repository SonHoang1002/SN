import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/PostType/post_project.dart';
import 'package:social_network_app_mobile/widgets/Map/map_widget_item.dart';

import '../../../theme/colors.dart';
import 'PostType/avatar_banner.dart';
import 'PostType/post_course.dart';
import 'PostType/post_product.dart';
import 'PostType/post_recruit.dart';
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

class PostCenter extends StatelessWidget {
  final dynamic post;
  final String? type;
  final dynamic data;
  final dynamic preType;
  final Function? backFunction;
  final Function? reloadFunction;
  final Function? showCmtBoxFunction;
  final Function(dynamic)? updateDataFunction;
  final bool? isFocus;
  final bool? isInGroup;
  final dynamic groupData;
  const PostCenter(
      {Key? key,
      this.post,
      this.type,
      this.data,
      this.preType,
      this.backFunction,
      this.reloadFunction,
      this.showCmtBoxFunction,
      this.updateDataFunction,
      this.isFocus,this.isInGroup,this.groupData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String postType = post['post_type'] ?? '';
    return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            type == 'rating' ? BlockRating(data: data) : const SizedBox(),
            PostContent(
              post: post,
            ),
            (post['card'] != null ||
                    post['poll'] != null ||
                    post['life_event'] != null ||
                    postType == postAvatarAccount ||
                    postType == postBannerAccount)
                ? const SizedBox()
                : PostMedia(
                    post: post,
                    type: type,
                    preType: preType ?? type,
                    backFunction: () {
                      backFunction != null ? backFunction!() : null;
                    },
                    isFocus: isFocus,
                    updateDataFunction: updateDataFunction,
                    reloadFunction: () {
                      reloadFunction != null ? reloadFunction!() : null;
                    },
                    isInGroup: isInGroup,
                    groupData: groupData,
                    showCmtBoxFunction: showCmtBoxFunction),
            //
            post['card'] != null && (post['media_attachments'].isEmpty)
                ? PostCard(post: post, type: type)
                : const SizedBox(),
            post['poll'] != null
                ? PostPollCenter(post: post, type: type)
                : const SizedBox(),
            post['life_event'] != null
                ? PostLifeEvent(post: post)
                : const SizedBox(),
            //have not group detail
            post['shared_group'] != null
                ? PostShareGroup(post: post, type: type)
                : const SizedBox(),
            post['shared_page'] != null
                ? PostSharePage(post: post, type: type)
                : const SizedBox(),
            post['reblog'] != null
                ? PostShare(post: post, type: postReblog)
                : const SizedBox(),
            post['place'] != null &&
                    (post['card'] == null &&
                        post['media_attachments'].isEmpty &&
                        post['poll'] == null &&
                        post['life_event'] == null &&
                        post['shared_group'] == null &&
                        post['shared_page'] == null &&
                        post['reblog'] == null &&
                        post['shared_course'] == null &&
                        post['shared_project'] == null &&
                        post['shared_recruit'] == null &&
                        post['shared_product'] == null &&
                        post['shared_event'] == null &&
                        ![postAvatarAccount, postBannerAccount]
                            .contains(postType) &&
                        ![postTarget, postVisibleQuestion].contains(postType))
                ? MapWidgetItem(checkin: post['place'])
                : const SizedBox(),
            post['shared_course'] != null
                ? PostCourse(post: post, type: type)
                : const SizedBox(),
            post['shared_project'] != null
                ? PostProject(
                    post: post,
                    type: type,
                  )
                : const SizedBox(),
            post['shared_recruit'] != null
                ? PostRecruit(post: post, type: type)
                : const SizedBox(),
            // add navi to product when have market place
            post['shared_product'] != null
                ? PostProduct(post: post, type: type)
                : const SizedBox(),
            post['shared_event'] != null
                ? PostShareEvent(post: post, type: type)
                : const SizedBox(),
            postType != '' ? renderPostType(postType) : const SizedBox(),
          ],
        ));
  }

  renderPostType(postType) {
    if ([postAvatarAccount, postBannerAccount].contains(postType)) {
      return AvatarBanner(
        postType: postType,
        post: post,
        type: type,
        preType: preType,
        updateDataFunction: updateDataFunction,
      );
    } else if ([postTarget, postVisibleQuestion].contains(postType)) {
      return PostTarget(
        post: post,
        type: postType == postVisibleQuestion ? postQuestionAnwer : postTarget,
        statusQuestion: post['status_question'],
      );
    }
    // else if (postType == postShareEvent) {
    //   return PostShareEvent(post: widget.post);
    // }
    else {
      return const SizedBox();
    }
  }
}

class BlockRating extends StatelessWidget {
  const BlockRating({
    super.key,
    required this.data,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Row(
        children: List.generate(
          5,
          (index) => index < int.parse(data['rating'])
              ? const Icon(Icons.star, size: 20, color: Colors.yellow)
              : const Icon(
                  Icons.star_border,
                  size: 20,
                  color: greyColor,
                ),
        ),
      ),
    );
  }
}
