import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PageReference/page_mention.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class PostHeader extends StatefulWidget {
  final dynamic post;
  const PostHeader({Key? key, this.post}) : super(key: key);

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  @override
  void initState() {
    GetTimeAgo.setDefaultLocale('vi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var account = widget.post['account'];
    var mentions = widget.post['mentions'] ?? [];
    String description = '';

    var postType = widget.post['post_type'];

    if (postType == postAvatarAccount) {
      description = ' đã cập nhật ảnh đại diện';
    } else if (postType == postBannerAccount) {
      description = ' đã cập nhật ảnh bìa';
    }

    if (mentions.isNotEmpty) {
      description = ' cùng với ';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: AvatarSocial(
                    width: 34,
                    height: 34,
                    path: account['avatar_media']['show_url'].contains('.jpg')
                        ? account['avatar_media']['show_url']
                        : account['avatar_media']['preview_url'],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.6,
                      child: RichText(
                        text: TextSpan(
                          text: account['display_name'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          children: [
                            TextSpan(
                                text: description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal)),
                            mentions.isNotEmpty
                                ? TextSpan(text: mentions[0]['display_name'])
                                : const TextSpan(),
                            mentions.isNotEmpty && mentions.length >= 2
                                ? const TextSpan(
                                    text: ' và ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal))
                                : const TextSpan(),
                            mentions.isNotEmpty && mentions.length == 2
                                ? TextSpan(
                                    text: mentions[1]['display_name'],
                                  )
                                : const TextSpan(),
                            mentions.isNotEmpty && mentions.length > 2
                                ? TextSpan(
                                    text: '${mentions.length - 1} người khác',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    PageMention(
                                                        mentions: mentions)));
                                      })
                                : const TextSpan(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          GetTimeAgo.parse(
                              DateTime.parse(widget.post['created_at'])),
                          style: const TextStyle(color: greyColor),
                        ),
                        const Text(" · "),
                        Icon(
                            typeVisibility.firstWhere((element) =>
                                element['key'] ==
                                widget.post['visibility'])['icon'],
                            size: 15,
                            color: greyColor)
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    FontAwesomeIcons.ellipsis,
                    size: 22,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    FontAwesomeIcons.xmark,
                    size: 22,
                  ),
                )
              ],
            )
          ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
