import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class VideoDescription extends StatelessWidget {
  final dynamic moment;
  const VideoDescription({super.key, this.moment});

  @override
  Widget build(BuildContext context) {
    var account = moment['account'];
    var page = moment['page'];
    final size = MediaQuery.of(context).size;

    List iconsAction = [
      {"key": "reaction", "icon": FontAwesomeIcons.solidHeart, "count": 2345},
      {
        "key": "comment",
        "icon": FontAwesomeIcons.solidCommentDots,
        "count": moment['replies_total']
      },
      {
        "key": "share",
        "icon": FontAwesomeIcons.share,
        "count": moment['reblogs_count']
      },
      {"key": "menu", "icon": FontAwesomeIcons.ellipsis},
    ];

    return SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: size.width - 90,
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            AvatarSocial(
                                width: 30,
                                height: 30,
                                path: page != null
                                    ? page['avatar_media'] != null
                                        ? page['avatar_media']['preview_url']
                                        : linkAvatarDefault
                                    : account['avatar_media']['preview_url']),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              page != null
                                  ? page['title']
                                  : account['display_name'],
                              style: const TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          moment['content'],
                          style: const TextStyle(fontSize: 12, color: white),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        iconsAction.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    iconsAction[index]['icon'],
                                    size: 30,
                                    color: white.withOpacity(0.8),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    (iconsAction[index]['count'] ?? '')
                                        .toString(),
                                    style: const TextStyle(
                                        color: white, fontSize: 12),
                                  )
                                ],
                              ),
                            )),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
