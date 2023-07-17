import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_album.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_image.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_intro.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_noticeable.dart';
import 'package:social_network_app_mobile/screens/Group/GroupUpdate/crop_image.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/AvatarStack/avatar_stack.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';

import '../../../widgets/AvatarStack/positions.dart';

class HomeGroup extends ConsumerStatefulWidget {
  final dynamic groupDetail;
  final Function? onTap;

  const HomeGroup({
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
  File? url;
  late File image;
  final settings = RestrictedPositions(
    maxCoverage: 0.3,
    minCoverage: 0.2,
    laying: StackLaying.first,
  );

  @override
  void initState() {
    if (!mounted) return;
    super.initState();

    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          String maxId =
              ref.read(groupListControllerProvider).groupPost.last['id'];
          ref.read(groupListControllerProvider.notifier).getPostGroup({
            "sort_by": "new_post",
            "exclude_replies": true,
            "limit": 3,
            "max_id": maxId
          }, widget.groupDetail['id']);
        }
      },
    );
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
  void handlePress(value, context) {
    switch (value) {
      case 'intro':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupIntro(
              groupDetail: widget.groupDetail,
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
    String? fileName = '';
    setState(() {
      url = value;
    });

// Gửi api
  }

  @override
  Widget build(BuildContext context) {
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

    final size = MediaQuery.of(context).size; 
    return Scaffold(
      body: CustomScrollView(
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
                Positioned(
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
                      backgroundColor: Colors.transparent.withOpacity(0.5),
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
                ),
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' \u{2022} ${widget.groupDetail['member_count']} thành viên',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: AvatarStack(
                        height: 40,
                        borderColor: Theme.of(context).scaffoldBackgroundColor,
                        settings: settings,
                        iconEllipse: true,
                        avatars: [
                          for (var n = 0; n < avatarGroup.length; n++)
                            NetworkImage(
                              avatarGroup[n]['account']['avatar_media'] != null
                                  ? avatarGroup[n]['account']['avatar_media']
                                      ['preview_url']
                                  : linkAvatarDefault,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
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
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
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
                            isGrey: true,
                            handlePress: () {},
                          ),
                        ),
                      ],
                    ),
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
                    groupChip.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(
                          () {
                            menuSelected = groupChip[index]['key'];
                            handlePress(groupChip[index]['key'], context);
                          },
                        );
                      },
                      child: ChipMenu(
                        isSelected: menuSelected == groupChip[index]['key'],
                        label: groupChip[index]['label'],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                const CreatePostButton(),
                const Divider(
                  height: 20,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 5,
                ),
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
                          border: Border.all(width: 0.3, color: greyColor),
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
                            ),
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
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Post(
                  post: postGroup[index],
                );
              },
              childCount: postGroup.length,
            ),
          ),
        ],
      ),
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
