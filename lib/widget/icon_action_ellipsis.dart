import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widget/report_category.dart';

class ActionEllipsis extends StatelessWidget {
  final dynamic menuSelected;
  final dynamic data;
  const ActionEllipsis({
    Key? key,
    this.menuSelected,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (menuSelected['key']) {
      case 'invite':
        return const InviteFriend();
      case 'report':
        return const  ReportCategory(entityReport: 'event', entityType: "event");
        case 'share': 
      default:
        return const SizedBox();
    }
  }
}
