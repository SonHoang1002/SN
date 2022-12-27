import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class UserItem extends StatelessWidget {
  final dynamic user;
  final String? subText;
  const UserItem({Key? key, this.user, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarSocial(
            width: 40,
            height: 40,
            path: user['avatar_media']['preview_url'] ?? linkAvatarDefault),
        const SizedBox(
          width: 7,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user['display_name'],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              subText ?? '',
              style: const TextStyle(color: greyColor),
            )
          ],
        )
      ],
    );
  }
}
