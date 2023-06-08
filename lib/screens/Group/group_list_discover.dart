import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/groups.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';

class GroupListDiscover extends StatelessWidget {
  const GroupListDiscover({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
