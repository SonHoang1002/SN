import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreate/CreateStep/name_page_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreate/CreateStep/invite_friend_page.dart';

class PageCreate extends StatelessWidget {
  const PageCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InviteFriendPage();
    return NamePagePage();
  }
}
