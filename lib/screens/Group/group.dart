import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screens/Group/group_invited_request.dart';
import 'package:social_network_app_mobile/screens/Group/group_list_all.dart';
import 'package:social_network_app_mobile/screens/Group/group_list_discover.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

import '../../providers/group/group_list_provider.dart';
import 'group_feed_all.dart';

class Group extends ConsumerStatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  ConsumerState<Group> createState() => _GroupState();
}

class _GroupState extends ConsumerState<Group> {
  String menuSelected = "group-feed";
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(groupListControllerProvider.notifier).getListGroupFeed({
        "exclude_replies": true,
        "limit": 3,
      });
      ref
          .read(groupListControllerProvider.notifier)
          .getListGroupAdminMember({'tab': 'member', 'limit': 10});
      ref
          .read(groupListControllerProvider.notifier)
          .getListGroupAdminMember({'tab': 'admin', 'limit': 10});
    });
  }

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
                          color: menuSelected == menuGroup[index]['key']
                              ? white
                              : null,
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
