import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_post.dart';
import 'package:social_network_app_mobile/screen/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/main_market_page.dart';
import 'package:social_network_app_mobile/screen/Menu/menu.dart';
import 'package:social_network_app_mobile/screen/Moment/moment.dart';
import 'package:social_network_app_mobile/screen/Notification/notification_page.dart';
import 'package:social_network_app_mobile/screen/Search/search.dart';
import 'package:social_network_app_mobile/screen/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/screen/Watch/watch.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import 'package:social_network_app_mobile/screen/Feed/feed.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:provider/provider.dart' as pv;

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      showBarModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (context) => const CreatePost());
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    if (mounted) {
      SecureStorage().getKeyStorage("token").then((value) {
        if (value != 'noData') {
          Future.delayed(Duration.zero, () async {
            if (ref.watch(meControllerProvider).isEmpty) {
              await ref.read(meControllerProvider.notifier).getMeData();
              await setTheme();
            }
          });
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => const OnboardingLoginPage())));
        }
      });
    }
  }

  Future setTheme() async {
    final theme = pv.Provider.of<ThemeManager>(context, listen: false);
    final token = await SecureStorage().getKeyStorage('token');
    final dataLogin = await SecureStorage().getKeyStorage('dataLogin');
    SecureStorage().getKeyStorage('theme').then((value) {
      if (value != 'noData') {
        theme.getThemeInitial(value);
      } else {
        var currentTheme = jsonDecode(dataLogin)
            .firstWhere((e) => e['token'] == token)['theme'];
        if (currentTheme != null) {
          theme.toggleTheme(currentTheme);
        }
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = pv.Provider.of<ThemeManager>(context);

    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    List iconActionFeed = [
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

    List iconActionWatch = [
      {"icon": Icons.search, 'type': 'icon'},
    ];

    List<Widget> pages = [
      const Feed(),
      const Moment(typePage: 'home'),
      const SizedBox(),
      const Watch(),
      const MainMarketPage(false)
    ];

    List titles = [
      Row(
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
              style:
                  TextStyle(color: secondaryColor, fontWeight: FontWeight.w700),
            )
          ]),
      const SizedBox(),
      const SizedBox(),
      const AppBarTitle(title: 'Watch')
    ];

    List actions = [
      List.generate(
          iconActionFeed.length,
          (index) => GestureDetector(
                onTap: () {
                  handleClick(iconActionFeed[index]['key']);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(left: 5, right: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.3)),
                  child: iconActionFeed[index]['type'] == 'icon'
                      ? Icon(
                          iconActionFeed[index]['icon'],
                          size: 20,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              top: iconActionFeed[index]['top'],
                              left: iconActionFeed[index]['left'],
                              right: iconActionFeed[index]['right'],
                              bottom: iconActionFeed[index]['bottom']),
                          child: SvgPicture.asset(
                            iconActionFeed[index]['icon'],
                          ),
                        ),
                ),
              )),
      [const SizedBox()],
      [const SizedBox()],
      List.generate(
          iconActionWatch.length,
          (index) => Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(left: 5, right: 8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.withOpacity(0.3)),
              child: Icon(
                iconActionWatch[index]['icon'],
                size: 20,
                color: Theme.of(context).textTheme.displayLarge!.color,
              )))
    ];

    return Scaffold(
      drawer: _selectedIndex == 1 || _selectedIndex == 4
          ? null
          : Drawer(
              width: size.width - 20,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: const Menu(),
            ),
      appBar: _selectedIndex == 1 || _selectedIndex == 4
          ? null
          : AppBar(
              elevation: 0,
              centerTitle: false,
              iconTheme: const IconThemeData(color: primaryColor),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: actions.elementAt(_selectedIndex),
              title: titles.elementAt(_selectedIndex),
            ),
      body: Consumer(builder: (context, ref, _) {
        final selectedVideo = ref.watch(selectedVideoProvider);
        final miniPlayerController = ref.watch(miniPlayerControllerProvider);

        return Stack(
          children: [
            IndexedStack(index: _selectedIndex, children: pages),
            if (selectedVideo != null)
              Miniplayer(
                controller: miniPlayerController,
                minHeight: 80,
                maxHeight: size.height,
                builder: (height, percentage) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: VideoPlayerHasController(
                                type: 'miniPlayer',
                                media: selectedVideo['media_attachments'][0],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        selectedVideo['content'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        selectedVideo['account']
                                                ['displayName'] ??
                                            selectedVideo['page']['title'] ??
                                            '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WatchDetail(
                                              post: selectedVideo,
                                              media: selectedVideo[
                                                  'media_attachments'][0],
                                            )));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                ref
                                    .read(selectedVideoProvider.notifier)
                                    .update((state) => null);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: greyColor,
        showSelectedLabels: false,
        selectedLabelStyle: const TextStyle(fontSize: 0),
        unselectedLabelStyle: const TextStyle(fontSize: 0),
        elevation: 0,
        backgroundColor: _selectedIndex == 1
            ? Colors.black
            : Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 0 ? "assets/HomeFC.svg" : "assets/home.svg",
              width: 20,
              height: 20,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                _selectedIndex == 1
                    ? 'assets/MomentFC.png'
                    : 'assets/MomentLM.png',
                width: 22,
                height: 22,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/Plus.svg",
                width: 20,
                height: 20,
                color: _selectedIndex == 2 ? primaryColor : greyColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 3 ? "assets/WatchFC.svg" : "assets/Watch.svg",
                width: 20,
                height: 20,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                _selectedIndex == 4
                    ? 'assets/MarketFC.png'
                    : 'assets/MarketLM.png',
                width: 22,
                height: 22,
              ),
              label: '')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
