import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/post.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/comment_textfield.dart';

import 'comment_tree.dart';

class PostDetail extends StatelessWidget {
  final dynamic post;
  const PostDetail({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 4.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 30,
                      margin: const EdgeInsets.only(left: 4.0, top: 6.0),
                      child: const BackIconAppbar()),
                  SizedBox(
                    width: size.width - 45,
                    child: PostHeader(
                      post: post,
                      type: postDetail,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PostCenter(
                        post: post,
                      ),
                      PostFooter(post: post, type: postDetail),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                      ),
                      ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: postComment.length,
                          itemBuilder: ((context, index) =>
                              CommentTree(commentParent: postComment[index])))
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: CommentTextfield(),
              )
            ]),
      ),
    );
  }
}
