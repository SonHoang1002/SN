import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class AvatarBanner extends StatelessWidget {
  final String postType;
  final dynamic post;
  const AvatarBanner({Key? key, required this.postType, this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var media = post['media_attachments'].isNotEmpty
        ? post['media_attachments'][0]
        : {'preview_url': linkAvatarDefault};
    String path = media['preview_url'];
    return postType == postAvatarAccount
        ? Center(
            child: Container(
              width: size.width * 0.7 + 2,
              height: size.width * 0.7 + 2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.3, color: greyColor)),
              child: AvatarSocial(
                  width: size.width * 0.7,
                  height: size.width * 0.7,
                  object: {'avatar_media': post['media_attachments'][0]},
                  path: path),
            ),
          )
        : Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: greyColor)),
              child: Image.network(
                path,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          );
  }
}
