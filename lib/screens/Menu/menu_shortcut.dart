import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/drawer.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class MenuShortcut extends StatelessWidget {
  const MenuShortcut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lối tắt của bạn",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 8,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  drawers.length,
                  (index) => Container(
                        margin: const EdgeInsets.only(),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                AvatarSocial(
                                    width: 65,
                                    height: 65,
                                    isGroup: true,
                                    object: drawers[index],
                                    path: drawers[index]['avatar_media'] != null
                                        ? drawers[index]['avatar_media']
                                            ['preview_url']
                                        : drawers[index]['banner']
                                            ['preview_url'])
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                drawers[index]['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: greyColor,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            )
                          ],
                        ),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
