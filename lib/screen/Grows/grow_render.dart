import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_card.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class GrowRender extends StatefulWidget {
  const GrowRender({Key? key}) : super(key: key);

  @override
  State<GrowRender> createState() => _GrowRenderState();
}

class _GrowRenderState extends State<GrowRender> {
  String menuSelected = 'event_for_you';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                eventMenu.length,
                (index) => InkWell(
                      onTap: () {
                        setState(() {
                          menuSelected = eventMenu[index]['key'];
                        });
                      },
                      child: ChipMenu(
                          isSelected: menuSelected == eventMenu[index]['key'],
                          label: eventMenu[index]['label']),
                    )),
          ),
        ),
        const CrossBar(),
        const GrowCard()
      ],
    );
  }
}
