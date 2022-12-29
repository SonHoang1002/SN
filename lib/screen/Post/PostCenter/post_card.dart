import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostCard extends StatelessWidget {
  final dynamic post;
  const PostCard({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var card = post['card'];
    var size = MediaQuery.of(context).size;
    return card != null
        ? card['provider_name'] != 'GIPHY'
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(
                        Uri.parse(card['link'] ?? card['url']))) {
                      await launchUrl(Uri.parse(card['link'] ?? card['url']));
                    } else {
                      throw 'Không thể mở link!';
                    }
                  },
                  child: Column(
                    children: [
                      ImageCacheRender(
                          path: card['image'] ?? card['url'] ?? card['link']),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: Theme.of(context).colorScheme.background,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card['title'],
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                card['description'],
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: greyColor,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRect(
                  child: ImageCacheRender(
                    path: card['link'],
                    width: size.width,
                  ),
                ),
              )
        : const SizedBox();
  }
}
