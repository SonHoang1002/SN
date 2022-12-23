import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

    _pages = <Widget>[
      Feed(isHideBottomNavBar: (isHideBottomNavBar) {
        isHideBottomNavBar
            ? animationController.forward()
            : animationController.reverse();
      }),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.bolt), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.tv), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
