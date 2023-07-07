import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screens/Moment/moment_page_hashtag.dart';
import 'package:social_network_app_mobile/screens/Moment/moment_page_profile.dart';
import 'package:social_network_app_mobile/screens/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screens/Post/post_header_action.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/expandable_text.dart';
import 'package:social_network_app_mobile/widgets/screen_share.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'follow_animation.dart';

class VideoDescription extends ConsumerStatefulWidget {
  final dynamic moment;
  final String? type;
  const VideoDescription({super.key, this.moment, this.type});

  @override
  ConsumerState<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends ConsumerState<VideoDescription> {
  bool _isFollowing = false;
  bool showTick = false;
  // bool isWidgetExpanded = false;
  bool isEyeVisible = false;

  @override
  void initState() {
    super.initState();

    if (widget.moment?['account_relationships']?['following'] == true ||
        widget.moment?["account"]?['relationships']?['following'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _isFollowing = true;
        });
      });
    }
  }

  checkMomentFollow() async {
    var type;
    var id;
    if (widget.moment['page'] != null &&
        widget.moment['page_owner']['id'] != widget.moment['page']['id']) {
      // id là pageId
      id = widget.moment['page']['id'];
      type = momentPage;
    } else if (widget.moment['group'] != null &&
        widget.moment['group_owner']['id'] != widget.moment['group']['id']) {
      id = widget.moment['group']['id'];
      type = momentGroup;
    } else {
      id = widget.moment['account']['id'];
      type = momentUser;
    }
    ref.read(momentControllerProvider.notifier).followMoment(type, id);
  }

  handlePressMenu(key, highLightIcon, size) {
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
          barrierColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          builder: (context) => ScreenShare(entityShare: {
                ...widget.moment,
                'typePage': widget.type,
              }, type: 'moment', entityType: 'post'));
    } else if (key == 'comment') {
      showBarModalBottomSheet(
          context: context,
          barrierColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          builder: (context) => CommentPostModal(post: widget.moment));
    }
  }

  Color greyOpacity = const Color.fromRGBO(33, 33, 33, 1).withOpacity(0.9);
  Color whiteColor = Colors.white.withOpacity(0.95);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var account = widget.moment['account'];
    var page = widget.moment['page'];

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
        "iconHighlight": whiteColor
      },
      {
        "key": "share",
        "icon": FontAwesomeIcons.share,
        "count": widget.moment['reblogs_count'],
        "iconHighlight": whiteColor
      },
      {
        "key": "menu",
        "icon": FontAwesomeIcons.ellipsis,
        "iconHighlight": whiteColor
      },
    ];

    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 20),
                width: size.width,
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Positioned.fill(
                          bottom: 0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: <Color>[
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 15, right: 75, top: 20),
                          constraints: BoxConstraints(
                            maxHeight: size.height * 0.4,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (reactionsCount > 0)
                                  Container(
                                    height: 35,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: greyOpacity,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/shopping_cart.png',
                                          width: 22,
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        SizedBox(
                                          child: Text('Xem quần áo ở đây nha',
                                              style: customIbmPlexSans(
                                                  TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15))),
                                        )
                                      ],
                                    ),
                                  ),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      MomentPageProfile(
                                                          object:
                                                              page ?? account,
                                                          objectType: page !=
                                                                  null
                                                              ? 'page'
                                                              : 'account')));
                                        },
                                        child: Text(
                                          page != null
                                              ? page['title']
                                              : account['display_name'],
                                          style: customIbmPlexSans(
                                            TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ExpandableTextContent(
                                  content: widget.moment['content'],
                                  linkColor: whiteColor,
                                  styleContent: customIbmPlexSans(TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor,
                                      height: 1.5)),
                                  hashtagStyle: customIbmPlexSans(TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500)),
                                  handleHashtag: (name) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                MomentPageHashtag(
                                                    hashtag: name)));
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.music_note_2,
                                      size: 15,
                                      color: whiteColor,
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
                                        style: customIbmPlexSans(TextStyle(
                                            color: whiteColor, fontSize: 14)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(right: 4, bottom: 15),
              width: 60,
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
                            border: Border.all(width: 1, color: Colors.white),
                            shape: BoxShape.circle),
                        child: GestureDetector(
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
                          child: AvatarSocial(
                              width: 49,
                              height: 49,
                              object: page ?? account,
                              path: page != null
                                  ? page['avatar_media'] != null
                                      ? (page['avatar_media']?['preview_url'])
                                      : linkAvatarDefault
                                  : (account['avatar_media']?['preview_url']) ??
                                      linkAvatarDefault),
                        ),
                      ),
                      !_isFollowing
                          ? Positioned(
                              bottom: -5,
                              right: 13,
                              child: AddToTickAnimation(
                                additionalFunction: checkMomentFollow,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        iconsAction.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      handlePressMenu(iconsAction[index]['key'],
                                          highLightIcon, size);
                                    },
                                    child: Icon(
                                      iconsAction[index]['icon'],
                                      size: 30,
                                      color: highLightIcon
                                          ? iconsAction[index]['iconHighlight']
                                          : whiteColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      (iconsAction[index]['count'] ?? '')
                                          .toString(),
                                      style: customIbmPlexSans(
                                        TextStyle(
                                            color: whiteColor, fontSize: 14),
                                      ))
                                ],
                              ),
                            )),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
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
                                    ? (page['avatar_media']?['preview_url'])
                                    : linkAvatarDefault
                                : (account['avatar_media']?['preview_url']) ??
                                    linkAvatarDefault),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        if (reactionsCount > 0)
          Container(
            height: 40,
            width: size.width,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: greyOpacity,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.search, color: whiteColor, size: 23),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: size.width - 80,
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: 'Tìm kiếm',
                              style: customIbmPlexSans(TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis)),
                              children: const [
                                TextSpan(text: ' · '),
                                TextSpan(
                                    text:
                                        'Emso Việt Nam ra mắt mạng xã hội mới')
                              ]),
                        ),
                      ),
                    )
                  ],
                ),
                Icon(FontAwesomeIcons.chevronRight, size: 18, color: whiteColor)
              ],
            ),
          )
      ],
    );
  }
}
