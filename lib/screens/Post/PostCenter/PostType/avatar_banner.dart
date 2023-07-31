import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class AvatarBanner extends StatelessWidget {
  final String postType;
  final dynamic post;
  final String? type;
  final String? preType;
  final Function(dynamic)? updateDataFunction;
  const AvatarBanner(
      {Key? key,
      required this.postType,
      this.post,
      this.type,
      this.updateDataFunction,
      this.preType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var media = post['media_attachments'].isNotEmpty
        ? post['media_attachments'][0]
        : {'preview_url': linkAvatarDefault};
    String path = media['preview_url'];
    return InkWell(
      onTap: () {
        pushCustomVerticalPageRoute(
            context,
            PostOneMediaDetail(
                postMedia: post,
                post: post,
                type: type,
                preType: preType,
                updateDataFunction: updateDataFunction),
            opaque: false);
      },
      child: Hero(
        tag: post?['media_attachments'].isNotEmpty
            ? ((post?['media_attachments']?[0]?['id']))
            : "0",
        child: postType == postAvatarAccount
            ? Center(
                child: Container(
                  width: size.width * 0.7 + 2,
                  height: size.width * 0.7 + 2,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 0.1, color: greyColor)),
                  child: AvatarSocial(
                      width: size.width * 0.7,
                      height: size.width * 0.7,
                      object: {
                        'avatar_media': post['media_attachments'].isNotEmpty
                            ? post?['media_attachments']?[0]
                            : {}
                      },
                      path: path),
                ),
              )
            : Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.1, color: greyColor)),
                  child: Image.network(
                    path,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              ),
      ),
    );
  }
}
