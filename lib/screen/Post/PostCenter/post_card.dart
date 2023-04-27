import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final dynamic post;
  Axis axis;
  Border? border;
  PostCard({Key? key, this.post, this.axis = Axis.vertical, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isVertical = (axis == Axis.vertical);
    var card = post['card'];
    var size = MediaQuery.of(context).size;
    return card != null
        ? (card['provider_name'] != null && card['provider_name'] != 'GIPHY')||card['link']!=null
        // ? card['provider_name'] != null && card['provider_name'] != 'GIPHY'
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), border: border),
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                child: InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(
                        Uri.parse(card['link'] ?? card['url']))) {
                      await launchUrl(Uri.parse(card['link'] ?? card['url']));
                    } else {
                      return;
                    }
                  },
                  child: isVertical
                      ? Column(
                          children: [
                            ImageCacheRender(
                                path: card['image'] ??
                                    card['url'] ??
                                    card['link'],
                                height: 200,
                                width: size.width),
                            Container(
                              width: size.width,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              color: Theme.of(context).colorScheme.background,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (card['url'].split("//"))[1]
                                          .split("/")
                                          .first,
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
                        )
                      : Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              child: ImageCacheRender(
                                  path: card['image'] ??
                                      card['url'] ??
                                      card['link'],
                                  height: 80.0,
                                  width: 80.0),
                            ),
                            Flexible(
                              child: Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20))),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                height: 80.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      buildTextContent(
                                        card['url']
                                            .split("//")[1]
                                            .split("/")
                                            .first,
                                        true,
                                        fontSize: 14,
                                        colorWord: greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      card['title'] == null ||
                                              card['title'] != ""
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: buildTextContent(
                                                  card['title'], false,
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
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
