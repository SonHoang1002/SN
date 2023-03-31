import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_button.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_information.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
import 'package:social_network_app_mobile/screen/Post/post_list_share.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/reaction_list.dart';

class PostFooter extends StatelessWidget {
  final dynamic post;
  final dynamic type;
  const PostFooter({Key? key, this.post, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        type == postDetail
            ? const SizedBox()
            : InkWell(
                onTap: ![postDetail, postMultipleMedia].contains(type)
                    ? () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => PostDetail(post: post)));
                      }
                    : null,
                child: PostFooterInformation(post: post, type: type)),
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
                      child: PostFooterInformation(post: post, type: type)),
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
