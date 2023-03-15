import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_card.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_donated.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_host.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_owner.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class GrowRender extends StatefulWidget {
  const GrowRender({Key? key}) : super(key: key);

  @override
  State<GrowRender> createState() => _GrowRenderState();
}

class _GrowRenderState extends State<GrowRender> {
  String menuSelected = 'grow_hosting';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                growMenu.length,
                (index) => InkWell(
                      onTap: () {
                        setState(() {
                          menuSelected = growMenu[index]['key'];
                        });
                      },
                      child: ChipMenu(
                          isSelected: menuSelected == growMenu[index]['key'],
                          label: growMenu[index]['label']),
                    )),
          ),
        ),
        const CrossBar(),
        menuSelected == 'grow_interesting' ?  const GrowCard() : const SizedBox(),
        // menuSelected == 'grow_for_u' ? const GrowOwner() : const SizedBox(),
        // menuSelected == 'grow_donated' ? const GrowDonated() : const SizedBox(),
        menuSelected == 'grow_hosting' ? const GrowHost() : const SizedBox(),
      ],
    );
  }
}
