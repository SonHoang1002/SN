import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_card.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_cv.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_interested.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_invite.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_news.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_news_past.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';

import '../../widgets/cross_bar.dart';

class RecruitRender extends StatefulWidget {
  String? notiType;
  RecruitRender({Key? key, this.notiType}) : super(key: key);

  @override
  State<RecruitRender> createState() => _RecruitRenderState();
}

class _RecruitRenderState extends State<RecruitRender> {
  String menuSelected = 'recruit_interesting';

  @override
  void initState() {
    if (widget.notiType != null) {
      setState(() {
        menuSelected = widget.notiType!;
      });
    }
    super.initState();
  }

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
        menuSelected == 'recruit_interesting'
            ? const RecruitCard()
            : const SizedBox(),
        menuSelected == 'recruit_following'
            ? const RecruitInterested()
            : const SizedBox(),
        menuSelected == 'recruit_invite'
            ? const RecruitInvite()
            : const SizedBox(),
        menuSelected == 'recruit_news' ? const RecruitNews() : const SizedBox(),
        menuSelected == 'recruit_news_past'
            ? const RecruitNewsPast()
            : const SizedBox(),
        menuSelected == 'recruit_save' ? const RecruitCV() : const SizedBox(),
      ],
    );
  }
}
