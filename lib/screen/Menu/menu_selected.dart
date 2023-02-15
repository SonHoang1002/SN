import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/EventScreen/screen/create_event_page.dart';
import 'package:social_network_app_mobile/screen/Group/GroupCreateModules/screen/create_group_page.dart';
import 'package:social_network_app_mobile/screen/Group/group.dart';
import 'package:social_network_app_mobile/screen/Page/page_general.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_render.dart';
// import 'package:social_network_app_mobile/screen/Page/page_general.dart';

class MenuSelected extends StatelessWidget {
  final dynamic menuSelected;
  final dynamic data;
  const MenuSelected({
    Key? key,
    this.menuSelected,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonAppbar = const SizedBox();
    Widget body = const SizedBox();

    switch (menuSelected['key']) {
      case 'pageSocial':
        body = const PageGeneral();
        break;
      case 'watch':
        body = const WatchRender();
        break;
      case 'groupSocial':
        body = const Group();
        buttonAppbar = Row(
          children: [
            GestureDetector(
              onTap: () {
                pushToNextScreen(context, CreateGroupPage());
              },
              child: Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              color: Colors.black,
            )
          ],
        );
        break;
      case 'eventSocial':
        // body = CreateEventBody();
        buttonAppbar = Row(
          children: [
            GestureDetector(
              onTap: () {
                pushToNextScreen(context, CreateEventPage());
              },
              child: Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              color: Colors.black,
            )
          ],
        );
        break;
      // case 'moment':
      //   body = const Moment();
      //   break;
      default:
    }

    return CreateModalBaseMenu(
        title: menuSelected['label'], body: body, buttonAppbar: buttonAppbar);
  }
}
