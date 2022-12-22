import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class UserItem extends StatelessWidget {
  final dynamic user;
  const UserItem({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AvatarSocial(
            width: 32,
            height: 32,
            path: 'https://snapi.emso.asia/avatars/original/missing.png'),
        const SizedBox(
          width: 7,
        ),
        Text(
          user['display_name'],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}
