import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/widgets/show_modal_message.dart';

import '../apis/post_api.dart';
import '../constant/common.dart';
import '../providers/share_action/share_provider.dart';
import '../theme/colors.dart';
import 'appbar_title.dart';
import 'avatar_social.dart';

class ShareModalBottom extends ConsumerStatefulWidget {
  final dynamic data;
  final String? type;
  const ShareModalBottom({Key? key, this.data, this.type}) : super(key: key);
  @override
  ConsumerState<ShareModalBottom> createState() => _ShareModalBottomState();
}

List iconShareModal = [
  {
    "key": "share",
    "label": "Chia sẻ lên tin của bạn",
    "icon": FontAwesomeIcons.bookOpen
  },
  {
    "key": "share-send",
    "label": "Gửi bằng Messenger",
    "icon": FontAwesomeIcons.facebookMessenger
  },
  {
    "key": "share-group",
    "label": "Chia sẻ lên nhóm",
    "icon": FontAwesomeIcons.users
  },
  {
    "key": "share-option",
    "label": "Tuỳ chọn khác",
    "icon": FontAwesomeIcons.arrowUpRightFromSquare
  },
];
List shareAction = [
  {
    "key": "feed",
    "label": "Bảng feed",
  },
  {
    "key": "friend-timelines",
    "label": "Dòng thời gian bạn bè",
    "icon": FontAwesomeIcons.users
  },
  {"key": "share-group", "label": "Nhóm", "icon": FontAwesomeIcons.users},
];

class _ShareModalBottomState extends ConsumerState<ShareModalBottom> {
  FocusNode focusNode = FocusNode();
  String renderShareType = '';
  dynamic shareGroupSelected = {};
  dynamic shareFriendSelected = {};
  TextEditingController valueStatus = TextEditingController(text: '');

  String shareModalSelected = 'feed';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref
          .read(shareControllerProvider.notifier)
          .getShareGroup({"tab": "join", "limit": 5});
      ref.read(shareControllerProvider.notifier).getShareFriend({"limit": 10});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    valueStatus.dispose();
    super.dispose();
  }

  String renderTitle(type) {
    switch (type) {
      case "event":
        return '${widget.data['account']['display_name']} đã tạo một sự kiện.';
      case "grow":
        return '${widget.data['account']['display_name']} đã tạo một dự án.';
      case "recruit":
        return '${widget.data['account']['display_name']} đã tạo một tuyển dụng.';
      case "course":
        return '${widget.data['account']['display_name']} đã tạo một khoá học.';
      default:
        return '';
    }
  }

  dynamic renderParams(type) {
    switch (type) {
      case "event":
        return {
          "shared_event_id": widget.data['id'],
          "status": valueStatus.text != "" ? valueStatus.text : '',
          "visibility": "public"
        };
      case "grow":
        return {
          "shared_project_id": widget.data['id'],
          "status": valueStatus.text != "" ? valueStatus.text : '',
          "visibility": "public"
        };
      case "recruit":
        return {
          "shared_recruit_id": widget.data['id'],
          "status": valueStatus.text != "" ? valueStatus.text : '',
          "visibility": "public"
        };
      case "course":
        return {
          "shared_course_id": widget.data['id'],
          "status": valueStatus.text != "" ? valueStatus.text : '',
          "visibility": "public"
        };
      default:
        return {};
    }
  }

  Future handleShare(data, context) async {
    try {
      switch (renderShareType) {
        case 'group':
          var res = await PostApi().createStatus({
            "group_id": shareGroupSelected['id'],
            ...renderParams(widget.type),
          });
          break;
        case 'friend':
          var res = await PostApi().createStatus({
            "target_account_id": shareFriendSelected['id'],
            ...renderParams(widget.type),
          });
          break;
        default:
          var res = await PostApi().createStatus(renderParams(widget.type));
          break;
      }
      showSnackbar(context, 'chia sẻ thành công');
    } on DioError catch (e) {
      showSnackbar(
        context,
        e.response!.data['error'].toString(),
      );
    } finally {
      if (context != null) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var meData = ref.watch(meControllerProvider)[0];
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (focusNode.hasFocus) {
          focusNode.unfocus();
        }
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: !focusNode.hasFocus,
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ExtendedImage.network(
                            widget.data['banner'] != null
                                ? widget.data['banner']['url']
                                : linkBannerDefault,
                            fit: BoxFit.cover,
                            width: 44,
                            height: 44),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            renderTitle(widget.type),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.data['account']['display_name'],
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ]),
                  ),
                  Visibility(
                    visible: focusNode.hasFocus,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Padding(
                      padding: focusNode.hasFocus
                          ? const EdgeInsets.only(bottom: 16.0)
                          : EdgeInsets.zero,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (focusNode.hasFocus) {
                                focusNode.unfocus();
                              }
                            },
                            child: const Icon(
                              FontAwesomeIcons.chevronLeft,
                              size: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Chia sẻ',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  !focusNode.hasFocus
                      ? const Divider(
                          height: 20,
                          thickness: 1,
                        )
                      : const SizedBox(),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            children: [
                              AvatarSocial(
                                  width: 36,
                                  height: 36,
                                  path: meData['avatar_media'] != null
                                      ? meData['avatar_media']['preview_url']
                                      : meData['avatar_static']),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, bottom: 10, top: 4),
                                      child: Text(
                                        meData['display_name'],
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (shareGroupSelected['title'] != null &&
                                            shareGroupSelected['title']
                                                    .length >=
                                                10 ||
                                        shareFriendSelected['display_name'] !=
                                            null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return SharePlace(
                                                      meData: meData,
                                                      shareModalSelected:
                                                          shareModalSelected,
                                                      onItemSelected:
                                                          (valuePlace) {
                                                        if (valuePlace ==
                                                            'share-group') {
                                                          showModalBottomSheet(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      ShareGroup(
                                                                        selectedIndex:
                                                                            shareGroupSelected['id'],
                                                                        onItemSelected:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            shareGroupSelected =
                                                                                value;
                                                                            renderShareType =
                                                                                'group';
                                                                            shareModalSelected =
                                                                                valuePlace;
                                                                          });
                                                                        },
                                                                      ));
                                                        }
                                                        if (valuePlace ==
                                                            'friend-timelines') {
                                                          showModalBottomSheet(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      ShareFriend(
                                                                        selectedIndex:
                                                                            shareFriendSelected['id'],
                                                                        onItemSelected:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            shareFriendSelected =
                                                                                value;
                                                                            renderShareType =
                                                                                'friend';
                                                                            shareModalSelected =
                                                                                valuePlace;
                                                                          });
                                                                        },
                                                                      ));
                                                        }
                                                      },
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              height: 24,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 0, 6, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: greyColor),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      shareGroupSelected[
                                                                  'title'] !=
                                                              null
                                                          ? shareGroupSelected[
                                                                          'title']
                                                                      .length >=
                                                                  30
                                                              ? shareGroupSelected[
                                                                          'title']
                                                                      .substring(
                                                                          0,
                                                                          30) +
                                                                  '...'
                                                              : shareGroupSelected[
                                                                  'title']
                                                          : shareFriendSelected[
                                                                      'display_name'] !=
                                                                  null
                                                              ? 'Dòng thời gian ${shareFriendSelected['display_name']}'
                                                              : 'Bảng feed',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 3.0),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0),
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .sortDown,
                                                        color: Colors.black,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 24,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 10, 10, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: greyColor),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Row(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2.0),
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .userGroup,
                                                        color: Colors.black,
                                                        size: 10,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Text(
                                                      shareGroupSelected[
                                                                  'title'] !=
                                                              null
                                                          ? shareGroupSelected[
                                                                          'title']
                                                                      .length >=
                                                                  24
                                                              ? 'Thành viên nhóm ${shareGroupSelected['title'].substring(0, 24)}...'
                                                              : 'Thành viên nhóm ${shareGroupSelected['title']}'
                                                          : shareFriendSelected[
                                                                      'display_name'] !=
                                                                  null
                                                              ? 'Bạn bè của ${shareFriendSelected['display_name']}'
                                                              : 'Bạn bè',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 3.0),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0),
                                                      child: Center(
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .sortDown,
                                                          color: Colors.black,
                                                          size: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return SharePlace(
                                                        meData: meData,
                                                        shareModalSelected:
                                                            shareModalSelected,
                                                        onItemSelected:
                                                            (valuePalace) {
                                                          if (valuePalace ==
                                                              'share-group') {
                                                            showModalBottomSheet(
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        ShareGroup(
                                                                          selectedIndex:
                                                                              shareGroupSelected['id'],
                                                                          onItemSelected:
                                                                              (value) {
                                                                            setState(() {
                                                                              shareGroupSelected = value;
                                                                              renderShareType = 'group';
                                                                              shareModalSelected = valuePalace;
                                                                            });
                                                                          },
                                                                        ));
                                                          }
                                                          if (valuePalace ==
                                                              'friend-timelines') {
                                                            showModalBottomSheet(
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        ShareFriend(
                                                                          onItemSelected:
                                                                              (value) {
                                                                            setState(() {
                                                                              shareFriendSelected = value;
                                                                              renderShareType = 'friend';
                                                                              shareModalSelected = valuePalace;
                                                                            });
                                                                          },
                                                                        ));
                                                          }
                                                        },
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                height: 24,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 6, 0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        shareGroupSelected[
                                                                'title'] ??
                                                            'Bảng feed',
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 3.0,
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 8.0),
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .sortDown,
                                                            color: Colors.black,
                                                            size: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 24,
                                              margin: const EdgeInsets.fromLTRB(
                                                  2, 0, 6, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Row(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2.0),
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .userGroup,
                                                          color: Colors.black,
                                                          size: 10),
                                                    ),
                                                    const SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      shareGroupSelected[
                                                                  'title'] !=
                                                              null
                                                          ? 'Thành viên nhóm ${shareGroupSelected['title']}'
                                                          : 'Bạn bè',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(
                                                      width: 3.0,
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0),
                                                      child: Center(
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .sortDown,
                                                            color: Colors.black,
                                                            size: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: TextFormField(
                            focusNode: focusNode,
                            controller: valueStatus,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Hãy nói gì đó về nội dung này...',
                              hintStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 10, bottom: 12),
                          child: InkWell(
                            onTap: () {
                              handleShare(widget.data, context);
                            },
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Chia sẻ ngay',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: !focusNode.hasFocus,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: List.generate(
                            iconShareModal.length,
                            (index) => GestureDetector(
                              onTap: () {
                                if (iconShareModal[index]['key'] ==
                                    'share-group') {
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) => ShareGroup(
                                            selectedIndex:
                                                shareGroupSelected['id'],
                                            onItemSelected: (value) {
                                              setState(() {
                                                shareGroupSelected = value;
                                                renderShareType = 'group';
                                              });
                                            },
                                          ));
                                }
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, left: 10.0, bottom: 8),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08),
                                      child: Center(
                                        child: Icon(
                                          iconShareModal[index]['icon'],
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    alignment: Alignment.centerLeft,
                                    constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.1),
                                    child: Text(
                                      iconShareModal[index]['label'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  )
                ],
              ))),
    );
  }
}

class ShareGroup extends ConsumerStatefulWidget {
  final dynamic shareGroup;
  final Function? onItemSelected;
  final String? selectedIndex;
  const ShareGroup(
      {super.key, this.shareGroup, this.onItemSelected, this.selectedIndex});

  @override
  ConsumerState<ShareGroup> createState() => _ShareGroupState();
}

class _ShareGroupState extends ConsumerState<ShareGroup> {
  String selectedIndex = '';

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex ?? "";
  }

  @override
  Widget build(BuildContext context) {
    List shareGroup = ref.watch(shareControllerProvider).shareGroup;

    return Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(title: 'Nhóm'),
          centerTitle: true,
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: shareGroup.length,
            itemBuilder: (context, int index) {
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0.0),
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    leading: FittedBox(
                      child: ClipOval(
                        child: ExtendedImage.network(
                          shareGroup[index]['banner'] != null
                              ? shareGroup[index]['banner']['preview_url']
                              : linkBannerDefault,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(shareGroup[index]['title']),
                    trailing: selectedIndex == shareGroup[index]['id']
                        ? const Icon(FontAwesomeIcons.check,
                            size: 12, color: Colors.blue)
                        : null,
                    onTap: () {
                      widget.onItemSelected!(shareGroup[index]);
                      Navigator.of(context).pop();
                    },
                  ),
                  const Divider(
                    indent: 55,
                    thickness: 1,
                  ),
                ],
              );
            }));
  }
}

class SharePlace extends StatefulWidget {
  final dynamic meData;
  final String? shareModalSelected;
  final Function? onItemSelected;
  const SharePlace({
    super.key,
    this.onItemSelected,
    this.meData,
    this.shareModalSelected,
  });

  @override
  State<SharePlace> createState() => _SharePlaceState();
}

class _SharePlaceState extends State<SharePlace> {
  String selectedIndex = '';
  @override
  void initState() {
    super.initState();
    selectedIndex = shareAction.firstWhere(
        (element) => element['key'] == widget.shareModalSelected)['key'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(title: 'Chọn điểm đến'),
          centerTitle: true,
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: shareAction.length,
            itemBuilder: (context, int index) {
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0.0),
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    leading: shareAction[index]['icon'] != null
                        ? FittedBox(child: Icon(shareAction[index]['icon']))
                        : FittedBox(
                            child: ClipOval(
                                child: ExtendedImage.network(
                              widget.meData['avatar_media'] != null
                                  ? widget.meData['avatar_media']['preview_url']
                                  : widget.meData['avatar_static'],
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )),
                          ),
                    title: Text(shareAction[index]['label']),
                    trailing: selectedIndex == shareAction[index]['key']
                        ? const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Icon(
                              FontAwesomeIcons.check,
                              size: 12,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = shareAction[index]['key'];
                        Navigator.of(context).pop();
                        widget.onItemSelected!(shareAction[index]['key']);
                      });
                    },
                  ),
                  const Divider(
                    indent: 55,
                    thickness: 1,
                  ),
                ],
              );
            }));
  }
}

class ShareFriend extends ConsumerStatefulWidget {
  final dynamic shareFriend;
  final Function? onItemSelected;
  final String? selectedIndex;
  const ShareFriend(
      {super.key, this.shareFriend, this.onItemSelected, this.selectedIndex});

  @override
  ConsumerState<ShareFriend> createState() => _ShareFriendState();
}

class _ShareFriendState extends ConsumerState<ShareFriend> {
  String selectedIndex = '';
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex ?? '';
  }

  @override
  Widget build(BuildContext context) {
    List shareFriend = ref.watch(shareControllerProvider).shareFriend;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Dòng thời gian của bạn bè'),
        centerTitle: true,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: shareFriend.length,
        itemBuilder: (context, int index) {
          return Column(
            children: [
              ListTile(
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                leading: FittedBox(
                  child: ClipOval(
                    child: ExtendedImage.network(
                      shareFriend[index]['avatar_media'] != null
                          ? shareFriend[index]['avatar_media']['preview_url']
                          : linkAvatarDefault,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(shareFriend[index]['display_name']),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: selectedIndex == shareFriend[index]['id']
                      ? const Icon(FontAwesomeIcons.check,
                          size: 12, color: Colors.blue)
                      : null,
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = shareFriend[index]['id'];
                    Navigator.of(context).pop();
                    widget.onItemSelected!(shareFriend[index]);
                  });
                },
              ),
              const Divider(
                indent: 55,
                thickness: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
