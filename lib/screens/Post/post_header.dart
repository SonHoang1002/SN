import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/refractor_time.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/Post/PageReference/page_mention.dart';
import 'package:social_network_app_mobile/screens/Post/post_header_action.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import 'post_detail.dart';

class PostHeader extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  final Color? textColor;
  final bool? isHaveAction;
  final Function? reloadFunction;
  final Function? updateDataFunction;
  const PostHeader(
      {Key? key,
      this.post,
      this.type,
      this.textColor,
      this.isHaveAction,
      this.reloadFunction,
      this.updateDataFunction})
      : super(key: key);

  @override
  ConsumerState<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends ConsumerState<PostHeader> {
  String description = '';
  final ValueNotifier<bool> _isFollowing = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    GetTimeAgo.setDefaultLocale('vi');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          description = handleDescription();
        });
      }
    });
  }

  checkFollowing() {
    var group = widget.post?['group'];
    var page = widget.post?['page'];

    return (group != null &&
            group["group_relationship"] != null &&
            group["group_relationship"]?["like"] == true) ||
        (page != null &&
            widget.post['place']?['id'] != page['id'] &&
            (page["page_relationship"] != null &&
                page["page_relationship"]?["like"] == true));
  }

  String handleDescription() {
    String description = '';
    var mentions = widget.post['mentions'] ?? [];
    var statusActivity = widget.post['status_activity'] ?? {};
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
    if (widget.post['shared_event'] != null) {
      description = ' đã chia sẻ một sự kiện ';
    }
    if (widget.post['shared_course'] != null) {
      description = ' đã chia sẻ một khóa học ';
    }
    if (widget.post['shared_product'] != null) {
      description = ' đã chia sẻ một sản phẩm ';
    }
    if (widget.post['shared_project'] != null) {
      description = ' đã chia sẻ một dự án ';
    }
    if (widget.post['shared_recruit'] != null) {
      description = ' đã chia sẻ tin tuyển dụng ';
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

    return description;
  }

  @override
  Widget build(BuildContext context) {
    final meData = ref.watch(meControllerProvider)[0];
    var size = MediaQuery.of(context).size;
    var account = widget.post?['account'] ?? {};
    var group = widget.post?['group'];
    var page = widget.post?['page'];
    var mentions = widget.post['mentions'] ?? [];
    var statusActivity = widget.post['status_activity'] ?? {};

    return widget.post != null
        ? InkWell(
            hoverColor: transparent,
            highlightColor: transparent,
            splashColor: transparent,
            onTap: () {
              if (widget.type != postDetail && widget.type != 'edit_post') {
                pushCustomCupertinoPageRoute(
                    context,
                    PostDetail(
                        post: widget.post,
                        preType: widget.type,
                        updateDataFunction: widget.updateDataFunction));
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
                            account: account,
                            type: widget.type),
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
                                  type: widget.type,
                                  isFollowing: _isFollowing.value,
                                  handleLike: () {
                                    _isFollowing.value = true;
                                  }),
                            ),
                            BlockSubNamePost(
                                group: group, account: account, widget: widget)
                          ],
                        )
                      ],
                    ),
                    // widget.isHaveAction == true
                    widget.post['account']['id'] == meData['id'] ||
                            (widget.post['page'] != null &&
                                widget.post['page_owner'] != null &&
                                widget.post['page_owner']['page_relationship']
                                        ['role'] ==
                                    "admin")
                        ? (![postReblog, postMultipleMedia]
                                .contains(widget.type))
                            ? BlockPostHeaderAction(
                                widget: widget,
                                meData: meData,
                                ref: ref,
                              )
                            : const SizedBox()
                        : const SizedBox()
                  ]),
            ),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    _isFollowing.dispose();
    super.dispose();
  }
}

class BlockPostHeaderAction extends StatelessWidget {
  const BlockPostHeaderAction({
    super.key,
    required this.widget,
    required this.meData,
    required this.ref,
  });

  final PostHeader widget;

  final dynamic meData;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            showBarModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).canvasColor,
                barrierColor: Colors.transparent,
                builder: (context) => PostHeaderAction(
                      post: widget.post,
                      type: widget.type,
                      reloadFunction: () {
                        widget.reloadFunction != null
                            ? widget.reloadFunction!()
                            : null;
                      },
                    ));
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
        [postDetail, postPageUser].contains(widget.type) ||
                widget.post['account']['id'] == meData['id']
            ? const SizedBox()
            : InkWell(
                onTap: () async {
                  final data = {"hidden": true};
                  await PostApi().updatePost(widget.post['id'], data);
                  ref
                      .read(postControllerProvider.notifier)
                      .actionHiddenDeletePost(widget.type, widget.post);
                },
                child: const Icon(
                  FontAwesomeIcons.xmark,
                  size: 20,
                  color: greyColor,
                ),
              )
      ],
    );
  }
}

class BlockSubNamePost extends StatelessWidget {
  const BlockSubNamePost({
    super.key,
    required this.group,
    required this.account,
    required this.widget,
  });

  final dynamic group;
  final dynamic account;
  final PostHeader widget;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            buildSpacer(height: 3),
            Row(
              children: [
                widget.post['page_owner'] != null &&
                        widget.post['page'] != null &&
                        widget.post?['page_owner']?['page_relationship']
                                ?['role'] ==
                            "admin" &&
                        widget.type != postDetail
                    ? Row(
                        children: [
                          buildTextContent("Người đăng: ", true,
                              fontSize: 14, colorWord: blackColor),
                          buildTextContent(
                              widget.post['account']['display_name'] + " · ",
                              true,
                              colorWord: greyColor,
                              fontSize: 13)
                        ],
                      )
                    : const SizedBox(),
                widget.post['processing'] != "isProcessing"
                    ? Text(
                        getRefractorTime(widget.post?['created_at']),
                        style: const TextStyle(color: greyColor, fontSize: 12),
                      )
                    : const SizedBox(),
                Text(widget.post['processing'] != "isProcessing" ? " · " : "",
                    style: const TextStyle(color: greyColor)),
                Icon(
                    typeVisibility.firstWhere(
                        (element) =>
                            element['key'] == widget.post['visibility'],
                        orElse: () => {})['icon'],
                    size: 13,
                    color: greyColor)
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class BlockNamePost extends StatelessWidget {
  const BlockNamePost(
      {super.key,
      required this.account,
      required this.description,
      required this.mentions,
      required this.isFollowing,
      this.handleLike,
      this.group,
      this.page,
      this.statusActivity,
      this.post,
      this.textColor,
      this.type});
  final dynamic post;
  final dynamic account;
  final String description;
  final dynamic mentions;
  final dynamic group;
  final dynamic page;
  final dynamic statusActivity;
  final Color? textColor;
  final dynamic type;
  final bool isFollowing;
  final Function? handleLike;

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

  TextSpan renderLikeTextSpan() {
    if (group != null) {
      return (group["group_relationship"] != null &&
              group["group_relationship"]?["like"] == true)
          ? const TextSpan()
          : const TextSpan(
              text: " · Thích", style: TextStyle(color: secondaryColor));
    } else if (page != null) {
      return post['place']?['id'] != page['id']
          ? (page["page_relationship"] != null &&
                  page["page_relationship"]?["like"] == true)
              ? const TextSpan()
              : const TextSpan(
                  text: " ·  Thích", style: TextStyle(color: secondaryColor))
          : TextSpan(text: account['display_name']);
    } else {
      return const TextSpan(text: '');
    }
  }

  chooseApi() {
    if (group != null) {
      return (group["group_relationship"] != null &&
              group["group_relationship"]?["like"] == true)
          ? const TextSpan()
          : const TextSpan(
              text: " Thích", style: TextStyle(color: secondaryColor));
    } else if (page != null) {
      return post['place']?['id'] != page['id']
          ? (page["page_relationship"] != null &&
                  page["page_relationship"]?["like"] == true)
              ? const TextSpan()
              : const TextSpan(
                  text: " Thích", style: TextStyle(color: secondaryColor))
          : TextSpan(text: account['display_name']);
    } else {
      return const TextSpan(text: '');
    }
  }

  void pushToScreen(BuildContext context) {
    final currentRouter = ModalRoute.of(context)?.settings.name;

    if (type != "edit_post") {
      if (post['place']?['id'] != page?['id'] && currentRouter != '/page') {
        Navigator.pushNamed(context, '/page', arguments: page);
      } else {
        pushCustomCupertinoPageRoute(context, const UserPageHome(),
            settings: RouteSettings(
              arguments: {'id': account['id']},
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        InkWell(
          onTap: () {
            pushToScreen(context);
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
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15)),
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
                          })
                    : const TextSpan(),
              ],
            ),
          ),
        ),
        group != null || page != null || isFollowing
            ? InkWell(
                onTap: () {
                  handleLike != null ? handleLike!() : null;
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      renderLikeTextSpan(),
                    ],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor ??
                            Theme.of(context).textTheme.displayLarge!.color),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

class AvatarPost extends StatelessWidget {
  const AvatarPost(
      {super.key,
      required this.account,
      this.group,
      this.page,
      this.post,
      this.type});

  final dynamic post;
  final dynamic group;
  final dynamic page;
  final dynamic account;
  final dynamic type;

  void pushToScreen(BuildContext context) {
    final currentRouter = ModalRoute.of(context)?.settings.name;
    if (type != "edit_post") {
      if (page != null &&
          post['place']?['id'] != page['id'] &&
          currentRouter != '/page') {
        Navigator.pushNamed(context, '/page', arguments: page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                    margin: const EdgeInsets.only(right: 7, bottom: 7),
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
              pushToScreen(context);
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
