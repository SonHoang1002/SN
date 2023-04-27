import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class Post extends StatelessWidget {
  final dynamic post;
  final String? type;
  final bool? isHiddenCrossbar;
  final dynamic data;

  const Post({Key? key, this.post, this.type, this.isHiddenCrossbar, this.data})
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
              PostCenter(
                post: post,
                type: type,
                data: data
              ),
              PostFooter(
                post: post,
                type: type,
              ),
              isHiddenCrossbar != null && isHiddenCrossbar == true
                  ? const SizedBox()
                  : const CrossBar(
                      height: 5,
                      // margin: 8,
                      onlyBottom: 12, onlyTop: 6,
                    ),
            ],
          )
        : const SizedBox();
  }
}
