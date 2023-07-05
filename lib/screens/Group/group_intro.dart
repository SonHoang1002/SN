import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/widgets/AvatarStack/src/avatar_stack.dart';

import '../../widgets/AvatarStack/src/positions/positions.dart';
import '../../widgets/AvatarStack/src/positions/restricted_positions.dart';

class GroupIntro extends ConsumerStatefulWidget {
  final dynamic groupDetail;
  const GroupIntro({super.key, this.groupDetail});

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
        ref.watch(groupListControllerProvider).groupRoleMember ?? [];
    List groupFriend =
        ref.watch(groupListControllerProvider).groupRoleFriend ?? [];
    List groupMorderator =
        ref.watch(groupListControllerProvider).groupRoleMorderator ?? [];
    List groupAdmin =
        ref.watch(groupListControllerProvider).groupRoleAdmin ?? [];
    List avatarMember = mergeAndFilter(
        [...groupMorderator, ...groupAdmin], [...groupMember, ...groupFriend]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Group Intro'),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thành viên',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            AvatarStack(
              height: 40,
              borderColor: Theme.of(context).scaffoldBackgroundColor,
              settings: settings,
              avatars: [
                for (var n = 0; n < avatarMember.length; n++)
                  NetworkImage(
                    avatarMember[n]['account']['avatar_media']['preview_url'] ??
                        linkAvatarDefault,
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
            AvatarStack(
              height: 40,
              borderColor: Theme.of(context).scaffoldBackgroundColor,
              settings: setting,
              avatars: [
                for (var m = 0; m < groupAdmin.length; m++)
                  NetworkImage(
                    groupAdmin[m]['account']['avatar_media']['preview_url'] ??
                        linkAvatarDefault,
                  ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              groupAdmin.length > 3
                  ? '${groupAdmin[0]['account']['display_name']}, ${groupAdmin[1]['account']['display_name']} và ${groupAdmin.length - 2} người khác là quản trị viên'
                  : groupAdmin.length == 2
                      ? '${groupAdmin[0]['account']['display_name']} và ${groupAdmin[1]['account']['display_name']} là quản trị viên'
                      : '${groupAdmin[0]['account']['display_name']} là quản trị viên',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(
              thickness: 1,
              height: 20,
            ),
            const Text(
              'Hoạt động trong nhóm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
