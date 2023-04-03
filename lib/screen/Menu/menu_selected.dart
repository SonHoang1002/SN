import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/screen/Event/create_event.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/search_modules/search_market_page.dart';
import 'package:social_network_app_mobile/screen/Payment/payment.dart';
import 'package:social_network_app_mobile/screen/Recruit/recruit_render.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

import '../../helper/push_to_new_screen.dart';
import '../Group/GroupCreateModules/screen/create_group_page.dart';
import '../MarketPlace/screen/personal_market_page.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Event/event_render.dart';
import 'package:social_network_app_mobile/screen/Group/group.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_render.dart';
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
    final theme = Provider.of<ThemeManager>(context);

    Color colorWord = theme.themeMode == ThemeMode.dark
        ? white
        : theme.themeMode == ThemeMode.light
            ? blackColor
            : blackColor;
    Widget buttonAppbar = const SizedBox();
    Widget body = const SizedBox();
    switch (menuSelected['key']) {
      case 'pageSocial':
        body = const PageGeneral();
        break;
      case 'watch':
        body = const WatchRender();
        break;
      case 'grow':
        body = const GrowRender();
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
      case 'eventSocial':
        body = const EventRender();
        buttonAppbar = Row(
          children: [
            InkWell(
              onTap: () {},
              child: Icon(
                FontAwesomeIcons.calendarDay,
                size: 18,
                color: colorWord,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateEvents()),
                );
              },
              child: Icon(FontAwesomeIcons.plus, size: 18, color: colorWord),
            ),
            const SizedBox(
              width: 12.0,
            ),
            InkWell(
                onTap: () {},
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 18,
                  color: colorWord,
                ))
          ],
        );
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
                color: colorWord,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              color: colorWord,
            )
          ],
        );
        break;
      case 'payment':
        body = const Payment();
        buttonAppbar = Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: colorWord,
              ),
            ),
          ],
        );
        break;
      case "job":
        body = const RecruitRender();
        buttonAppbar = Row(
          children: [
            InkWell(
              onTap: () {},
              child: const Icon(
                FontAwesomeIcons.calendarDay,
                size: 18,
              ),
            ),
            const SizedBox(
              width: 7.0,
            ),
            InkWell(
              onTap: () {},
              child: const Icon(
                FontAwesomeIcons.plus,
                size: 18,
              ),
            ),
            const SizedBox(
              width: 7.0,
            ),
            InkWell(
                onTap: () {},
                child: const Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 18,
                ))
          ],
        );
        break;
      case 'marketPlace':
        break;
      // return CreateSearchBaseMenu(
      //     placeHolder: "nhập sản phẩm",
      //     body: body,
      //     suffixWidget: buttonAppbar);

      // case 'moment':
      //   body = const Moment();
      //   break;
      default:
    }

    return CreateModalBaseMenu(
        title: menuSelected['label'], body: body, buttonAppbar: buttonAppbar);
  }
}
