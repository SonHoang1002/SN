import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screens/Event/event_card.dart';
import 'package:social_network_app_mobile/screens/Event/event_going.dart';
import 'package:social_network_app_mobile/screens/Event/event_host.dart';
import 'package:social_network_app_mobile/screens/Event/event_interest.dart';
import 'package:social_network_app_mobile/screens/Event/event_invite.dart';
import 'package:social_network_app_mobile/screens/Event/event_past.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

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
        menuSelected == 'event_for_you' ?  const EventCard() : const SizedBox(),
        menuSelected == 'event_going' ?  const EventGoing() : const SizedBox(),
        menuSelected == 'event_invite' ?  const EventInvite() : const SizedBox(),
        menuSelected == 'event_interest' ?  const EventInterested() : const SizedBox(),
        menuSelected == 'event_host' ?  const EventHost() : const SizedBox(),
        menuSelected == 'event_past' ?  const EventPast() : const SizedBox(),


      ],
    );
  }
}
