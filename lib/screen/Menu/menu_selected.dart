import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Event/event_render.dart';
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
      case 'eventSocial':
        body = const EventRender();
        buttonAppbar = Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                FontAwesomeIcons.calendarDay,
                size: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 7.0,
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                FontAwesomeIcons.plus,
                size: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 7.0,
            ),
            GestureDetector(
                onTap: () {},
                child: const Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 18,
                  color: Colors.black,
                ))
          ],
        );
        break;
      case 'groupSocial':
        body = const Group();
        buttonAppbar = Row(
          children: const [
            Icon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
            SizedBox(
              width: 12.0,
            ),
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
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
