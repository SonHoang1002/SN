import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/Group/group_invited_request.dart';
import 'package:social_network_app_mobile/screen/Group/group_list_all.dart';
import 'package:social_network_app_mobile/screen/Group/group_list_discover.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

import 'group_feed_all.dart';

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  String menuSelected = "group-feed";

  @override
  Widget build(BuildContext context) {
    List menuGroup = [
      {
        "key": "group-feed",
        "label": "Bảng tin",
        "icon": FontAwesomeIcons.newspaper
      },
      {
        "key": "your-group",
        "label": "Nhóm của bạn",
        "icon": FontAwesomeIcons.users
      },
      {
        "key": "group-dicover",
        "label": "Khám phá nhóm",
        "icon": FontAwesomeIcons.layerGroup
      },
      {
        "key": "group-request",
        "label": "Lời mời & Yêu cầu",
        "icon": FontAwesomeIcons.codePullRequest
      },
    ];

    handlePress(String key) {
      setState(() {
        menuSelected = key;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                menuGroup.length,
                (index) => GestureDetector(
                      onTap: () => handlePress(menuGroup[index]['key']),
                      child: ChipMenu(
                        isSelected: menuSelected == menuGroup[index]['key'],
                        label: menuGroup[index]['label'],
                        icon: Icon(
                          menuGroup[index]['icon'],
                          size: 16,
                        ),
                      ),
                    )),
          ),
        ),
        const CrossBar(),
        if (menuSelected == 'your-group')
          const GroupListAll()
        else if (menuSelected == 'group-dicover')
          const GroupListDiscover()
        else if (menuSelected == 'group-request')
          const GroupInvitedRequest()
        else
          const GroupFeedAll()
      ],
    );
  }
}
