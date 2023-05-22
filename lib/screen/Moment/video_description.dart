import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_page_hashtag.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_page_profile.dart';
import 'package:social_network_app_mobile/screen/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screen/Post/post_header_action.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/expandable_text.dart';
import 'package:social_network_app_mobile/widget/screen_share.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoDescription extends ConsumerStatefulWidget {
  final dynamic moment;
  const VideoDescription({super.key, this.moment});

  @override
  ConsumerState<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends ConsumerState<VideoDescription>
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
    bool highLightIcon =
        widget.moment['viewer_reaction'] == 'love' ? true : false;

    List iconsAction = [
      {
        "key": "reaction",
        "icon": FontAwesomeIcons.solidHeart,
        "count": reactionsCount,
        "iconHighlight": Colors.pink
      },
      {
        "key": "comment",
        "icon": FontAwesomeIcons.solidCommentDots,
        "count": widget.moment['replies_total'],
        "iconHighlight": Colors.white
      },
      {
        "key": "share",
        "icon": FontAwesomeIcons.share,
        "count": widget.moment['reblogs_count'],
        "iconHighlight": Colors.white
      },
      {
        "key": "menu",
        "icon": FontAwesomeIcons.ellipsis,
        "iconHighlight": Colors.white
      },
    ];

    handlePressMenu(key) {
      if (key == 'reaction') {
        Future.delayed(Duration.zero, () {
          ref.read(momentControllerProvider.notifier).updateReaction(
                highLightIcon ? null : 'love',
                widget.moment['id'],
              );
        });
      } else if (key == 'menu') {
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => MomentPageProfile(
                                            object: page ?? account,
                                            objectType: page != null
                                                ? 'page'
                                                : 'account')));
                              },
                              child: Text(
                                page != null
                                    ? page['title']
                                    : account['display_name'],
                                style: const TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ExpandableTextContent(
                          content: widget.moment['content'],
                          linkColor: Colors.white,
                          styleContent: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: white,
                              height: 1.5),
                          hashtagStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                          handleHashtag: (name) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        MomentPageHashtag(hashtag: name)));
                          },
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
                                text: 'Âm thanh   ·   ',
                                velocity: 30,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 80,
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                shape: BoxShape.circle),
                            child: AvatarSocial(
                                width: 49,
                                height: 49,
                                object: page ?? account,
                                path: page != null
                                    ? page['avatar_media'] != null
                                        ? page['avatar_media']['preview_url']
                                        : linkAvatarDefault
                                    : account['avatar_media']['preview_url']),
                          ),
                          Positioned(
                              bottom: -5,
                              right: 13,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
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
                                          size: 34,
                                          color: highLightIcon
                                              ? iconsAction[index]
                                                  ['iconHighlight']
                                              : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        (iconsAction[index]['count'] ?? '')
                                            .toString(),
                                        style: const TextStyle(
                                            color: white, fontSize: 14),
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
