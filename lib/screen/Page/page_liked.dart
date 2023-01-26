import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';

class PageLiked extends StatelessWidget {
  const PageLiked({super.key});

  @override
  Widget build(BuildContext context) {
    List actionsPage = [
      {
        "image": "assets/chat.svg",
        "label": "Nhắn tin",
      },
      {
        "icon": FontAwesomeIcons.userPlus,
        "label": "Mời bạn bè thích trang này",
      },
      {
        "icon": FontAwesomeIcons.solidThumbsUp,
        "label": "Bỏ thích trang này",
      }
    ];

    final size = MediaQuery.of(context).size;

    handlePress(page) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
          builder: (context) => SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: PageItem(page: page['page']),
                    ),
                    Container(
                      height: 1,
                      width: size.width,
                      color: greyColor,
                    ),
                    Column(
                      children: List.generate(
                          actionsPage.length,
                          (index) => Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).canvasColor),
                                      child: actionsPage[index]['image'] != null
                                          ? SvgPicture.asset(
                                              actionsPage[index]['image'],
                                              width: 26,
                                              color: greyColor,
                                            )
                                          : Icon(
                                              actionsPage[index]['icon'],
                                              color: greyColor,
                                              size: 20,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      actionsPage[index]['label'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              )),
                    )
                  ],
                ),
              ));
    }

    return Container(
      margin: const EdgeInsets.only(top: 8.0, left: 10.0),
      child: ListView.builder(
          itemCount: pagesLike.length,
          itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.2, color: greyColor),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PageItem(page: pagesLike[index]['page']),
                        InkWell(
                            onTap: () {
                              handlePress(pagesLike[index]);
                            },
                            child: const Icon(FontAwesomeIcons.ellipsis))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Row(
                          children: [
                            ButtonPrimary(
                              isPrimary: true,
                              label: "Nhắn tin",
                              handlePress: () {},
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ButtonPrimary(
                              label: "Đang theo dõi",
                              handlePress: () {},
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
    );
  }
}
