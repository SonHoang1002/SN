import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import 'post_center.dart';

class PostShare extends StatelessWidget {
  final dynamic post;
  final dynamic type;
  const PostShare({Key? key, this.post, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postReblogRender = post['reblog'];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(top: 8),
      // width: size.width - 30,
      decoration:
          BoxDecoration(border: Border.all(width: 0.2, color: greyColor)),
      child: Column(
        children: [
          PostHeader(post: postReblogRender, type: type ?? postReblog),
          PostCenter(post: postReblogRender,type: type,),
        ],
      ),
    );
  }
}
