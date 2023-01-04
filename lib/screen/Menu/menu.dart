import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:social_network_app_mobile/screen/Feed/drawer.dart';
import 'package:social_network_app_mobile/screen/Menu/menu_user.dart';
import 'package:social_network_app_mobile/screen/Setting/setting.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import 'menu_render.dart';
import 'menu_shortcut.dart';

class Menu extends StatefulWidget {
  final Function(bool) isHideBottomNavBar;

  const Menu({Key? key, required this.isHideBottomNavBar}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            widget.isHideBottomNavBar(true);
            break;
          case ScrollDirection.reverse:
            widget.isHideBottomNavBar(false);
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    final size = MediaQuery.of(context).size;

    List iconAction = [
      {
        "icon": Icons.settings,
        'type': 'icon',
        "action": () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const Setting()));
        }
      },
      {
        "icon": Icons.search,
        'type': 'icon',
        "action": () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const Setting()));
        }
      },
    ];

    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          key: _key,
          drawer: Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: const DrawerFeed(),
          ),
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _key.currentState!.openDrawer(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Icon(
                            Icons.menu,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      const AppbarTitle(title: 'Menu'),
                    ]),
                Row(
                  children: List.generate(
                      iconAction.length,
                      (index) => GestureDetector(
                            onTap: () {
                              iconAction[index]['action']();
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.3)),
                                child: Icon(
                                  iconAction[index]['icon'],
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color,
                                )),
                          )),
                )
              ],
            ),
          ),
          body: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: size.height - 100,
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const MenuUser(),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 0.3,
                      decoration: const BoxDecoration(color: greyColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const MenuShortcut(),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 0.3,
                      decoration: const BoxDecoration(color: greyColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const MenuRender(),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 0.3,
                      decoration: const BoxDecoration(color: greyColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: size.width - 40,
                      height: 40, // <-- match_parent
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: const Color(0xffdcdcdc)),
                          onPressed: () {},
                          child: const Text(
                            "Đăng xuất",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          )),
                    )
                  ],
                ),
              )),
        ));
  }
}
