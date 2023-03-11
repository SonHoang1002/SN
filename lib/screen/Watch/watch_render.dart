import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

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
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    watchMenu.length,
                    (index) => InkWell(
                          onTap: () {
                            setState(() {
                              menuSelected = watchMenu[index]['key'];
                            });
                          },
                          child: ChipMenu(
                              isSelected:
                                  menuSelected == watchMenu[index]['key'],
                              label: watchMenu[index]['label']),
                        )),
              ),
            ),
            menuSelected == 'watch_saved'
                ? Container(
                    height: 5,
                    margin: const EdgeInsets.only(top: 10),
                    color: Colors.grey.withOpacity(0.5),
                  )
                : const CrossBar(),
            menuSelected == 'watch_home'
                ? Column(
                    children: List.generate(
                        watchs.length,
                        (index) => Post(
                            key: Key(watchs[index]['id']),
                            post: watchs[index])))
                : const SizedBox(),
            menuSelected == 'watch_saved'
                ? const WatchSaved()
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
