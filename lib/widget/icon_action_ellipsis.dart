import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widget/report_category.dart';

class ActionEllipsis extends StatelessWidget {
  final dynamic menuSelected;
  final dynamic data;
  final dynamic type;
  const ActionEllipsis({
    Key? key,
    this.menuSelected,
    this.type,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (menuSelected['key']) {
      case 'invite':
        return type != null
            ? InviteFriend(type: type, id: data['id'])
            : const InviteFriend();
      case 'report':
        return const ReportCategory(entityReport: 'event', entityType: "event");
      case 'share':
      default:
        return const SizedBox();
    }
  }
}
