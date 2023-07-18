import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:social_network_app_mobile/widgets/modal_bookmark.dart';
import 'package:social_network_app_mobile/widgets/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widgets/report_category.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

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
        return  ReportCategory(entityReport: data, entityType: type);
      case 'share':
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom * 0.35,
          ),
          child: ShareModalBottom(type: type, data: data),
        );
      case 'save':
        return const ModalBookmark();
      default:
        return const SizedBox();
    }
  }
}
