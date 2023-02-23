import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_post.dart';
import 'package:social_network_app_mobile/screen/Menu/menu.dart';
import 'package:social_network_app_mobile/screen/Moment/moment.dart';
import 'package:social_network_app_mobile/screen/Watch/watch.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import 'package:social_network_app_mobile/screen/Feed/feed.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    if (!mounted) return;
    Future.delayed(Duration.zero, () {
      ref.read(meControllerProvider.notifier).getMeData();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const [
      Feed(),
      Moment(),
      CreatePost(),
      Watch(),
      Menu()
    ];

    var meData = ref.watch(meControllerProvider);

    return meData.isEmpty
        ? Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: CupertinoActivityIndicator(),
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
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: SvgPicture.asset(
                          _selectedIndex == 1
                              ? "assets/MomentFc.svg"
                              : "assets/Moment.svg",
                          width: 38,
                          height: 38,
                        ),
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
