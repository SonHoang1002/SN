import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/page_detail.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

import 'text_description.dart';

class PageItem extends StatelessWidget {
  final dynamic page;
  const PageItem({Key? key, this.page}) : super(key: key);

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
              width: 40,
              height: 40,
              object: page,
              path: page['avatar_media'] != null
                  ? page['avatar_media']['preview_url']
                  : linkAvatarDefault),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width - 180,
                child: Text(
                  page['title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              page['page_categories'].isNotEmpty
                  ? TextDescription(
                      description: page['page_categories'][0]['text'],
                    )
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
