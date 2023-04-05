import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_home.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/header_tabs.dart';

import 'watch_saved.dart';

class WatchRender extends StatefulWidget {
  const WatchRender({Key? key}) : super(key: key);

  @override
  State<WatchRender> createState() => _WatchRenderState();
}

class _WatchRenderState extends State<WatchRender> {
  String menuSelected = 'watch_home';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HeaderTabs(
            chooseTab: (tab) {
              if (mounted) {
                setState(() {
                  menuSelected = tab;
                });
              }
            },
            listTabs: watchMenu,
            tabCurrent: menuSelected,
          ),
        ),
        const CrossBar(
          height: 1,
        ),
        if (menuSelected == 'watch_home')
          const WatchHome()
        else
          menuSelected == 'watch_saved' ? const WatchSaved() : const SizedBox()
      ],
    );
  }
}
