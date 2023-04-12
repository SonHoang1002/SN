import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_card.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';

import '../../widget/cross_bar.dart';

class LearnSpaceRender extends StatefulWidget {
  const LearnSpaceRender({Key? key}) : super(key: key);

  @override
  State<LearnSpaceRender> createState() => _LearnSpaceRenderState();
}

class _LearnSpaceRenderState extends State<LearnSpaceRender> {
  String menuSelected = 'recruit_interesting';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                recruitMenu.length,
                (index) => InkWell(
                      onTap: () {
                        setState(() {
                          menuSelected = recruitMenu[index]['key'];
                        });
                      },
                      child: ChipMenu(
                          isSelected: menuSelected == recruitMenu[index]['key'],
                          label: recruitMenu[index]['label']),
                    )),
          ),
        ),
        const CrossBar(),
        const LearnSpaceCard(),
      ],
    );
  }
}
