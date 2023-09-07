import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer_button.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer_information.dart';
import 'package:social_network_app_mobile/screens/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screens/Post/post_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post_list_share.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/reaction_list.dart';

class PostFooter extends StatelessWidget {
  final dynamic post;
  final dynamic type;
  final String? preType;
  final int? indexOfImage;
  final Function? reloadDetailFunction;
  final bool? isShowCommentBox;
  final Function(dynamic)? updateDataFunction;
  final Function(Offset)? jumpToOffsetFunction;
  final dynamic friendData;
  final dynamic groupData;
  final bool? isInGroup;

  const PostFooter(
      {Key? key,
      this.post,
      this.type,
      this.preType,
      this.indexOfImage,
      this.reloadDetailFunction,
      this.isShowCommentBox,
      this.updateDataFunction,
      this.jumpToOffsetFunction,
      this.friendData,
      this.isInGroup,
      this.groupData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        type == postDetail
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  ![postDetail, postMultipleMedia].contains(type)
                      ? pushCustomCupertinoPageRoute(
                          context,
                          PostDetail(
                              post: post,
                              preType: preType ?? type,
                              indexImagePost: indexOfImage,
                              updateDataFunction: updateDataFunction,
                              isInGroup: isInGroup,
                              groupData: groupData))
                      : showBarModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CommentPostModal(
                                post: post,
                                preType: preType,
                                indexImagePost: indexOfImage,
                                reloadFunction: reloadDetailFunction,
                              ));
                },
                child: PostFooterInformation(
                    post: post,
                    type: type,
                    // preType: checkPreType(),
                    indexImagePost: indexOfImage,
                    updateDataFunction: updateDataFunction)),
        Container(
          height: 1,
          margin: type == postDetail
              ? const EdgeInsets.fromLTRB(12, 5, 12, 4)
              : const EdgeInsets.fromLTRB(12, 0, 12, 4),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
        ),
        PostFooterButton(
          post: post,
          type: type,
          preType: preType,
          indexImage: indexOfImage,
          isShowCommentBox: isShowCommentBox,
          reloadDetailFunction: reloadDetailFunction,
          updateDataFunction: updateDataFunction,
          jumpToOffsetFunction: jumpToOffsetFunction,
          friendData: friendData,
        ),
        type != postDetail
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                  ),
                  GestureDetector(
                      onTap: () {
                        showBarModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ReactionList(post: post));
                      },
                      child: PostFooterInformation(
                          post: post,
                          type: type,
                          updateDataFunction: updateDataFunction)),
                  (post['reblogs_count'] ?? 0) > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3)),
                            ),
                            GestureDetector(
                              onTap: () {
                                showBarModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        PostListShare(post: post));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  '${shortenLargeNumber(post['reblogs_count'])} lượt chia sẻ',
                                  style: const TextStyle(
                                      color: greyColor, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
      ],
    );
  }
}
