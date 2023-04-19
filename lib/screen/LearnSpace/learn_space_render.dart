import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_card.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_host.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_interested.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_invitations.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_learned.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_library.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';

import '../../widget/cross_bar.dart';

class LearnSpaceRender extends StatefulWidget {
  const LearnSpaceRender({Key? key}) : super(key: key);

  @override
  State<LearnSpaceRender> createState() => _LearnSpaceRenderState();
}

class _LearnSpaceRenderState extends State<LearnSpaceRender> {
  String menuSelected = 'course_interesting';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                courseMenu.length,
                (index) => InkWell(
                      onTap: () {
                        setState(() {
                          menuSelected = courseMenu[index]['key'];
                        });
                      },
                      child: ChipMenu(
                          isSelected: menuSelected == courseMenu[index]['key'],
                          label: courseMenu[index]['label']),
                    )),
          ),
        ),
        const CrossBar(),
        menuSelected == 'course_interesting'
            ? const LearnSpaceCard()
            : const SizedBox(),
        menuSelected == 'course_following'
            ? const LearnSpaceInterested()
            : const SizedBox(),
        menuSelected == 'course_host'
            ? const LearnSpaceHost()
            : const SizedBox(),
        menuSelected == 'course_learned'
            ? const LearnSpaceLearned()
            : const SizedBox(),
        menuSelected == 'course_save'
            ? const LearnSpaceLibrary()
            : const SizedBox(),
        menuSelected == 'course_invite'
            ? const LearnSpaceInvitations()
            : const SizedBox(),
      ],
    );
  }
}
