import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';

import 'PostType/avatar_banner.dart';

class PostCenter extends StatefulWidget {
  final dynamic post;
  const PostCenter({Key? key, this.post}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostCenterState createState() => _PostCenterState();
}

class _PostCenterState extends State<PostCenter> {
  @override
  Widget build(BuildContext context) {
    String postType = widget.post['post_type'] ?? '';
    return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.post['content'],
                style: const TextStyle(fontSize: 15),
              ),
            ),
            postType != '' ? renderPostType(postType) : Container(),
          ],
        ));
  }

  renderPostType(postType) {
    if ([postAvatarAccount, postBannerAccount].contains(postType)) {
      return AvatarBanner(postType: postType, post: widget.post);
    }
  }
}
