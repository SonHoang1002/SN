import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class GroupItem extends StatelessWidget {
  final dynamic group;
  const GroupItem({Key? key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarSocial(
            isGroup: true,
            width: 40,
            height: 40,
            path: group?['banner']?['preview_url'] ?? linkAvatarDefault),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: buildTextContent(
            (group?['title']) ?? "--",
            false,
            fontSize: 13,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        )
      ],
    );
  }
}
