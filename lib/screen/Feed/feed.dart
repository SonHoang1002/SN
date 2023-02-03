import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Feed/drawer.dart';
import 'package:social_network_app_mobile/screen/Notification/notification_page.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/Search/search.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class Feed extends StatefulWidget {
  final Function(bool) isHideBottomNavBar;
  const Feed({Key? key, required this.isHideBottomNavBar}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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

  String maxId = '';
  List posts = [];
  bool isMore = true;
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getListPosts();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        getListPosts(maxId: posts.last['id']);
      }
    });
  }

  Future getListPosts({String maxId = '', String type = ''}) async {
    if (!isMore) return;
    setState(() {
      isLoading = true;
    });
    List newList = await PostApi()
        .getListPostApi({"max_id": maxId, "limit": 3, "exclude_replies": true});
    setState(() {
      isLoading = false;
      posts = type == 'refresh' ? newList : posts + newList;
    });
    if (newList.length < 3) {
      setState(() {
        isMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      } else if (key == 'search') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Search()));
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
        body: RefreshIndicator(
          onRefresh: () async {
            getListPosts(maxId: '', type: 'refresh');
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(
                  height: 7,
                ),
                const CreatePostButton(),
                const CrossBar(),
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index < posts.length) {
                        return Post(post: posts[index]);
                      } else {
                        return Container(
                          color: Colors.red,
                          height: 100,
                          width: 100,
                        );
                      }
                    }),
                isMore
                    ? const SizedBox()
                    : const Center(
                        child: TextDescription(
                            description: "Bạn đã xem hết các bài viết mới rồi"),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}
