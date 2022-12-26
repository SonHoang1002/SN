import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

import 'watch_chip_menu.dart';
import 'watch_drawer.dart';
import 'watch_saved.dart';

class Watch extends StatefulWidget {
  final Function(bool) isHideBottomNavBar;
  const Watch({Key? key, required this.isHideBottomNavBar}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WatchState createState() => _WatchState();
}

class _WatchState extends State<Watch>
    with AutomaticKeepAliveClientMixin<Watch> {
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

  String menuSelected = 'watch_home';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    List iconAction = [
      {"icon": Icons.search, 'type': 'icon'},
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
        drawer: const Drawer(
          child: WatchDrawer(),
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
                    const AppbarTitle(title: 'Watch'),
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
                          child: iconAction[index]['type'] == 'icon'
                              ? Icon(
                                  iconAction[index]['icon'],
                                  size: 20,
                                  color: Colors.black,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: iconAction[index]['top'],
                                      left: iconAction[index]['left'],
                                      right: iconAction[index]['right'],
                                      bottom: iconAction[index]['bottom']),
                                  child: SvgPicture.asset(
                                    iconAction[index]['icon'],
                                  ),
                                ),
                        )),
              )
            ],
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 5,
                ),
                WatchChipMenu(
                  menuSelected: menuSelected,
                  handleUpdate: (key) {
                    setState(() {
                      menuSelected = key;
                    });
                  },
                ),
                menuSelected == 'watch_saved'
                    ? Container(
                        height: 5,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.grey.withOpacity(0.5),
                      )
                    : const CrossBar(),
                menuSelected == 'watch_home'
                    ? Column(
                        children: List.generate(watchs.length,
                            (index) => Post(post: watchs[index])))
                    : const SizedBox(),
                menuSelected == 'watch_saved'
                    ? const WatchSaved()
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
