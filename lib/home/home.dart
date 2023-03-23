import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_post.dart';
import 'package:social_network_app_mobile/screen/Menu/menu.dart';
import 'package:social_network_app_mobile/screen/Moment/moment.dart';
import 'package:social_network_app_mobile/screen/Watch/watch.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import 'package:social_network_app_mobile/screen/Feed/feed.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
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
    setTheme();
    Future.delayed(Duration.zero, () {
      ref.read(meControllerProvider.notifier).getMeData();
      setState(() {});
    });
  }

  void setTheme() async {
    final theme = pv.Provider.of<ThemeManager>(context, listen: false);
    SecureStorage().getKeyStorage('theme').then((value) {
      if (value != 'noData') {
        theme.getThemeInitial(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Feed(),
      const Moment(),
      const SizedBox(),
      const Watch(),
      const Menu()
    ];

    var meData = ref.watch(meControllerProvider);

    return meData.isEmpty
        ? Scaffold(
            body: Center(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Emso",
                        style: TextStyle(
                            fontSize: 26,
                            color: primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Social",
                        style: TextStyle(
                            fontSize: 26,
                            color: secondaryColor,
                            fontWeight: FontWeight.w700),
                      )
                    ]),
              ),
            ),
          )
        : Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
            bottomNavigationBar: SizedBox(
              height: 65,
              child: BottomNavigationBar(
                selectedItemColor: primaryColor,
                unselectedItemColor: greyColor,
                showSelectedLabels: false,
                elevation: 0,
                backgroundColor: _selectedIndex == 1
                    ? Colors.black
                    : Theme.of(context).scaffoldBackgroundColor,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      _selectedIndex == 0
                          ? "assets/HomeFC.svg"
                          : "assets/home.svg",
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
                        _selectedIndex == 3
                            ? "assets/WatchFC.svg"
                            : "assets/Watch.svg",
                        width: 20,
                        height: 20,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == 4 ? primaryColor : greyColor,
                          shape: BoxShape.circle,
                        ),
                        width: 27,
                        height: 27,
                        child: Center(
                          child: Stack(
                            children: [
                              AvatarSocial(
                                  width: 23.0,
                                  height: 23.0,
                                  object: meData[0],
                                  path: meData[0]['avatar_media']
                                      ['preview_url']),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: _selectedIndex == 4
                                            ? primaryColor
                                            : greyColor,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.menu,
                                      size: 6,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      label: ''),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          );
  }
}
