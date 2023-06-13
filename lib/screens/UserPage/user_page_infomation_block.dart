import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/StoryView/story_page.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import '../../theme/theme_manager.dart';

class UserPageInfomationBlock extends StatelessWidget {
  final dynamic userAbout;
  final dynamic user;
  final dynamic featureContents;
  final dynamic lifeEvent;
  const UserPageInfomationBlock(
      {Key? key,
      this.userAbout,
      this.user,
      this.featureContents,
      this.lifeEvent})
      : super(key: key);
  String renderContent(dynamic data) {
    if (data['life_event']['school_type'] == "HIGH_SCHOOL") {
      if (data['life_event']['place'] != null) {
        return '${data?['life_event']?['name']} tại ${data['life_event']['place']['title']}';
      } else {
        return '${data?['life_event']?['currently'] == true ? "Đã học" : "Học"} tại ${data['life_event']['company'] ?? data['life_event']['name']}';
      }
    } else if (data['life_event']['school_type'] == "UNIVERSITY") {
      return '${data?['life_event']?['currently'] == true ? "Từng học" : "Học"} tại ${data['life_event']['company'] ?? data['life_event']['name']}';
    } else if (data['life_event']['position'] != null) {
      return '${data?['life_event']?['position']} tại ${data['life_event']['company']}';
    } else {
      return data['life_event']['company'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic generalInformation = userAbout?['general_information'];
    List hobbies = userAbout['hobbies'] ?? [];
    final theme = Provider.of<ThemeManager>(context);
    final size = MediaQuery.of(context).size;
    return generalInformation == null
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chi tiết',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: lifeEvent.length,
                          itemBuilder: (context, index) {
                            if (lifeEvent[index]['life_event']['visibility'] !=
                                    'private' &&
                                lifeEvent[index]['life_event']['company'] !=
                                    null) {
                              return ListTile(
                                // minLeadingWidth: 20,
                                dense: true,
                                horizontalTitleGap: 0.0,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 0.0),
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                leading: const Icon(FontAwesomeIcons.briefcase,
                                    size: 18),
                                title: Text(renderContent(lifeEvent[index]),
                                    style: const TextStyle(fontSize: 15)),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                      if (generalInformation['description'] != null &&
                          generalInformation['description'].isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ItemInformation(
                            icon: FontAwesomeIcons.solidComment,
                            text: generalInformation['description'],
                          ),
                        ),
                      if (generalInformation['place_live'] != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ItemInformation(
                            icon: FontAwesomeIcons.house,
                            text:
                                'Sống tại ${generalInformation['place_live']['title'] ?? generalInformation['place_live']['name']}',
                          ),
                        ),
                      if (generalInformation['hometown'] != null)
                        Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ItemInformation(
                              icon: FontAwesomeIcons.locationDot,
                              text:
                                  'Đến từ ${generalInformation['hometown']['title'] ?? generalInformation['hometown']['name']}',
                            )),
                      if (generalInformation['phone_number'] != null)
                        Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ItemInformation(
                              icon: FontAwesomeIcons.phone,
                              text: generalInformation['phone_number'],
                            )),
                      if (user['followers_count'] != null)
                        Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ItemInformation(
                              iconOther: Transform.rotate(
                                angle: pi / 4,
                                child: const Icon(
                                  FontAwesomeIcons.wifi,
                                  size: 16,
                                ),
                              ),
                              text: '${user['followers_count']} người theo dõi',
                            )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Text(
                  'Sở thích',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
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
                                width: 20.0,
                                height: 20.0,
                              ),
                            )),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                if (featureContents.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đáng chú ý',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              featureContents.length,
                              (index) => InkWell(
                                    borderRadius: BorderRadius.circular(10.0),
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          barrierColor: transparent,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          builder: (BuildContext context) {
                                            return StoryPage(
                                                user: user,
                                                story: featureContents[index]);
                                          });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: (size.width - 50) / 3,
                                          height: 2 * (size.width - 70) / 3,
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                child: ImageCacheRender(
                                                    width: size.width / 3,
                                                    height: 2 * size.width / 3,
                                                    path: featureContents[index]
                                                            ['banner']
                                                        ['preview_url']),
                                              ),
                                              featureContents[index]
                                                          ['media_count'] >
                                                      1
                                                  ? Positioned(
                                                      bottom: 5,
                                                      left: 5,
                                                      child: Text(
                                                        '+ ${featureContents[index]['media_count'] - 1}',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: white),
                                                      ))
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                            width: (size.width - 50) / 3,
                                            child: Text(
                                              featureContents[index]['title'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ))
                                      ],
                                    ),
                                  )),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          );
  }
}

class ItemInformation extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Widget? iconOther;

  const ItemInformation({
    super.key,
    this.icon,
    required this.text,
    this.iconOther,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        iconOther ??
            Icon(
              icon,
              size: 16,
            ),
        const SizedBox(
          width: 12.0,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: Text(text, style: const TextStyle(fontSize: 15)))
      ],
    );
  }
}