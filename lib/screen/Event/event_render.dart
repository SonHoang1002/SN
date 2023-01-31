import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/Event/event_card.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class EventRender extends StatefulWidget {
  const EventRender({Key? key}) : super(key: key);

  @override
  State<EventRender> createState() => _EventRenderState();
}

class _EventRenderState extends State<EventRender> {
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
        const EventCard()
      ],
    );
  }
}
