import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class PostSharePage extends StatelessWidget {
  final dynamic post;
  final dynamic type;
  const PostSharePage({Key? key, this.post, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = post['shared_page'];
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        type != "edit_post"
            ? Navigator.pushNamed(context, '/page', arguments: page)
            : null;
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
              page['banner']?['preview_url'] ?? linkBannerDefault,
              height: 200,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              width: size.width,
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
                      AvatarSocial(
                          width: 50,
                          height: 50,
                          object: page,
                          path: page['avatar_media']['preview_url']),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size.width - 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              page['title'],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                "${page['like_count'] ?? 0} lượt thích ${page['page_categories'].isNotEmpty ? "· ${page['page_categories'][0]['text']}" : ""}"),
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
