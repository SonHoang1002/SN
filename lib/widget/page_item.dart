import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/page_detail.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

import 'text_description.dart';

class PageItem extends StatelessWidget {
  final dynamic page;
  final double? sizeAvatar;
  final double? sizeTitle;
  final double? sizeDesription;
  final int? maxLinesTitle;
  final double? marginContent;
  final double? widthTitle;
  final int? maxLinesDescription;
  const PageItem(
      {Key? key,
      this.page,
      this.sizeAvatar,
      this.sizeTitle,
      this.maxLinesTitle,
      this.sizeDesription,
      this.marginContent,
      this.widthTitle,
      this.maxLinesDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/page', arguments: page);
      },
      child: Row(
        children: [
          AvatarSocial(
              width: sizeAvatar ?? 40,
              height: sizeAvatar ?? 40,
              object: page,
              path: page['avatar_media'] != null
                  ? page['avatar_media']['preview_url']
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
                  page['title'],
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
              page['page_categories'].isNotEmpty
                  ? SizedBox(
                      width: widthTitle ?? size.width - 180,
                      child: TextDescription(
                        description: page['page_categories'][0]['text'],
                        maxLinesDescription: maxLinesDescription,
                        size: sizeDesription,
                      ),
                    )
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
