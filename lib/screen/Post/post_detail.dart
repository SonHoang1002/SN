import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/post.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/comment_textfield.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';

import 'comment_tree.dart';

class PostDetail extends StatelessWidget {
  final dynamic post;
  const PostDetail({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            PostHeader(
              post: post,
              type: postDetail,
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
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
