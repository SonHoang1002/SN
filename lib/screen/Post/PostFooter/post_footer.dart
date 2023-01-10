import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_button.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_information.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';

class PostFooter extends StatelessWidget {
  final dynamic post;
  final dynamic type;
  const PostFooter({Key? key, this.post, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () {
              if (![postDetail, postMultipleMedia].contains(type)) {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => PostDetail(post: post)));
              }
            },
            child: PostFooterInformation(post: post)),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
        ),
        PostFooterButton(
          post: post,
          type: type,
        )
      ],
    );
  }
}
