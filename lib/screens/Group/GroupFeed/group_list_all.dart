import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/group_detail.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';

class GroupListAll extends ConsumerWidget {
  const GroupListAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle style =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
    List groupAdmin = ref.watch(groupListControllerProvider).groupAdmin;
    List groupMember = ref.watch(groupListControllerProvider).groupMember;

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhóm bạn quản lý',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              groupAdmin.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: groupAdmin.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              pushCustomCupertinoPageRoute(
                                  context,
                                  GroupDetail(
                                    id: groupAdmin[index]['id'],
                                  ));
                            },
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              margin: const EdgeInsets.all(6.0),
                              child: GroupItem(
                                group: groupAdmin[index],
                              ),
                            ),
                          ))
                  : Container(
                      margin: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            "Hãy trở thành quản trị viên hoặc người kiểm duyệt để xem tại đây nhé",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                              height: 35,
                              width: 100,
                              child: ButtonPrimary(
                                label: "Tạo nhóm",
                                handlePress: () {},
                              ))
                        ],
                      ),
                    ),
              Text(
                'Nhóm bạn đã tham gia',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: groupMember.length,
                  itemBuilder: (context, indexMember) => InkWell(
                        onTap: () {
                          pushCustomCupertinoPageRoute(
                              context,
                              GroupDetail(
                                id: groupMember[indexMember]['id'],
                              ));
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          margin: const EdgeInsets.all(6.0),
                          child: GroupItem(
                            group: groupMember[indexMember],
                          ),
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
