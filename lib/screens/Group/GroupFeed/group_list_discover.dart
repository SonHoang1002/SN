import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';

class GroupListDiscover extends ConsumerStatefulWidget {
  const GroupListDiscover({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupListDiscover> createState() => _GroupListDiscoverState();
}

class _GroupListDiscoverState extends ConsumerState<GroupListDiscover> {
  @override
  Widget build(BuildContext context) {
    List groupFriend = ref.watch(groupListControllerProvider).groupDiscover;
    List groupOther = ref.watch(groupListControllerProvider).groupOther;

    TextStyle style =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhóm bạn bè tham gia',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: groupFriend.length,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10.0),
                        child: GroupItemInkwell(
                          group: groupFriend[index],
                        ),
                      )),
              Text(
                'Gợi ý khác cho bạn',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: groupOther.length,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10.0),
                        child: GroupItemInkwell(
                          group: groupOther[index],
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

class GroupItemInkwell extends StatelessWidget {
  final dynamic group;
  const GroupItemInkwell({
    super.key,
    this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GroupItem(
            group: group,
          ),
          ButtonPrimary(
            label: "Tham gia",
            isPrimary: false,
            handlePress: () {},
          )
        ],
      ),
    );
  }
}
