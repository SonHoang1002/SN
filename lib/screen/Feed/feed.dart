import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Feed/drawer.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';

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

    List iconAction = [
      {"icon": Icons.add},
      {"icon": Icons.search},
      {"icon": FontAwesomeIcons.facebookMessenger}
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
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
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    const Text(
                      "Emso",
                      style: TextStyle(
                          color: Color(0xFFEd7F4D),
                          fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      "Social",
                      style: TextStyle(
                          color: Color(0xFF7165E0),
                          fontWeight: FontWeight.w700),
                    )
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
                          ),
                        )),
              )
            ],
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CreatePostButton(),
              Container(
                height: 5,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                color: Colors.grey.withOpacity(0.5),
              ),
              const Post()
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
