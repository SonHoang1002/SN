import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class PageItem extends StatelessWidget {
  final dynamic page;
  const PageItem({Key? key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        AvatarSocial(
            width: 40,
            height: 40,
            path: page['avatar_media'] != null
                ? page['avatar_media']['preview_url']
                : linkAvatarDefault),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: size.width - 180,
          child: Text(
            page['title'],
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                overflow: TextOverflow.ellipsis),
          ),
        )
      ],
    );
  }
}
