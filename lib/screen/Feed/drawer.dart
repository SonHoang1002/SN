import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/drawer.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/group_item.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class DrawerFeed extends StatelessWidget {
  const DrawerFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 230,
          child: DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Lối tắt',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              TextDescription(
                  description:
                      "Với lối tắt, bạn có thể nhanh chóng truy cập vào những việc mình hay làm nhất trên Emso Social, giúp cho bạn có được trải nghiệm tốt nhất, nhanh nhất khi sử dụng."),
              SizedBox(
                height: 5,
              ),
              SearchInput()
            ],
          )),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(
                  drawers.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, right: 8, left: 10),
                        child: GroupItem(group: drawers[index]),
                      )),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Column(
        //       children: const [
        //         Icon(
        //           FontAwesomeIcons.userGroup,
        //           size: 20,
        //           color: primaryColor,
        //         ),
        //         SizedBox(
        //           height: 5,
        //         ),
        //         TextAction(title: "Tất cả"),
        //       ],
        //     ),
        //     Column(
        //       children: const [
        //         Icon(
        //           FontAwesomeIcons.locationArrow,
        //           size: 20,
        //           color: primaryColor,
        //         ),
        //         SizedBox(
        //           height: 5,
        //         ),
        //         TextAction(title: "Khám phá"),
        //       ],
        //     )
        //   ],
        // )
      ],
    );
  }
}
