import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Feed/drawer.dart';
import 'package:social_network_app_mobile/screen/Notification/notification_page.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/Search/search.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class Feed extends ConsumerStatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final scrollController = ScrollController();
  var paramsConfig = {"limit": 3, "exclude_replies": true};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(postControllerProvider.notifier)
            .getListPost(paramsConfig));

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = ref.read(postControllerProvider).posts.last['id'];
        ref
            .read(postControllerProvider.notifier)
            .getListPost({"max_id": maxId, ...paramsConfig});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    List posts = ref.watch(postControllerProvider).posts;
    bool isMore = ref.watch(postControllerProvider).isMore;

    final theme = pv.Provider.of<ThemeManager>(context);
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

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: const DrawerFeed(),
      ),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: List.generate(
            iconAction.length,
            (index) => GestureDetector(
                  onTap: () {
                    handleClick(iconAction[index]['key']);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(left: 5, right: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3)),
                    child: iconAction[index]['type'] == 'icon'
                        ? Icon(
                            iconAction[index]['icon'],
                            size: 20,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
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
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Emso",
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
              ),
              Text(
                "Social",
                style: TextStyle(
                    color: secondaryColor, fontWeight: FontWeight.w700),
              )
            ]),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(postControllerProvider.notifier)
              .refreshListPost(paramsConfig);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              const CreatePostButton(),
              const CrossBar(
                height: 5,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index < posts.length) {
                      return Post(type: feedPost, post: posts[index]);
                    } else {
                      return isMore == true
                          ? Center(
                              child: SkeletonCustom().postSkeleton(context),
                            )
                          : const SizedBox();
                    }
                  }),
              isMore
                  ? Center(
                      child: SkeletonCustom().postSkeleton(context),
                    )
                  : const Center(
                      child: TextDescription(
                          description: "Bạn đã xem hết các bài viết mới rồi"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
