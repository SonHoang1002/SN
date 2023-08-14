import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_feed_all.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_invited_request.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_list_all.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group_list_discover.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class Group extends ConsumerStatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  ConsumerState<Group> createState() => _GroupState();
}

class _GroupState extends ConsumerState<Group> {
  String menuSelected = "group-feed";
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
          .getListGroupAdminMember({'tab': 'member', 'limit': 20});
      ref
          .read(groupListControllerProvider.notifier)
          .getListGroupAdminMember({'tab': 'admin', 'limit': 20});
      ref
          .read(groupListControllerProvider.notifier)
          .groupDiscover({'tab': 'friend', 'limit': 10});
      ref
          .read(groupListControllerProvider.notifier)
          .getGroupSuggest({'limit': 10});
      ref
          .read(groupListControllerProvider.notifier)
          .getGroupInvite({'role': 'admin'});
      ref
          .read(groupListControllerProvider.notifier)
          .getGroupInvite({'role': 'member'});
      ref.read(groupListControllerProvider.notifier).getGroupJoinRequest(null);
    });
  }

  handlePress(String key) {
    setState(() {
      menuSelected = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
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
            ],
          ),
        ),
        const CrossBar(),
        _buildBody()
      ],
    );
  }

  Widget _buildBody() {
    if (menuSelected == 'your-group') {
      return const GroupListAll();
    } else if (menuSelected == 'group-dicover') {
      return const GroupListDiscover();
    } else if (menuSelected == 'group-request') {
      return const GroupInvitedRequest();
    } else {
      return const GroupFeedAll();
    }
  }
}
