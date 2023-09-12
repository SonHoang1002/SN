import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/group_search.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/home_group.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/manager.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

import 'package:social_network_app_mobile/widgets/report_category.dart';

import 'package:social_network_app_mobile/widgets/skeleton.dart';

import '../../../apis/post_api.dart';
import '../../../widgets/back_icon_appbar.dart';
import '../../../widgets/screen_share.dart';
import '../../CreatePost/CreateNewFeed/create_new_feed.dart';

class GroupDetail extends ConsumerStatefulWidget {
  final String id;
  const GroupDetail({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends ConsumerState<GroupDetail> {
  dynamic groupDetail;
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        await ref
            .read(groupListControllerProvider.notifier)
            .getGroupDetail(widget.id)
            .then(
          (value) {
            setState(
              () {
                groupDetail = ref.read(groupListControllerProvider).groupDetail;
              },
            );
          },
        );
        ref
            .read(groupListControllerProvider.notifier)
            .getMemberQuestion(widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getGroupRole({'role': 'admin'}, widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getGroupRole({'role': 'moderator'}, widget.id);
        ref.read(groupListControllerProvider.notifier).getGroupRole(
            {'role': 'member', 'include_friend': true}, widget.id);
        ref.read(groupListControllerProvider.notifier).getGroupRole(
            {'role': 'member', 'exclude_friend': true}, widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getMediaImage({'media_type': 'image', 'limit': '10'}, widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getAlbum({'limit': '10'}, widget.id);
        ref.read(groupListControllerProvider.notifier).getPostGroup(
            {"sort_by": "new_post", "exclude_replies": true, "limit": 3},
            widget.id);
        ref.read(groupListControllerProvider.notifier).getGroupPins(widget.id);

        ref
            .read(groupListControllerProvider.notifier)
            .getJoinRequest(widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getPendingStatus(widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getReportedStatus(widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getStatusAlert(widget.id);
      },
    );
  }

  Widget bottomShetItem(
      {Function()? onTap, required IconData icon, required String title}) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).textTheme.displayLarge!.color,
        ),
        title: Text(title),
      ),
    );
  }

  void handleSearchInGroup(BuildContext context, dynamic groupDetail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tìm kiếm trong nhóm này'),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search', // Set your hintText
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.grey), // Add a search icon
                        filled: true,
                        fillColor: Colors.grey[300],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal:
                                8), // Adjust padding here // Set the background color
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Set border radius
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                buildTextContent("Bạn đang tìm gì à ?", true,
                    isCenterLeft: false),
                const SizedBox(
                  height: 10,
                ),
                buildTextContent(
                    "Tìm kiếm bài viết, bình luận hoặc thành viên trong ${groupDetail != null && groupDetail.isNotEmpty ? (groupDetail?['title']) : ''}.",
                    false,
                    isCenterLeft: false,
                    fontSize: 14),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge!.color),
                  )),
            ),
            TextButton(
              onPressed: () async {
                if (searchController.text.trim().isNotEmpty) {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SearchGroup(
                            groupDetail: groupDetail,
                            query: searchController.text),
                      ));
                }
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryColor,
                  ),
                  child: Text(
                    'Tìm kiếm',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge!.color),
                  )),
            ),
          ],
        );
      },
    );
  }

  void showShareBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5),
              margin: const EdgeInsets.only(bottom: 15),
              child: Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              ),
            ),
            bottomShetItem(
                onTap: () async {
                  Navigator.pop(context);
                  final response = await PostApi().createStatus({
                    "visibility": "public",
                    "extra_body": {},
                    "life_event": null,
                    "poll": null,
                    "mention_ids": null,
                    "reblog_of_id": null,
                    "post_type": null,
                    "status": "",
                    "shared_group_id": widget.id
                  });
                  if (response != null && response?["error"] == null) {
                    ScaffoldMessenger.of(_drawerscaffoldkey.currentContext!)
                        .showSnackBar(const SnackBar(
                      content: Text(
                        'Đã chia sẻ lên trang cá nhân của bạn',
                        style: TextStyle(color: Colors.green),
                      ),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    ScaffoldMessenger.of(_drawerscaffoldkey.currentContext!)
                        .showSnackBar(const SnackBar(
                      content: Text(
                        'Có lỗi xảy ra',
                        style: TextStyle(color: Colors.red),
                      ),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                icon: FontAwesomeIcons.share,
                title: "Chia sẻ ngay"),
            bottomShetItem(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: ((context) => CreateNewFeed(
                                sharedGroupId: groupDetail["id"],
                              ))));
                },
                icon: FontAwesomeIcons.penToSquare,
                title: "Chia sẻ lên bảng tin"),
            bottomShetItem(
                onTap: () {
                  Navigator.pop(context);
                  showBarModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ScreenShare(
                            type: "",
                            entityType: 'post',
                            sharedGroupId: groupDetail["id"],
                          ));
                },
                icon: FontAwesomeIcons.shareNodes,
                title: "Chia sẻ khác"),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    groupDetail = ref.watch(groupListControllerProvider).groupDetail;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: groupDetail != null && groupDetail.isNotEmpty
              ? (groupDetail?['title'])
              : '',
        ),
        leading: const BackIconAppbar(
          isGroup: true,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            height: 4,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                          ),
                        ),
                        bottomShetItem(
                            onTap: () {
                              handleSearchInGroup(context, groupDetail);
                            },
                            icon: FontAwesomeIcons.search,
                            title: "Tìm kiếm"),
                        bottomShetItem(
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 5),
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Container(
                                          height: 4,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15))),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          leading: Icon(
                                            FontAwesomeIcons.film,
                                            color: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .color,
                                          ),
                                          title: const Text("Khoảnh khắc"),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: ListTile(
                                          leading: Icon(
                                            FontAwesomeIcons.usersRectangle,
                                            color: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .color,
                                          ),
                                          title: const Text("Nhật ký(Story)"),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: FontAwesomeIcons.circlePlus,
                            title: "Thêm mới"),
                        bottomShetItem(
                            onTap: () {
                              Navigator.pop(context);
                              showShareBottomSheet();
                            },
                            icon: FontAwesomeIcons.shareFromSquare,
                            title: "Chia sẻ"),
                        bottomShetItem(
                            onTap: () {
                              Navigator.pop(context);
                              showBarModalBottomSheet(
                                  context: context,
                                  builder: (context) => ReportCategory(
                                      entityType: 'group',
                                      entityReport: groupDetail["id"]));
                            },
                            icon: FontAwesomeIcons.triangleExclamation,
                            title: "Báo cáo nhóm"),
                        bottomShetItem(
                            onTap: () async {
                              await showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: const Text('Rời khỏi nhóm ?'),
                                  content: const Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'Bạn có muốn rời khỏi Nhóm test không ? Bạn cũng có thể tắt thông báo cho bài viết mới hoặc báo cáo nhóm này',
                                          style: TextStyle(
                                              fontSize: 13, color: blackColor)),
                                    ],
                                  ),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Huỷ'),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await GroupApi().removeGroupRequest(
                                            groupDetail["id"]);
                                        ref
                                            .read(groupListControllerProvider
                                                .notifier)
                                            .getPostGroup({
                                          "sort_by": "new_post",
                                          "exclude_replies": true,
                                          "limit": 3,
                                        }, groupDetail?["id"]);
                                        ref
                                            .read(groupListControllerProvider
                                                .notifier)
                                            .getGroupDetail(groupDetail["id"]);
                                        if (mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Rời khỏi nhóm'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: FontAwesomeIcons.arrowRightFromBracket,
                            title: "Rời khỏi nhóm"),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                FontAwesomeIcons.bars,
                color: Theme.of(context).textTheme.displayLarge!.color,
                size: 18,
              ))
        ],
      ),
      body: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        key: _drawerscaffoldkey,
        endDrawer: groupDetail != null && groupDetail.isNotEmpty
            ? SafeArea(
                child: ManagerDetail(
                  groupDetail: groupDetail,
                ),
              )
            : buildCircularProgressIndicator(),
        body: groupDetail != null && groupDetail.isNotEmpty
            ? HomeGroup(
                groupDetail: groupDetail,
                onTap: () {
                  _drawerscaffoldkey.currentState!.openEndDrawer();
                },
              )
            : SkeletonCustom().groupSkeleton(context),
      ),
    );
  }
}
