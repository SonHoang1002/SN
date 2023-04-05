import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';

class HeaderTabs extends StatelessWidget {
  final List listTabs;
  final Function chooseTab;
  final dynamic tabCurrent;
  const HeaderTabs(
      {super.key,
      required this.listTabs,
      required this.chooseTab,
      required this.tabCurrent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          listTabs.length,
          (index) => InkWell(
                onTap: () {
                  chooseTab(listTabs[index]?['key']);
                },
                child: ChipMenu(
                    isSelected: tabCurrent == (listTabs[index]?['key']),
                    label: listTabs[index]['label']),
              )),
    );
  }
}
