import 'dart:math';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/screen/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screen/Post/post_header_action.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/screen_share.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoDescription extends StatefulWidget {
  final dynamic moment;
  const VideoDescription({super.key, this.moment});

  @override
  State<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends State<VideoDescription>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var account = widget.moment['account'];
    var page = widget.moment['page'];
    final size = MediaQuery.of(context).size;
    int reactionsCount = widget.moment['favourites_count'] ?? 0;

    List iconsAction = [
      {
        "key": "reaction",
        "icon": FontAwesomeIcons.solidHeart,
        "count": reactionsCount
      },
      {
        "key": "comment",
        "icon": FontAwesomeIcons.solidCommentDots,
        "count": widget.moment['replies_total']
      },
      {
        "key": "share",
        "icon": FontAwesomeIcons.share,
        "count": widget.moment['reblogs_count']
      },
      {"key": "menu", "icon": FontAwesomeIcons.ellipsis},
    ];

    handlePressMenu(key) {
      if (key == 'menu') {
        showBarModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).canvasColor,
            barrierColor: Colors.transparent,
            builder: (context) =>
                PostHeaderAction(post: widget.moment, type: 'moment'));
      } else if (key == 'share') {
        showBarModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ScreenShare(
                entityShare: widget.moment,
                type: 'moment',
                entityType: 'post'));
      } else if (key == 'comment') {
        showBarModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => CommentPostModal(post: widget.moment));
      }
    }

    return SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: size.width - 90,
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              page != null
                                  ? page['title']
                                  : account['display_name'],
                              style: const TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ExpandableText(
                          widget.moment['content'],
                          expandText: 'Xem thêm',
                          collapseText: 'Thu gọn',
                          style: const TextStyle(fontSize: 13, color: white),
                          maxLines: 3,
                          linkColor: Colors.white,
                          animation: true,
                          collapseOnTextTap: true,
                          onHashtagTap: (name) => {},
                          hashtagStyle: const TextStyle(
                            color: secondaryColor,
                          ),
                          onMentionTap: (username) => {},
                          mentionStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          onUrlTap: (url) async {
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              return;
                            }
                          },
                          urlStyle: const TextStyle(color: secondaryColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.music_note_2,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              height: 20,
                              width: size.width - 120,
                              child: Marquee(
                                text: 'Đi đu đưa đi   ·   ',
                                velocity: 30,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                shape: BoxShape.circle),
                            child: AvatarSocial(
                                width: 45,
                                height: 45,
                                object: page ?? account,
                                path: page != null
                                    ? page['avatar_media'] != null
                                        ? page['avatar_media']['preview_url']
                                        : linkAvatarDefault
                                    : account['avatar_media']['preview_url']),
                          ),
                          Positioned(
                              bottom: -4,
                              right: 12,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                            iconsAction.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          handlePressMenu(
                                              iconsAction[index]['key']);
                                        },
                                        child: Icon(
                                          iconsAction[index]['icon'],
                                          size: 30,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        (iconsAction[index]['count'] ?? '')
                                            .toString(),
                                        style: const TextStyle(
                                            color: white, fontSize: 12),
                                      )
                                    ],
                                  ),
                                )),
                      ),
                      AnimatedBuilder(
                          animation: animationController,
                          child: Stack(
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: Image.asset('assets/disc.png'),
                              ),
                              Positioned(
                                left: 7.5,
                                top: 7.5,
                                child: AvatarSocial(
                                    width: 20,
                                    height: 20,
                                    object: page ?? account,
                                    path: page != null
                                        ? page['avatar_media'] != null
                                            ? page['avatar_media']
                                                ['preview_url']
                                            : linkAvatarDefault
                                        : account['avatar_media']
                                            ['preview_url']),
                              )
                            ],
                          ),
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: 2 * pi * animationController.value,
                              child: child,
                            );
                          })
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}
