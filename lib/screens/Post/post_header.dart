import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/refractor_time.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/group_detail.dart';
import 'package:social_network_app_mobile/screens/Post/PageReference/page_mention.dart';
import 'package:social_network_app_mobile/screens/Post/post_header_action.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/blue_certified_widget.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import 'post_detail.dart';

class PostHeader extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  final Color? textColor;
  final bool? isHaveAction;
  final Function? reloadFunction;
  final Function(dynamic)? updateDataFunction;
  final bool? isInGroup;
  const PostHeader(
      {Key? key,
      this.post,
      this.type,
      this.textColor,
      this.isHaveAction,
      this.reloadFunction,
      this.updateDataFunction,
      this.isInGroup = false})
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
      description = ' đang cảm thấy ${statusActivity['name']} cùng với ';
    } else if (statusActivity['data_type'] == postStatusActivity) {
      description =
          ' ${statusActivity['parent']['name'].toLowerCase()} ${statusActivity['name'].toLowerCase()}';
    }

    return description;
  }

  @override
  Widget build(BuildContext context) {
    final meData = ref.watch(meControllerProvider)[0];
    var size = MediaQuery.sizeOf(context);
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
              padding: const EdgeInsets.only(
                left: 12,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  isInGroup: widget.isInGroup),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    group != null
                                        ? InkWell(
                                            onTap: () {
                                              pushCustomCupertinoPageRoute(
                                                  context,
                                                  UserPageHome(
                                                    id: account['id']
                                                        .toString(),
                                                  ));
                                            },
                                            child: Text(account['display_name'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          )
                                        : const SizedBox(),
                                    buildSpacer(height: 3),
                                    Row(
                                      children: [
                                        widget.post['page_owner'] != null &&
                                                widget.post['page'] != null &&
                                                widget.post?['page_owner']?[
                                                            'page_relationship']
                                                        ?['role'] ==
                                                    "admin" &&
                                                widget.type != postDetail
                                            ? Row(
                                                children: [
                                                  buildTextContent(
                                                      widget.post['account']
                                                              ['display_name'] +
                                                          " · ",
                                                      true,
                                                      colorWord: greyColor,
                                                      fontSize: 13)
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.post['processing'] !=
                                                    "isProcessing" &&
                                                widget.post?['created_at'] !=
                                                    null
                                            ? Text(
                                                getRefractorTime(
                                                    widget.post?['created_at']),
                                                style: const TextStyle(
                                                    color: greyColor,
                                                    fontSize: 12),
                                              )
                                            : const SizedBox(),
                                        Text(
                                            widget.post['processing'] !=
                                                    "isProcessing"
                                                ? " · "
                                                : "",
                                            style: const TextStyle(
                                                color: greyColor)),
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
                    // (widget.post?['account']?['id'] == meData['id'] ||
                    //     (widget.post?['page'] != null &&
                    //         widget.post?['page_owner'] != null &&
                    //         widget.post?['page_owner']?['page_relationship']
                    //                 ?['role'] ==
                    //             "admin"))
                    // ?
                    (![postReblog, postMultipleMedia].contains(widget.type))
                        ? BlockPostHeaderAction(
                            widget: widget,
                            meData: meData,
                            ref: ref,
                          )
                        : const SizedBox()
                    // : const SizedBox()
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
        ((widget.post?['page_owner'] != null &&
                    !['moderator', 'admin', 'member'].contains(
                        widget.post?['page_owner']?['page_relationship']
                            ?['role']))) ||
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

class BlockNamePost extends ConsumerStatefulWidget {
  const BlockNamePost(
      {super.key,
      required this.account,
      required this.description,
      required this.mentions,
      this.group,
      this.page,
      this.statusActivity,
      this.post,
      this.textColor,
      this.type,
      this.isInGroup = false});
  final dynamic post;
  final dynamic account;
  final String description;
  final dynamic mentions;
  final dynamic group;
  final dynamic page;
  final dynamic statusActivity;
  final Color? textColor;
  final dynamic type;
  final bool? isInGroup;

  @override
  ConsumerState<BlockNamePost> createState() => _BlockNamePostState();
}

class _BlockNamePostState extends ConsumerState<BlockNamePost> {
  bool isFollowing = false;

  renderDisplayName() {
    if (widget.group != null) {
      return widget.group['title'];
    } else if (widget.page != null) {
      return widget.post['place']?['id'] != widget.page['id']
          ? widget.page['title']
          : widget.account['display_name'];
    } else {
      return widget.account['display_name'];
    }
  }

  bool checkHasBlueCertification() {
    if ((widget.page == null && widget.account?['certified'] == true) ||
        (widget.page != null && widget.page?['certified'] == true)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkInGroup(id) {
    List groupAdmin = ref.read(groupListControllerProvider).groupAdmin;
    List groupMember = ref.read(groupListControllerProvider).groupMember;
    bool isIdExistAdmin = groupAdmin.any((map) => map['id'] == id);
    bool isIdExistMember = groupMember.any((map) => map['id'] == id);
    if (isIdExistAdmin || isIdExistMember) {
      return true;
    } else {
      return false;
    }
  }

  TextSpan renderJoinTextSpan() {
    if (widget.group != null) {
      return (widget.group["group_relationship"] != null &&
              widget.group["group_relationship"]?["like"] == true)
          ? const TextSpan()
          : checkInGroup(widget.group["id"]) || widget.isInGroup == true
              ? const TextSpan()
              : TextSpan(
                  text: " · Tham gia",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        isFollowing = true;
                      });
                      chooseApi();
                    },
                  style: const TextStyle(color: secondaryColor));
    } else if (widget.page != null) {
      return widget.post['place']?['id'] != widget.page['id']
          ? (widget.page["page_relationship"] != null &&
                  widget.page["page_relationship"]?["like"] == true)
              ? const TextSpan()
              : TextSpan(
                  text: " ·  Theo dõi",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        isFollowing = true;
                      });
                      chooseApi();
                    },
                  style: const TextStyle(color: secondaryColor))
          : TextSpan(text: widget.account['display_name']);
    } else {
      return const TextSpan(text: '');
    }
  }

  chooseApi() async {
    if (widget.group != null) {
      //  await GroupApi().
    } else if (widget.page != null) {
      await PageApi().likePageSuggestion(widget.page['id']);
    }
  }

  void pushToScreen(BuildContext context) {
    final currentRouter = ModalRoute.of(context)?.settings.name;
    if (widget.type != "edit_post") {
      if ((widget.post?['place']?['id'] != widget.page?['id'] ||
          widget.post?['place']?['id'] != widget.post?['page']?['id'])) {
        if (currentRouter != '/page') {
          Navigator.pushNamed(context, '/page', arguments: widget.page);
          return;
        }
      } else if ((widget.group != null || widget.post?['group'] != null) &&
          (widget.group?['id'] != null ||
              widget.post?['group']?['id'] != null)) {
        pushCustomCupertinoPageRoute(
          context,
          GroupDetail(id: widget.group['id']),
        );
        return;
      } else {
        pushCustomCupertinoPageRoute(context, const UserPageHome(),
            settings: RouteSettings(
              arguments: {'id': widget.account['id']},
            ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        RichText(
          text: TextSpan(
            text: renderDisplayName(),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                pushToScreen(context);
              },
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.textColor ??
                    Theme.of(context).textTheme.displayLarge!.color),
            children: [
              const TextSpan(text: ' '),
              WidgetSpan(
                  child: checkHasBlueCertification()
                      ? buildBlueCertifiedWidget(
                          margin: const EdgeInsets.only(bottom: 2))
                      : const SizedBox()),
              widget.statusActivity.isNotEmpty
                  ? WidgetSpan(
                      child: ImageCacheRender(
                        path: widget.statusActivity['url'],
                        width: 18.0,
                        height: 18.0,
                      ),
                    )
                  : const TextSpan(text: ''),
              TextSpan(
                  text: widget.description,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 15)),
              widget.mentions.isNotEmpty
                  ? TextSpan(text: widget.mentions[0]['display_name'])
                  : const TextSpan(),
              widget.mentions.isNotEmpty && widget.mentions.length >= 2
                  ? const TextSpan(
                      text: ' và ',
                      style: TextStyle(fontWeight: FontWeight.normal))
                  : const TextSpan(),
              widget.mentions.isNotEmpty && widget.mentions.length == 2
                  ? TextSpan(
                      text: widget.mentions[1]['display_name'],
                    )
                  : const TextSpan(),
              widget.mentions.isNotEmpty && widget.mentions.length > 2
                  ? TextSpan(
                      text: '${widget.mentions.length - 1} người khác',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          pushCustomCupertinoPageRoute(
                              context, PageMention(mentions: widget.mentions));
                        })
                  : const TextSpan(),
              (widget.group != null || widget.page != null) && !isFollowing
                  ? TextSpan(
                      children: [
                        renderJoinTextSpan(),
                      ],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.textColor ??
                              Theme.of(context).textTheme.displayLarge!.color),
                    )
                  : const TextSpan()
            ],
          ),
        ),
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
      if ((page != null || post['page'] != null) &&
          (post?['place']?['id'] != page['id'] ||
              post?['place']?['id'] != post?['page']?['id'])) {
        if (currentRouter != '/page') {
          Navigator.pushNamed(context, '/page', arguments: page);
          return;
        }
      } else if ((group != null || post['group'] != null)) {
        pushCustomCupertinoPageRoute(context, GroupDetail(id: group['id']));
        return;
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
    String accountLink = account['avatar_media'] != null
        ? account['avatar_media']['preview_url']
        : linkAvatarDefault;
    String pageLink = page != null && page['avatar_media'] != null
        ? page['avatar_media']['preview_url']
        : linkAvatarDefault;
    return InkWell(
      onTap: () {
        pushToScreen(context);
      },
      child: group != null
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
                            image: NetworkImage(group['banner']
                                    ?['preview_url'] ??
                                linkBannerDefault),
                            onError: (exception, stackTrace) =>
                                const SizedBox(),
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
          : Padding(
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
