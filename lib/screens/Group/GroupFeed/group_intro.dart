import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_role.dart';
import 'package:social_network_app_mobile/widgets/AvatarStack/src/avatar_stack.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

import '../../../widgets/AvatarStack/positions.dart';

class GroupIntro extends ConsumerStatefulWidget {
  bool? join = true;
  final dynamic groupDetail;
  GroupIntro({super.key, this.groupDetail, this.join});

  @override
  ConsumerState<GroupIntro> createState() => _GroupIntroState();
}

class _GroupIntroState extends ConsumerState<GroupIntro> {
  List<dynamic> groupIntro = [];
  @override
  void initState() {
    super.initState();
    groupIntro = [
      {
        'icon': 'assets/groups/privacy.png',
        'title':
            widget.groupDetail['is_private'] == true ? 'Riêng tư' : 'Công khai',
        'subTitle':
            'Chỉ thành viên mới nhìn thấy mọi người trong nhóm và những gì họ đăng.'
      },
      {
        'icon': 'assets/groups/hidden.png',
        'title': widget.groupDetail['is_visible'] == true ? 'Hiện' : 'Ẩn',
        'subTitle': 'Chỉ thành viên mới nhìn thấy nhóm này'
      },
      {
        'icon': 'assets/groups/history.png',
        'title': 'Lịch sử',
        'subTitle': widget.groupDetail['created_at']
      },
    ];
  }

  final settings = RestrictedPositions(
    maxCoverage: 0.3,
    minCoverage: 0.2,
    laying: StackLaying.first,
  );
  final setting = RestrictedPositions(
    maxCoverage: 0.3,
    minCoverage: 0.2,
    laying: StackLaying.first,
  );
  List mergeAndFilter(List list1, List list2) {
    List mergedList = [];
    for (var item2 in list2) {
      var id2 = item2['account']['id'];
      var isDuplicate = false;
      for (var item1 in list1) {
        var id1 = item1['account']['id'];
        if (id1 == id2) {
          isDuplicate = true;
          break;
        }
      }
      if (!isDuplicate) {
        mergedList.add(item2);
      }
    }
    return mergedList;
  }

  @override
  Widget build(BuildContext context) {
    List groupMember =
        ref.watch(groupListControllerProvider).groupRoleMember.isNotEmpty
            ? ref.watch(groupListControllerProvider).groupRoleMember
            : [];
    List groupFriend =
        ref.watch(groupListControllerProvider).groupRoleFriend.isNotEmpty
            ? ref.watch(groupListControllerProvider).groupRoleFriend
            : [];
    List groupMorderator =
        ref.watch(groupListControllerProvider).groupRoleMorderator.isNotEmpty
            ? ref.watch(groupListControllerProvider).groupRoleMorderator
            : [];
    List groupAdmin =
        ref.watch(groupListControllerProvider).groupRoleAdmin.isNotEmpty
            ? ref.watch(groupListControllerProvider).groupRoleAdmin
            : [];
    List avatarMember = mergeAndFilter(
        [...groupMorderator, ...groupAdmin], [...groupMember, ...groupFriend]);
    List avatarAdmin = [...groupMorderator, ...groupAdmin];
    List avatarFriend = [...[], ...groupFriend];
    List avatarNoFriend = [...groupMember, ...[]];
    return widget.join == true
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: AppBarTitle(title: widget.groupDetail['title']),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giới thiệu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Thêm mô tả'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: groupIntro.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        minLeadingWidth: 30,
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0.0),
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: 0),
                        leading: Image.asset(
                          groupIntro[index]['icon'],
                          width: 22,
                          height: 22,
                        ),
                        title: Text(
                          groupIntro[index]['title'],
                        ),
                        subtitle: Text(
                          groupIntro[index]['subTitle'],
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 1,
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thành viên',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(
                            builder: (context) {
                              return GroupRole(
                                groupMember: avatarNoFriend,
                                groupFriend: avatarFriend,
                                groupAdmin: avatarAdmin,
                              );
                            },
                          ));
                        },
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  avatarMember.isNotEmpty
                      ? Column(
                          children: [
                            AvatarStack(
                              height: 40,
                              borderColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              settings: settings,
                              avatars: [
                                for (var n = 0; n < avatarMember.length; n++)
                                  NetworkImage(
                                    avatarMember[n]['account']
                                                ['avatar_media'] !=
                                            null
                                        ? avatarMember[n]['account']
                                            ['avatar_media']['preview_url']
                                        : linkAvatarDefault,
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              avatarMember.length >= 3
                                  ? '${avatarMember[0]['account']['display_name']}, ${avatarMember[1]['account']['display_name']} và ${avatarMember.length - 2} người bạn khác đã tham gia'
                                  : avatarMember.length == 2
                                      ? '${avatarMember[0]['account']['display_name']} và ${avatarMember[1]['account']['display_name']} đã tham gia'
                                      : '${avatarMember[0]['account']['display_name']} đã tham gia',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  AvatarStack(
                    height: 40,
                    borderColor: Theme.of(context).scaffoldBackgroundColor,
                    settings: setting,
                    avatars: [
                      for (var m = 0; m < avatarAdmin.length; m++)
                        NetworkImage(
                          avatarAdmin[m]['account']['avatar_media'] != null
                              ? avatarAdmin[m]['account']['avatar_media']
                                  ['preview_url']
                              : linkAvatarDefault,
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    avatarAdmin.length > 3
                        ? '${avatarAdmin[0]['account']['display_name']}, ${avatarAdmin[1]['account']['display_name']} và ${avatarAdmin.length - 2} người khác là quản trị viên'
                        : avatarAdmin.length == 2
                            ? '${avatarAdmin[0]['account']['display_name']} và ${avatarAdmin[1]['account']['display_name']} là quản trị viên'
                            : '${avatarAdmin[0]['account']['display_name']} là quản trị viên',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Giới thiệu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(widget.groupDetail["description"]), //Giới thiệu
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: groupIntro.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      minLeadingWidth: 30,
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: 0),
                      leading: Image.asset(
                        groupIntro[index]['icon'],
                        width: 22,
                        height: 22,
                      ),
                      title: Text(
                        groupIntro[index]['title'],
                      ),
                      subtitle: Text(
                        groupIntro[index]['subTitle'],
                      ),
                    );
                  },
                ),
                const Divider(
                  thickness: 1,
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thành viên',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) {
                            return GroupRole(
                              groupMember: avatarNoFriend,
                              groupFriend: avatarFriend,
                              groupAdmin: avatarAdmin,
                            );
                          },
                        ));
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                avatarMember.isNotEmpty
                    ? Column(
                        children: [
                          AvatarStack(
                            height: 40,
                            borderColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            settings: settings,
                            avatars: [
                              for (var n = 0; n < avatarMember.length; n++)
                                NetworkImage(
                                  avatarMember[n]['account']['avatar_media'] !=
                                          null
                                      ? avatarMember[n]['account']
                                          ['avatar_media']['preview_url']
                                      : linkAvatarDefault,
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            avatarMember.length >= 3
                                ? '${avatarMember[0]['account']['display_name']}, ${avatarMember[1]['account']['display_name']} và ${avatarMember.length - 2} người bạn khác đã tham gia'
                                : avatarMember.length == 2
                                    ? '${avatarMember[0]['account']['display_name']} và ${avatarMember[1]['account']['display_name']} đã tham gia'
                                    : '${avatarMember[0]['account']['display_name']} đã tham gia',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : const SizedBox(),
                AvatarStack(
                  height: 40,
                  borderColor: Theme.of(context).scaffoldBackgroundColor,
                  settings: setting,
                  avatars: [
                    for (var m = 0; m < avatarAdmin.length; m++)
                      NetworkImage(
                        avatarAdmin[m]['account']['avatar_media'] != null
                            ? avatarAdmin[m]['account']['avatar_media']
                                ['preview_url']
                            : linkAvatarDefault,
                      ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                avatarAdmin.isEmpty
                    ? Container()
                    : Text(
                        avatarAdmin.length > 3
                            ? '${avatarAdmin[0]['account']['display_name']}, ${avatarAdmin[1]['account']['display_name']} và ${avatarAdmin.length - 2} người khác là quản trị viên'
                            : avatarAdmin.length == 2
                                ? '${avatarAdmin[0]['account']['display_name']} và ${avatarAdmin[1]['account']['display_name']} là quản trị viên'
                                : '${avatarAdmin[0]?['account']?['display_name']} là quản trị viên',
                        style: const TextStyle(color: Colors.grey),
                      ),
              ],
            ),
          );
  }
}
