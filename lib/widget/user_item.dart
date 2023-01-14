import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class UserItem extends StatelessWidget {
  final dynamic user;
  final String? subText;
  const UserItem({Key? key, this.user, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarSocial(
            width: 40,
            height: 40,
            path: user['avatar_media'] != null
                ? user['avatar_media']['preview_url']
                : linkAvatarDefault),
        const SizedBox(
          width: 7,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user['display_name'],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            !['', null].contains(subText)
                ? Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    child: TextDescription(description: subText ?? ''))
                : const SizedBox()
          ],
        )
      ],
    );
  }
}
