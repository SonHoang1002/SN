import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/comment_textfield.dart';

import 'comment_tree.dart';

class PostDetail extends StatefulWidget {
  final dynamic post;
  const PostDetail({Key? key, this.post}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List postComment = [];
  bool isLoadComment = false;

  Future getListCommentPost(postId, params) async {
    setState(() {
      isLoadComment = true;
    });
    List newList = await PostApi().getListCommentPost(postId, params);
    setState(() {
      isLoadComment = false;
      postComment = postComment + newList;
    });
  }

  @override
  void initState() {
    super.initState();
    getListCommentPost(widget.post['id'], {"sort_by": "newest"});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final commentCount = widget.post['replies_count'] ?? 0;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 6.0,
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
                        post: widget.post,
                        type: postDetail,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostCenter(
                          post: widget.post,
                        ),
                        PostFooter(post: widget.post, type: postDetail),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3)),
                        ),
                        ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: postComment.length,
                            itemBuilder: ((context, index) => CommentTree(
                                commentParent: postComment[index]))),
                        commentCount - postComment.length > 0
                            ? InkWell(
                                onTap: isLoadComment
                                    ? null
                                    : () {
                                        getListCommentPost(widget.post['id'], {
                                          "max_id": postComment.last['id'],
                                          "sort_by": "newest"
                                        });
                                      },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 12.0, top: 6.0, bottom: 6.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Xem thêm ${commentCount - postComment.length} bình luận",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: greyColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      isLoadComment
                                          ? const SizedBox(
                                              width: 10,
                                              height: 10,
                                              child:
                                                  CupertinoActivityIndicator())
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
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
      ),
    );
  }
}
