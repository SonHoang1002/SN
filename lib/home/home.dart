import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/providers/connectivity_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_post.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/main_market_page.dart';
import 'package:social_network_app_mobile/screens/Menu/menu.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/screens/Notification/notification_page.dart';
import 'package:social_network_app_mobile/screens/Search/search.dart';
import 'package:social_network_app_mobile/screens/Watch/watch.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import 'package:social_network_app_mobile/screens/Feed/feed.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/Home/bottom_navigator_bar_emso.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:provider/provider.dart' as pv;

class Home extends ConsumerStatefulWidget {
  final int? selectedIndex;
  const Home({Key? key, this.selectedIndex}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool isShowSnackBar = false;
  ValueNotifier<bool> showBottomNavigatorNotifier = ValueNotifier(false);

  double valueFromPercentageInRange(
      {required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }

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
      Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        ref.read(connectivityControllerProvider.notifier).checkConnectivity();
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

  _buildSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(title),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)))),
    );
  }

  _showBottomNavigator(bool value) {
    if (showBottomNavigatorNotifier.value != value) {
      setState(() {
        showBottomNavigatorNotifier.value = value;
      });
    }
  }

  List titles = [
    const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Emso",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
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

  List iconActionWatch = [
    {"icon": Icons.search, 'type': 'icon'},
  ];

  AppBar _buildAppBar(
      int index, List titles, List actions, ThemeManager theme) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: primaryColor),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: actions.elementAt(index),
      title: titles.elementAt(index),
    );
  }

  Widget _buildBottomNavigator() {
    return BottomNavigatorBarEmso(
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Widget _buildDrawer(Size size) {
    return Drawer(
      width: size.width - 20,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: const Menu(),
    );
  }

  Widget _buildIndexedStack(List<Widget> pages) {
    return IndexedStack(
      index: _selectedIndex,
      children: pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = pv.Provider.of<ThemeManager>(context);

    if (widget.selectedIndex != null &&
        _selectedIndex != widget.selectedIndex!) {
      setState(() {
        _selectedIndex = widget.selectedIndex!;
      });
    }

    final modeTheme = theme.themeMode == ThemeMode.dark
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

    List<Widget> pages = [
      Feed(
        callbackFunction: _showBottomNavigator,
      ),
      const Moment(typePage: 'home'),
      const SizedBox(),
      const Watch(),
      const MainMarketPage(false)
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

    if (ref.watch(connectivityControllerProvider).connectInternet == false &&
        !isShowSnackBar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buildSnackBar("Không có kết nối mạng");
        setState(() {
          isShowSnackBar = true;
        });
      });
    } else if (ref.watch(connectivityControllerProvider).connectInternet ==
            true &&
        isShowSnackBar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buildSnackBar("Đã khôi phục kết nối mạng");
        setState(() {
          isShowSnackBar = false;
        });
      });
    }

    return Scaffold(
        drawer: _selectedIndex == 1 || _selectedIndex == 4
            ? null
            : _buildDrawer(size),
        appBar: _selectedIndex == 1 || _selectedIndex == 4
            ? null
            : _buildAppBar(_selectedIndex, titles, actions, theme),
        body: _buildIndexedStack(pages),
        bottomNavigationBar:
            showBottomNavigatorNotifier.value ? _buildBottomNavigator() : null);
  }

  @override
  void dispose() {
    showBottomNavigatorNotifier.dispose();
    super.dispose();
  }
}
