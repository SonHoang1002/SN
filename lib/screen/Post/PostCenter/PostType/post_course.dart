import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostCourse extends StatelessWidget {
  final dynamic post;
  const PostCourse({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final course = post['shared_course'];
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/course', arguments: page);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 0.4, color: greyColor))),
            child: ExtendedImage.network(
              course['banner']?['preview_url'] ?? linkBannerDefault,
              height: 250,
              width: size.width,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          Container(
              width: size.width,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: size.width - 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextContent(course['title'], true,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(
                              height: 5,
                            ),
                            course["free"] == false || course["price"] != 0
                                ? buildTextContent(
                                    "${course["price"]} ₫", false,
                                    colorWord: red, fontSize: 15)
                                : buildTextContent("Miễn phí", false,
                                    colorWord: blueColor, fontSize: 15),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
