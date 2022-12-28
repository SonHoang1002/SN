import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class GroupItem extends StatelessWidget {
  final dynamic group;
  const GroupItem({Key? key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        AvatarSocial(
            isGroup: true,
            width: 40,
            height: 40,
            path: group['banner']['preview_url']),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: size.width - 180,
          child: Text(
            group['title'],
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
