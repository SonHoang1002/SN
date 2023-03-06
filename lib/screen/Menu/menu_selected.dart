import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/search_modules/search_market_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

import '../../helper/push_to_new_screen.dart';
import '../CreatePost/create_modal_base_menu.dart';
import '../EventScreen/screen/create_event_page.dart';
import '../Group/GroupCreateModules/screen/create_group_page.dart';
import '../Group/group.dart';
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
      case 'eventSocial':
        // body = CreateEventBody();
        buttonAppbar = Row(
          children: [
            GestureDetector(
              onTap: () {
                pushToNextScreen(context, const CreateEventPage());
              },
              child: Icon(
                FontAwesomeIcons.cartArrowDown,
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
      case 'marketPlace':
        // pushToNextScreen(context, newScreen)
        // body = const MainMarketPage();
        // buttonAppbar = Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         pushToNextScreen(context, const SearchMarketPage());
        //       },
        //       child: Icon(
        //         FontAwesomeIcons.magnifyingGlass,
        //         size: 16,
        //         color: colorWord,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         pushToNextScreen(context, const CartMarketPage());
        //       },
        //       child: Icon(
        //         FontAwesomeIcons.cartArrowDown,
        //         size: 16,
        //         color: colorWord,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         pushToNextScreen(context, const PersonalMarketPlacePage());
        //       },
        //       child: Icon(
        //         FontAwesomeIcons.user,
        //         size: 16,
        //         color: colorWord,
        //       ),
        //     ),
        //   ],
        // );

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
