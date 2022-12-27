import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/screen/Feed/drawer.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

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

  List iconAction = [
    {"icon": Icons.settings, 'type': 'icon'},
    {"icon": Icons.search, 'type': 'icon'},
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scaffold(
          key: _key,
          drawer: const Drawer(
            child: DrawerFeed(),
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
                        child: const Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Icon(
                            Icons.menu,
                            color: Colors.black,
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
                      (index) => Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3)),
                          child: Icon(
                            iconAction[index]['icon'],
                            size: 20,
                            color: Colors.black,
                          ))),
                )
              ],
            ),
          ),
        ));
  }
}
