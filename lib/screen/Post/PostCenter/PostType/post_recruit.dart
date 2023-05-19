import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/refractor_time.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

class PostRecruit extends StatelessWidget {
  final dynamic post;
  const PostRecruit({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recruit = post['shared_recruit'];
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
              recruit['banner']?['preview_url'] ?? linkBannerDefault,
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
                      // AvatarSocial(
                      //     width: 50,
                      //     height: 50,
                      //     object: course,
                      //     path: page['avatar_media']['preview_url']),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      SizedBox(
                        width: size.width - 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextContent(
                                " ${getRefractorTime(recruit["due_date"])}",
                                false,
                                fontSize: 13),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              recruit['title'],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis),
                            ),
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
