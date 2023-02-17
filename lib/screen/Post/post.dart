import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class Post extends StatelessWidget {
  final dynamic post;
  final String? type;
  final bool? isHiddenCrossbar;
  const Post({Key? key, this.post, this.type, this.isHiddenCrossbar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return post != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(
                post: post,
                type: type,
              ),
              PostCenter(post: post),
              PostFooter(post: post),
              isHiddenCrossbar != null && isHiddenCrossbar == true
                  ? const SizedBox()
                  : const CrossBar(),
            ],
          )
        : const SizedBox();
  }
}
