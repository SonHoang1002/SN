import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/screen/Menu/menu.dart';
import 'package:social_network_app_mobile/screen/Watch/watch.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import 'package:social_network_app_mobile/screen/Feed/feed.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController animationController;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // if (!Platform.isWindows) {
    //   FirebaseMessaging.instance
    //       .getToken()
    //       .then((value) => print('token $value'));
    // }

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    functionHidden(isHideBottomNavBar) {
      isHideBottomNavBar
          ? animationController.forward()
          : animationController.reverse();
    }

    _pages = <Widget>[
      Feed(isHideBottomNavBar: functionHidden),
      Container(),
      Container(),
      Watch(isHideBottomNavBar: functionHidden),
      Menu(isHideBottomNavBar: functionHidden)
    ];
  }

  @override
  void dispose() {
    // ...
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizeTransition(
        sizeFactor: animationController,
        axisAlignment: -3.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: BottomNavigationBar(
            selectedItemColor: primaryColor,
            unselectedItemColor: greyColor,
            showSelectedLabels: false,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  icon: Icon(
                    Icons.menu,
                    color: _selectedIndex == 4 ? primaryColor : greyColor,
                    size: 30,
                  ),
                  label: ''),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
