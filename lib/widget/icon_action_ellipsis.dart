import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';

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
    Widget buttonAppbar = const SizedBox();
    Widget body = const SizedBox();
    switch (menuSelected['key']) {
      case 'share':
        body = const InviteFriend();
        break;
      default:
    }

    return CreateModalBaseMenu(
        title: menuSelected['label'], body: body, buttonAppbar: buttonAppbar);
  }
}
