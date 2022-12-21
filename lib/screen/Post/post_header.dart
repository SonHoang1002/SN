import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: AvatarSocial(
                    width: 32,
                    height: 32,
                    path:
                        'https://snapi.emso.asia/system/media_attachments/files/108/853/138/654/944/677/original/cc4c8fd4be1d7a96.jpg',
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.6,
                      child: const Text(
                        "Truyền hình quốc hội Việt Nam",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: const [
                        Text(
                          "15 phút",
                          style: TextStyle(
                              color: greyColor, fontWeight: FontWeight.w500),
                        ),
                        Text(" · "),
                        Icon(FontAwesomeIcons.earthAsia,
                            size: 15, color: greyColor)
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    FontAwesomeIcons.ellipsis,
                    size: 22,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    FontAwesomeIcons.xmark,
                    size: 22,
                  ),
                )
              ],
            )
          ]),
    );
  }
}
