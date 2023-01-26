import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class UserPageInfomationBlock extends StatelessWidget {
  final dynamic userAbout;
  final dynamic user;
  const UserPageInfomationBlock({Key? key, this.userAbout, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic generalInformation = userAbout['general_information'];
    List hobbies = userAbout['hobbies'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giới thiệu',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.solidComment,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(generalInformation['description'])
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.house,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text('Sống tại ${generalInformation['place_live']['name']}')
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationDot,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text('Đến từ ${generalInformation['hometown']['name']}')
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.phone,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(generalInformation['phone_number'])
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Transform.rotate(
                      angle: pi / 4,
                      child: const Icon(
                        FontAwesomeIcons.wifi,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text('${user['followers_count']} người theo dõi')
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            'Sở thích',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  hobbies.length,
                  (index) => ChipMenu(
                        isSelected: false,
                        label: hobbies[index]['text'],
                        icon: ImageCacheRender(
                          path: hobbies[index]['icon'],
                          width: 18.0,
                        ),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
