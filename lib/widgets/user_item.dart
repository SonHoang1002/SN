import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

import '../screens/UserPage/user_page.dart';

class UserItem extends StatelessWidget {
  final dynamic user;
  final String? subText;
  const UserItem({Key? key, this.user, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserPage(),
              settings: RouteSettings(
                arguments: {'id': user['id'].toString()},
              ),
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarSocial(
              width: 40,
              height: 40,
              object: user,
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
                user?['display_name'] ?? 'Không xác định',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
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
      ),
    );
  }
}