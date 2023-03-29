import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/Recruit/recruit_card.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';

import '../../widget/cross_bar.dart';

class RecruitRender extends StatefulWidget {
  const RecruitRender({Key? key}) : super(key: key);

  @override
  State<RecruitRender> createState() => _RecruitRenderState();
}

class _RecruitRenderState extends State<RecruitRender> {
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
        const RecruitCard(),
      ],
    );
  }
}