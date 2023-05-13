import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/page_detail.dart';
import 'package:social_network_app_mobile/screen/Post/PageReference/page_mention.dart';
import 'package:social_network_app_mobile/screen/Post/post_header_action.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import 'post_detail.dart';

class PostHeader extends StatefulWidget {
  final dynamic post;
  final dynamic type;
  final Color? textColor;
  const PostHeader({Key? key, this.post, this.type, this.textColor})
      : super(key: key);

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
    var account = widget.post['account'] ?? {};
    var group = widget.post['group'];
    var page = widget.post['page'];
    var mentions = widget.post['mentions'] ?? [];
    var statusActivity = widget.post['status_activity'] ?? {};
    String description = '';
    var place = widget.post['place'];

    var postType = widget.post['post_type'];

    if (postType == postAvatarAccount) {
      description = ' đã cập nhật ảnh đại diện';
    } else if (postType == postBannerAccount) {
      description = ' đã cập nhật ảnh bìa';
    } else if (postType == postTarget) {
      if (widget.post['status_target']['target_status'] == postTargetStatus) {
        description = ' đã hoàn thành một mục tiêu';
      } else {
        description = ' đã công bố mục tiêu mới';
      }
    } else if (postType == postVisibleQuestion) {
      description = ' đã đặt một câu hỏi';
    } else if (widget.post['post_type'] == postShareEvent) {
      description = ' đã chia sẻ một sự kiện';
    }

    if (place != null) {
      description = ' đang ở ${place['title']}';
    }

    if (mentions.isNotEmpty) {
      description = ' cùng với ';
    }

    if (widget.post['shared_group'] != null) {
      description = ' đã chia sẻ một nhóm ';
    }

    if (widget.post['shared_page'] != null) {
      description = ' đã chia sẻ một trang ';
    }

    if (widget.post['life_event'] != null) {
      description = ' đã thêm một sự kiện trong đời';
    }

    if (widget.post['reblog'] != null) {
      description = ' đã chia sẻ một bài viết';
    }

    if (widget.post['poll'] != null) {
      description = ' đã tạo một cuộc thăm dò ý kiến';
    }

    if (statusActivity['data_type'] == postStatusEmoji) {
      description = ' đang cảm thấy ${statusActivity['name']}';
    } else if (statusActivity['data_type'] == postStatusActivity) {
      description =
          ' ${statusActivity['parent']['name'].toLowerCase()} ${statusActivity['name'].toLowerCase()}';
    }

    return InkWell(
      hoverColor: transparent,
      highlightColor: transparent,
      splashColor: transparent,
      onTap: () {
        if (widget.type != postDetail) {
          pushCustomCupertinoPageRoute(
              context,
              PostDetail(
                post: widget.post,
                preType: widget.type,
              ));
          // Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => PostDetail(
          //               post: widget.post,
          //               preType: widget.type,
          //             )));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarPost(
                      post: widget.post,
                      group: group,
                      page: page,
                      account: account),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.6,
                        child: BlockNamePost(
                          post: widget.post,
                          account: account,
                          description: description,
                          mentions: mentions,
                          statusActivity: statusActivity,
                          group: group,
                          page: page,
                          textColor: widget.textColor,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              group != null
                                  ? Text(account['display_name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ))
                                  : const SizedBox(),
                              Row(
                                children: [
                                  Text(
                                    GetTimeAgo.parse(DateTime.parse(
                                        widget.post['created_at'])),
                                    style: const TextStyle(
                                        color: greyColor, fontSize: 12),
                                  ),
                                  const Text(" · ",
                                      style: TextStyle(color: greyColor)),
                                  Icon(
                                      typeVisibility.firstWhere(
                                          (element) =>
                                              element['key'] ==
                                              widget.post['visibility'],
                                          orElse: () => {})['icon'],
                                      size: 13,
                                      color: greyColor)
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              (![postReblog, postMultipleMedia].contains(widget.type))
                  ? Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showBarModalBottomSheet(
                                context: context,
                                backgroundColor: Theme.of(context).canvasColor,
                                barrierColor: Colors.transparent,
                                builder: (context) => PostHeaderAction(
                                    post: widget.post, type: widget.type));
                          },
                          child: const Icon(
                            FontAwesomeIcons.ellipsis,
                            size: 20,
                            color: greyColor,
                          ),
                        ),
                        SizedBox(
                          width: widget.type != postDetail ? 10 : 0,
                        ),
                        ![postDetail, postPageUser].contains(widget.type)
                            ? InkWell(
                                onTap: () {},
                                child: const Icon(
                                  FontAwesomeIcons.xmark,
                                  size: 20,
                                  color: greyColor,
                                ),
                              )
                            : const SizedBox()
                      ],
                    )
                  : const SizedBox()
            ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class BlockNamePost extends StatelessWidget {
  const BlockNamePost({
    super.key,
    required this.account,
    required this.description,
    required this.mentions,
    this.group,
    this.page,
    this.statusActivity,
    this.post,
    this.textColor,
  });
  final dynamic post;
  final dynamic account;
  final String description;
  final dynamic mentions;
  final dynamic group;
  final dynamic page;
  final dynamic statusActivity;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final currentRouter = ModalRoute.of(context)?.settings.name;

    renderDisplayName() {
      if (group != null) {
        return group['title'];
      } else if (page != null) {
        return post['place']?['id'] != page['id']
            ? page['title']
            : account['display_name'];
      } else {
        return account['display_name'];
      }
    }

    void pushToScreen() {
      if (post['place']?['id'] != page?['id'] && currentRouter != '/page') {
        Navigator.pushNamed(context, '/page', arguments: page);
      } else {
        pushCustomCupertinoPageRoute(context, const UserPage(),
            settings: RouteSettings(
              arguments: {'id': account['id']},
            ));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const UserPage(),
        //       settings: RouteSettings(
        //         arguments: {'id': account['id']},
        //       ),
        //     ));
      }
    }

    return InkWell(
        onTap: () {
          pushToScreen();
        },
        child: RichText(
          text: TextSpan(
            text: renderDisplayName(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor ??
                    Theme.of(context).textTheme.displayLarge!.color),
            children: [
              const TextSpan(text: ' '),
              statusActivity.isNotEmpty
                  ? WidgetSpan(
                      child: ImageCacheRender(
                        path: statusActivity['url'],
                        width: 18.0,
                        height: 18.0,
                      ),
                    )
                  : const TextSpan(text: ''),
              TextSpan(
                  text: description,
                  style: const TextStyle(fontWeight: FontWeight.normal)),
              mentions.isNotEmpty
                  ? TextSpan(text: mentions[0]['display_name'])
                  : const TextSpan(),
              mentions.isNotEmpty && mentions.length >= 2
                  ? const TextSpan(
                      text: ' và ',
                      style: TextStyle(fontWeight: FontWeight.normal))
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
                          pushCustomCupertinoPageRoute(
                              context, PageMention(mentions: mentions));
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) =>
                          //             PageMention(mentions: mentions)));
                        })
                  : const TextSpan(),
            ],
          ),
        ));
  }
}

class AvatarPost extends StatelessWidget {
  const AvatarPost({
    super.key,
    required this.account,
    this.group,
    this.page,
    this.post,
  });

  final dynamic post;
  final dynamic group;
  final dynamic page;
  final dynamic account;

  @override
  Widget build(BuildContext context) {
    final currentRouter = ModalRoute.of(context)?.settings.name;

    void pushToScreen() {
      if (post['place']?['id'] != page['id'] && currentRouter != '/page') {
        Navigator.pushNamed(context, '/page', arguments: page);
      }
    }

    String accountLink = account['avatar_media'] != null
        ? account['avatar_media']['preview_url']
        : linkAvatarDefault;
    String pageLink = page != null && page['avatar_media'] != null
        ? page['avatar_media']['preview_url']
        : linkAvatarDefault;
    return group != null
        ? SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(group['banner']?['preview_url'] ??
                              linkBannerDefault),
                          onError: (exception, stackTrace) => const SizedBox(),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                    bottom: 7,
                    right: 7,
                    child: Avatar(
                      type: 'group',
                      path: accountLink,
                      object: account,
                    ))
              ],
            ),
          )
        : InkWell(
            onTap: () {
              pushToScreen();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Avatar(
                path: page != null && post['place']?['id'] != page['id']
                    ? pageLink
                    : accountLink,
                object: page,
              ),
            ),
          );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.path,
    this.type,
    this.object,
  });

  final String path;
  final dynamic type;
  final dynamic object;

  @override
  Widget build(BuildContext context) {
    return AvatarSocial(
      width: type != null ? 25 : 36,
      height: type != null ? 25 : 36,
      path: path,
      object: object,
    );
  }
}
