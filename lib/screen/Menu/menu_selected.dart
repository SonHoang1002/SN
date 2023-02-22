import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/demo_cart/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/search_market_page.dart';

import '../../helper/push_to_new_screen.dart';
import '../CreatePost/create_modal_base_menu.dart';
import '../EventScreen/screen/create_event_page.dart';
import '../Group/GroupCreateModules/screen/create_group_page.dart';
import '../Group/group.dart';
import '../MarketPlace/screen/main_market_body.dart';
import '../MarketPlace/screen/personal_market_page.dart';
import '../Page/page_general.dart';
import '../Watch/watch_render.dart';
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
              child: const Icon(
                FontAwesomeIcons.plus,
                size: 20,
                // color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            const Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              // color: Colors.black,
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
                pushToNextScreen(context, const CreateEventPage());
              },
              child: const Icon(
                FontAwesomeIcons.cartArrowDown,
                size: 20,
                // color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            const Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              // color: Colors.black,
            )
          ],
        );
        break;
      case 'marketPlace':
        body = MainMarketBody();
        buttonAppbar = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                pushToNextScreen(context, SearchMarketPage());
              },
              child: const Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                pushToNextScreen(context, CartMarketPage());
              },
              child: const Icon(
                FontAwesomeIcons.cartArrowDown,
                size: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                pushToNextScreen(context, PersonalMarketPlacePage());
              },
              child: const Icon(
                FontAwesomeIcons.user,
                size: 16,
                color: Colors.black,
              ),
            ),
          ],
        );
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
