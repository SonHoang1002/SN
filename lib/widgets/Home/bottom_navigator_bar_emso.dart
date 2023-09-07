import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class BottomNavigatorBarEmso extends StatefulWidget {
  final int selectedIndex;
  final Function onTap;
  const BottomNavigatorBarEmso(
      {super.key, required this.onTap, required this.selectedIndex});

  @override
  State<BottomNavigatorBarEmso> createState() => _BottomNavigatorBarEmsoState();
}

class _BottomNavigatorBarEmsoState extends State<BottomNavigatorBarEmso> {
  int? _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedIndex = widget.selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
            icon: Image.asset(
              "assets/Plus.png",
              width: 25,
              height: 25,
              color: secondaryColor,
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
      currentIndex: _selectedIndex!,
      onTap: (value) {
        if (value != 2) {
          setState(() {
            _selectedIndex = value;
          });
        }
        widget.onTap(value);
      },
    );
  }
}
