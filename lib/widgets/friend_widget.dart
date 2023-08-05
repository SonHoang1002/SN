import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

import 'text_description.dart';

class FriendItem extends ConsumerWidget {
  final dynamic friend;
  final double? sizeAvatar;
  final double? sizeTitle;
  final double? sizeDesription;
  final int? maxLinesTitle;
  final double? marginContent;
  final double? widthTitle;
  final int? maxLinesDescription;
  bool isActiveNewScreen = true;
  FriendItem(
      {Key? key,
      this.friend,
      this.sizeAvatar,
      this.sizeTitle,
      this.maxLinesTitle,
      this.sizeDesription,
      this.marginContent,
      this.widthTitle,
      this.maxLinesDescription,
      this.isActiveNewScreen = true})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    return isActiveNewScreen
        ? InkWell(
            onTap: () async {
              // Navigator.pushNamed(context, '/page', arguments: page);
            },
            child: Row(
              children: [
                AvatarSocial(
                    width: sizeAvatar ?? 40,
                    height: sizeAvatar ?? 40,
                    object: friend,
                    path: (friend?['avatar_media']) != null
                        ? (friend?['avatar_media']?['preview_url'])
                        : (friend?["banner"]) != null
                            ? (friend?["banner"]?['preview_url'])
                            : linkAvatarDefault),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: widthTitle ?? size.width - 180,
                      child: Text(
                        (friend?['title']) ?? friend['display_name'],
                        maxLines: maxLinesTitle ?? 1,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: sizeTitle ?? 13,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    SizedBox(
                      height: marginContent ?? 4.0,
                    ),
                    friend['page_categories'] != null &&
                            friend['page_categories'].isNotEmpty
                        ? SizedBox(
                            width: widthTitle ?? size.width - 180,
                            child: TextDescription(
                              description: friend['page_categories'][0]['text'],
                              maxLinesDescription: maxLinesDescription,
                              size: sizeDesription,
                            ),
                          )
                        : friend["category"] != null &&
                                friend["category"]["text"] != null
                            ? SizedBox(
                                width: widthTitle ?? size.width - 180,
                                child: TextDescription(
                                  description: friend['category']['text'],
                                  maxLinesDescription: maxLinesDescription,
                                  size: sizeDesription,
                                ),
                              )
                            : const SizedBox()
                  ],
                )
              ],
            ),
          )
        : Row(
            children: [
              AvatarSocial(
                  width: sizeAvatar ?? 40,
                  height: sizeAvatar ?? 40,
                  object: friend,
                  path: friend['avatar_media'] != null
                      ? (friend?['avatar_media']?['preview_url'])
                      : friend?["banner"] != null
                          ? (friend?["banner"]?['preview_url'])
                          : linkAvatarDefault),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthTitle ?? size.width - 180,
                    child: Text(
                      friend?['title'] ?? friend['display_name'],
                      maxLines: maxLinesTitle ?? 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: sizeTitle ?? 13,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  SizedBox(
                    height: marginContent ?? 4.0,
                  ),
                  friend['page_categories'] != null &&
                          friend['page_categories'].isNotEmpty
                      ? SizedBox(
                          width: widthTitle ?? size.width - 180,
                          child: TextDescription(
                            description: friend['page_categories'][0]['text'],
                            maxLinesDescription: maxLinesDescription,
                            size: sizeDesription,
                          ),
                        )
                      : friend["category"] != null &&
                              friend["category"]["text"] != null
                          ? SizedBox(
                              width: widthTitle ?? size.width - 180,
                              child: TextDescription(
                                description: friend['category']['text'],
                                maxLinesDescription: maxLinesDescription,
                                size: sizeDesription,
                              ),
                            )
                          : const SizedBox()
                ],
              )
            ],
          );
  }
}
