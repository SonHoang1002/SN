import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class PageInvite extends StatelessWidget {
  const PageInvite({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: pagesLike.length,
        itemBuilder: ((context, index) => Container(
              margin: const EdgeInsets.all(8.0),
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: greyColor),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AvatarSocial(
                            width: 50,
                            height: 50,
                            object: pagesLike[index]['page'],
                            path:
                                pagesLike[index]['page']['avatar_media'] != null
                                    ? pagesLike[index]['page']['avatar_media']
                                        ['preview_url']
                                    : linkAvatarDefault),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: size.width - 110,
                              child: RichText(
                                  text: TextSpan(
                                      text: (pagesLike[index]['page']
                                                          ['title'] ??
                                                      '')
                                                  .length <
                                              50
                                          ? (pagesLike[index]['page']
                                                  ['title'] ??
                                              '')
                                          : '${(pagesLike[index]['page']['title'] ?? '').substring(0, 50)}...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color),
                                      children: const [
                                    TextSpan(
                                        text: ' đã mời bạn thích trang của họ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal))
                                  ])),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            SizedBox(
                              width: size.width - 110,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  ButtonPrimary(
                                      isPrimary: false,
                                      handlePress: () {},
                                      icon: const Icon(
                                        FontAwesomeIcons.solidThumbsUp,
                                        size: 16,
                                        color: white,
                                      ),
                                      label: "Thích"),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  ButtonPrimary(
                                    isPrimary: true,
                                    handlePress: () {},
                                    label: "Từ chối",
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
