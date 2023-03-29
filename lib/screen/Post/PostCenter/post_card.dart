import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
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
                      return;
                    }
                  },
                  child: Column(
                    children: [
                      buildDivider(color: greyColor),
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
                                (card['url'].split("//"))[1].split("/").first,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: greyColor,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                card['title'],
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              // Text(
                              //   card['description'],
                              //   style: const TextStyle(
                              //       fontSize: 12,
                              //       color: greyColor,
                              //       overflow: TextOverflow.ellipsis),
                              // ),
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
                child: Column(
                  children: [
                    buildDivider(color: greyColor),
                    ClipRect(
                      child: ImageCacheRender(
                        path: card?['link'] ?? linkBannerDefault,
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              )
        : const SizedBox();
  }
}
