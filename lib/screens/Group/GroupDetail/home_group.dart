import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart' as POST_TYPE;
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/group_member_questions.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_album.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_image.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_intro.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_noticeable.dart';
import 'package:social_network_app_mobile/screens/Group/GroupUpdate/crop_image.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/AvatarStack/avatar_stack.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';

import '../../../widgets/AvatarStack/positions.dart';

class HomeGroup extends ConsumerStatefulWidget {
  dynamic groupDetail;
  final Function? onTap;

  HomeGroup({
    Key? key,
    this.onTap,
    this.groupDetail,
  }) : super(key: key);

  @override
  ConsumerState<HomeGroup> createState() => _HomeGroupState();
}

class _HomeGroupState extends ConsumerState<HomeGroup> {
  final scrollController = ScrollController();
  String menuSelected = '';
  bool isLoading = false;
  File? url;
  bool seeMore = false;
  late File image;
  List chip = [];

  final settings = RestrictedPositions(
    maxCoverage: 0.3,
    minCoverage: 0.2,
    laying: StackLaying.first,
  );

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    chip = checkVisible() ? groupChip : groupChipNotParticipate;
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            !isLoading &&
            ref.read(groupListControllerProvider).groupPost.isNotEmpty) {
          setState(() {
            isLoading = true;
            seeMore = true;
          });
          String maxId =
              ref.read(groupListControllerProvider).groupPost.last['id'];
          ref.read(groupListControllerProvider.notifier).getPostGroup({
            "sort_by": "new_post",
            "exclude_replies": true,
            "limit": 3,
            "max_id": maxId
          }, widget.groupDetail['id']);
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                seeMore = false;
                isLoading = false;
              });
            }
          });
        }
      },
    );

    Future.delayed(Duration.zero, () async {});
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  List groupChip = [
    {
      'key': 'intro',
      'label': 'Giới thiệu',
    },
    {
      'key': 'noticeable',
      'label': 'Đáng chú ý',
    },
    {
      'key': 'image',
      'label': 'Ảnh',
    },
    {
      'key': 'event',
      'label': 'Sự kiện',
    },
    {
      'key': 'album',
      'label': 'Album',
    },
  ];

  List groupChipNotParticipate = [
    {
      'key': 'noticeable',
      'label': 'Đáng chú ý',
    },
    {
      'key': 'image',
      'label': 'Ảnh',
    },
    {
      'key': 'event',
      'label': 'Sự kiện',
    },
    {
      'key': 'album',
      'label': 'Album',
    },
  ];
  void handlePress(value, context) {
    switch (value) {
      case 'intro':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupIntro(
              groupDetail: widget.groupDetail,
              join: true,
            ),
          ),
        );
        break;
      case 'noticeable':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupNoticeable(
              data: ref.read(groupListControllerProvider).groupPins,
            ),
          ),
        );
        break;
      case 'image':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupImage(
              data: ref.read(groupListControllerProvider).groupImage,
            ),
          ),
        );
        break;
      case 'event':
        break;
      case 'album':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupAlbum(
              data: ref.read(groupListControllerProvider).groupAlbum,
            ),
          ),
        );
        break;
    }
  }

  Widget buildIntroBody(BuildContext context) {
    return GroupIntro(
      groupDetail: widget.groupDetail,
      join: false,
    );
  }

  List mergeAndFilter(List list1, List list2) {
    Set<dynamic> ids = <dynamic>{};
    List mergedList = [];

    void addUniqueElements(List list) {
      for (var element in list) {
        if (!ids.contains(element['account']['id'])) {
          mergedList.add(element);
          ids.add(element['account']['id']);
        }
      }
    }

    addUniqueElements(list1);
    addUniqueElements(list2);

    return mergedList;
  }

  void handleGetBanner(value) async {
    setState(() {
      url = value;
    });

// Gửi api
  }

  @override
  Widget build(BuildContext context) {
    widget.groupDetail = ref.read(groupListControllerProvider).groupDetail;
    List postGroup = ref.watch(groupListControllerProvider).groupPost;
    List groupPins = ref.watch(groupListControllerProvider).groupPins;
    List groupMember = ref.watch(groupListControllerProvider).groupRoleMember;
    List groupFriend = ref.watch(groupListControllerProvider).groupRoleFriend;
    List groupMorderator =
        ref.watch(groupListControllerProvider).groupRoleMorderator;
    List groupAdmin = ref.watch(groupListControllerProvider).groupRoleAdmin;

    List avatarGroup = mergeAndFilter(
      mergeAndFilter(groupMorderator, groupAdmin),
      mergeAndFilter(groupMember, groupFriend),
    );
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(groupListControllerProvider.notifier).getPostGroup({
            "sort_by": "new_post",
            "exclude_replies": true,
            "limit": 3,
          }, widget.groupDetail?["id"]);
          await ref
              .read(groupListControllerProvider.notifier)
              .getGroupDetail(widget.groupDetail["id"]);
        },
        child: CustomScrollView(
          shrinkWrap: true,
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.25,
                    child: url != null
                        ? Image.file(url!, fit: BoxFit.cover)
                        : ExtendedImage.network(
                            widget.groupDetail['banner'] != null
                                ? (widget.groupDetail?['banner']
                                        ?['preview_url']) ??
                                    (widget.groupDetail?['banner']?['url'])
                                : linkBannerDefault,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                  ),
                  widget.groupDetail?['group_relationship']?['admin']
                      //  || widget.groupDetail?['group_relationship']?['moderator']
                      ? Positioned(
                          right: 10,
                          bottom: 0,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showBarModalBottomSheet(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 200,
                                  child: EditBannerGroup(
                                    handleGetBanner: handleGetBanner,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 30),
                              elevation: 0,
                              backgroundColor:
                                  Colors.transparent.withOpacity(0.5),
                              shadowColor: Colors.transparent.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Chỉnh sửa',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.groupDetail['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: 1.0,
                                  right: 5.0,
                                ),
                                child: Icon(
                                  Icons.lock,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: widget.groupDetail['is_private'] == true
                                  ? 'Nhóm Riêng tư'
                                  : 'Nhóm Công khai',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' \u{2022} ${widget.groupDetail['member_count']} thành viên',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: AvatarStack(
                      //     height: 40,
                      //     borderColor:
                      //         Theme.of(context).scaffoldBackgroundColor,
                      //     settings: settings,
                      //     iconEllipse: true,
                      //     avatars: [
                      //       for (var n = 0; n < avatarGroup.length; n++)
                      //         NetworkImage(
                      //           avatarGroup[n]['account']['avatar_media'] !=
                      //                   null
                      //               ? avatarGroup[n]['account']['avatar_media']
                      //                   ['preview_url']
                      //               : linkAvatarDefault,
                      //         ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildButtonActionGroup()
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 8.0,
                  ),
                  child: Row(
                    children: List.generate(
                      checkVisible()
                          ? chip.length
                          : groupChipNotParticipate.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(
                            () {
                              menuSelected = chip[index]['key'];
                              handlePress(chip[index]['key'], context);
                            },
                          );
                        },
                        child: ChipMenu(
                          isSelected: menuSelected == chip[index]['key'],
                          label: chip[index]['label'],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            checkVisible()
                ? SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (widget.groupDetail?['group_relationship']?['admin'] ||
                                widget.groupDetail?['group_relationship']
                                    ?['moderator'] ||
                                widget.groupDetail?['group_relationship']
                                    ?['member'])
                            ? Column(
                                children: [
                                  const Divider(
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  CreatePostButton(
                                    isInGroup: true,
                                    groupId: widget.groupDetail?["id"],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              child: Text(
                                'Đáng chú ý',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  groupPins.length,
                                  (index) => Container(
                                    width: size.width * 0.85,
                                    height: size.height * 0.62,
                                    margin: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      bottom: 7.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.3, color: greyColor),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ClipRect(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        heightFactor: 1.0,
                                        widthFactor: 1.0,
                                        child: Post(
                                            type: postPageUser,
                                            isHiddenCrossbar: true,
                                            isHiddenFooter: true,
                                            post: groupPins[index],
                                            groupData: widget.groupDetail,
                                            isInGroup: true,
                                            haveSuggest: false),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 20,
                              thickness: 2,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Text(
                            'Bài viết',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 2,
                        ),
                      ],
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Container(
                      child: buildIntroBody(context),
                    ),
                  ),
            checkVisible()
                ? postGroup.isEmpty
                    ? SliverToBoxAdapter(
                        child: isLoading
                            ? buildTextContent("Chưa có bài viết nào", false,
                                fontSize: 14, isCenterLeft: false)
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, i) {
                                  return Center(
                                    child:
                                        SkeletonCustom().postSkeleton(context),
                                  );
                                }),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Post(
                              type: POST_TYPE.postGroup,
                              post: postGroup[index],
                              haveSuggest: false,
                              isInGroup: true,
                              groupData: widget.groupDetail,
                            );
                          },
                          childCount: postGroup.length,
                        ),
                      )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return const Text(
                          "Đây là nhóm riêng tư bạn cần tham gia để theo dõi các bài viết");
                    },
                    childCount: 0,
                  )),
            SliverToBoxAdapter(
                child: isLoading
                    ? seeMore
                        ? checkVisible()
                            ? SkeletonCustom().postSkeleton(context)
                            : const SizedBox()
                        : const SizedBox()
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }

  bool checkVisible() {
    // hiện bài viết trong nhóm
    // trường hợp nhóm công khai
    // trường hợp nhóm private và nguowif dungf là (admin ||  member || moder)
    if ((widget.groupDetail?['is_private']) == false &&
        (widget.groupDetail?['is_visible'])) {
      return true;
    } else if ((widget.groupDetail?['is_private']) &&
        (widget.groupDetail?['is_visible']) &&
        (widget.groupDetail?['group_relationship']?['admin'] ||
            widget.groupDetail?['group_relationship']?['moderator'] ||
            widget.groupDetail?['group_relationship']?['member'])) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildButtonActionGroup() {
    final size = MediaQuery.sizeOf(context);
    //   "group_relationship": {
    //   "member": false,
    //   "admin": false,
    //   "moderator": false,
    //   "requested": false,
    //   "invited": false,
    //   "follow": false,
    //   "admin_invitation": false,
    //   "moderator_invitation": false
    // },
    // (1) nút quản lý: admin, moderator
    // (2) nút tham gia: không là admin, moder, member, chưa gửi lời mời tham gia nhóm, chưa đc mời tham gia nhóm
    // (3) nút xác nhận tham gia: khi nhận được lời mời
    // (4) nút hủy thma gia: khi đã gửi lời mời tham gia nhóm
    // (5) nút mời : khi là admin, moder, member

    List listButtons = [const SizedBox(), const SizedBox()];
    //(1)
    if (widget.groupDetail?['group_relationship']?['admin'] ||
        widget.groupDetail?['group_relationship']?['moderator']) {
      listButtons[0] = (SizedBox(
        width: size.width * 0.45,
        child: ButtonPrimary(
          label: 'Quản lý',
          icon: Image.asset(
            'assets/groups/managerGroup.png',
            width: 16,
            height: 16,
          ),
          handlePress: () {
            widget.onTap!();
          },
        ),
      ));
      listButtons[1] = (SizedBox(
        width: size.width * 0.445,
        child: ButtonPrimary(
          label: 'Mời',
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Image.asset(
              'assets/groups/group.png',
              width: 16,
              height: 16,
            ),
          ),
          handlePress: () {
            showBarModalBottomSheet(
                context: context,
                builder: (context) =>
                    InviteFriend(id: widget.groupDetail['id'], type: 'group'));
          },
        ),
      ));
    }
    //(2)
    else if ((!widget.groupDetail?['group_relationship']?['member']) &&
        (!widget.groupDetail?['group_relationship']?['moderator']) &&
        (!widget.groupDetail?['group_relationship']?['admin']) &&
        (!widget.groupDetail?['group_relationship']?['requested']) &&
        (!widget.groupDetail?['group_relationship']?['invited'])) {
      listButtons[0] = (SizedBox(
        width: size.width * 0.895,
        child: ButtonPrimary(
          label: 'Tham gia nhóm',
          handlePress: () async {
            List<dynamic> listQuestions =
                ref.read(groupListControllerProvider).memberQuestionList;
            if (listQuestions.isNotEmpty) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => GroupMemberQuestions(
                          groupDetail: widget.groupDetail)));
            } else {
              await GroupApi().joinGroupRequest(widget.groupDetail["id"]);
              ref.read(groupListControllerProvider.notifier).getPostGroup({
                "sort_by": "new_post",
                "exclude_replies": true,
                "limit": 3,
              }, widget.groupDetail?["id"]);
              await ref
                  .read(groupListControllerProvider.notifier)
                  .getGroupDetail(widget.groupDetail["id"]);
            }
          },
        ),
      ));
      listButtons[1] = (const SizedBox());
    }
    //(3)
    else if (widget.groupDetail?['group_relationship']?['invited']) {
      listButtons[0] = (SizedBox(
        width: size.width * 0.44,
        child: ButtonPrimary(
          label: 'Xác nhận',
          handlePress: () {
            //widget.onTap!();
          },
        ),
      ));
      listButtons[1] = (const SizedBox());
    }
    //(4)
    else if (widget.groupDetail?['group_relationship']?['requested']) {
      listButtons[0] = (SizedBox(
        width: size.width * 0.45,
        child: ButtonPrimary(
          label: 'Hủy lời mời',
          handlePress: () async {
            //widget.onTap!();
            GroupApi().removeGroupRequest(widget.groupDetail["id"]);
            setState(() {
              widget.groupDetail?['group_relationship']?['requested'] = false;
            });
          },
        ),
      ));
      listButtons[1] = (const SizedBox());
    }
    //(5)
    else if (widget.groupDetail?['group_relationship']?['invited']) {
      listButtons[0] = (SizedBox(
        width: size.width * 0.45,
        child: ButtonPrimary(
          label: 'Xác nhận',
          handlePress: () {
            widget.onTap!();
          },
        ),
      ));
      listButtons[1] = (const SizedBox());
    }
    //(6)
    else if (widget.groupDetail?['group_relationship']?['member']) {
      listButtons[0] = (SizedBox(
        width: size.width * 0.45,
        child: ButtonPrimary(
          label: 'Đã tham gia',
          handlePress: () async {
            //widget.onTap!();
            await showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Rời khỏi nhóm ?'),
                content: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        'Bạn có muốn rời khỏi ${widget.groupDetail?['title'] ?? "nhóm"} không ? Bạn cũng có thể tắt thông báo cho bài viết mới hoặc báo cáo nhóm này',
                        style:
                            const TextStyle(fontSize: 13, color: blackColor)),
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
                      await GroupApi()
                          .removeGroupRequest(widget.groupDetail["id"]);
                      ref
                          .read(groupListControllerProvider.notifier)
                          .getPostGroup({
                        "sort_by": "new_post",
                        "exclude_replies": true,
                        "limit": 3,
                      }, widget.groupDetail?["id"]);
                      ref
                          .read(groupListControllerProvider.notifier)
                          .getGroupDetail(widget.groupDetail["id"]);
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
        ),
      ));
      listButtons[1] = ((SizedBox(
        width: size.width * 0.45,
        child: ButtonPrimary(
          label: 'Mời',
          handlePress: () {
            //widget.onTap!();
            showBarModalBottomSheet(
                context: context,
                builder: (context) =>
                    InviteFriend(id: widget.groupDetail['id'], type: 'group'));
          },
        ),
      )));
    }

    return Row(
      children: [
        listButtons[0],
        const SizedBox(
          width: 8,
        ),
        listButtons[1],
      ],
    );
  }
}

class EditBannerGroup extends StatefulWidget {
  final Function(dynamic) handleGetBanner;

  const EditBannerGroup({
    Key? key,
    required this.handleGetBanner,
  }) : super(key: key);

  @override
  State<EditBannerGroup> createState() => _EditBannerGroupState();
}

class _EditBannerGroupState extends State<EditBannerGroup> {
  late File image;
  File uint8ListToFile(Uint8List data, String fileName) {
    File file = File(fileName);
    file.writeAsBytesSync(data, mode: FileMode.write);
    return file;
  }

  void handleGetImage(value) {
    if (value != null) {
      widget.handleGetBanner(uint8ListToFile(value, image.path));
    }
  }

  void openEditor() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
    final Uint8List imageData = await image.readAsBytes();
    // ignore: use_build_context_synchronously
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CropUpdateBanner(
          image: imageData,
          handleGetImage: handleGetImage,
        ),
      ),
    );
  }

  List updateBannerGroup = [
    {
      'key': 'upload',
      'label': 'Tải ảnh lên',
      'icon': 'assets/groups/upload.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return ListView.builder(
          itemCount: updateBannerGroup.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                minLeadingWidth: 20,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 0.0,
                ),
                visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
                leading: Image.asset(
                  updateBannerGroup[index]['icon'],
                  width: 18,
                  height: 18,
                ),
                title: Text(
                  updateBannerGroup[index]['label'],
                ),
                onTap: () {
                  openEditor();
                },
              ),
            );
          },
        );
      },
    );
  }
}
