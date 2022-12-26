import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostSharePage extends StatelessWidget {
  final dynamic post;
  const PostSharePage({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = post['shared_page'];
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 0.2, color: greyColor))),
          child: ImageCacheRender(
            path: page['banner']['preview_url'],
          ),
        ),
        Container(
            width: size.width,
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Row(
              children: [
                Row(
                  children: [
                    AvatarSocial(
                        width: 50,
                        height: 50,
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
                              "${page['like_count']} lượt thích · ${page['page_categories'][0]['text']}"),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }
}
