import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Feed/drawer.dart';
import 'package:social_network_app_mobile/screen/Notification/notification_page.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/data/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class Feed extends StatefulWidget {
  final Function(bool) isHideBottomNavBar;
  const Feed({Key? key, required this.isHideBottomNavBar}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
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
    super.build(context);
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    List iconAction = [
      {
        "key": "notification",
        "icon": modeTheme == 'dark'
            ? 'assets/NotiDM.svg'
            : 'assets/notification.svg',
        'type': 'image',
        "top": 6.0,
        "left": 6.0,
        "right": 6.0,
        "bottom": 6.0,
      },
      {"key": "search", "icon": Icons.search, 'type': 'icon'},
      {
        "key": "chat",
        "icon": modeTheme == 'dark' ? 'assets/ChatDM.svg' : 'assets/chat.svg',
        'type': 'image',
        "top": modeTheme == 'dark' ? 5.0 : 6.0,
        "left": modeTheme == 'dark' ? 5.0 : 5.5,
        "right": modeTheme == 'dark' ? 5.0 : 0.0,
        "bottom": modeTheme == 'dark' ? 5.0 : 0.0,
      }
    ];

    handleClick(key) {
      if (key == 'notification') {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const CreateModalBaseMenu(
                      title: 'Thông báo',
                      body: NotificationPage(),
                      buttonAppbar: SizedBox(),
                    )));
      }
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
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
                    const Text(
                      "Emso",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      "Social",
                      style: TextStyle(
                          color: secondaryColor, fontWeight: FontWeight.w700),
                    )
                  ]),
              Row(
                children: List.generate(
                    iconAction.length,
                    (index) => GestureDetector(
                          onTap: () {
                            handleClick(iconAction[index]['key']);
                          },
                          child: Container(
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color,
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
                  height: 7,
                ),
                const CreatePostButton(),
                const CrossBar(),
                Column(
                    children: List.generate(
                        posts.length, (index) => Post(post: posts[index])))
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
