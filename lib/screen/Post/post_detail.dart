import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/helper/common.dart';
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
  FocusNode commentNode = FocusNode();
  dynamic commentSelected;

  Future getListCommentPost(postId, params) async {
    setState(() {
      isLoadComment = true;
    });
    List newList = await PostApi().getListCommentPost(postId, params) ?? [];
    setState(() {
      isLoadComment = false;
      postComment = postComment + newList;
    });
  }

  Future handleComment(data) async {
    var newCommentPreview = {
      "in_reply_to_id": widget.post['id'],
      "account": meData,
      "content": data['status'],
      "typeStatus": "previewComment",
      "created_at": "2023-02-01T23:04:48.047+07:00",
      "backdated_time": "2023-02-01T23:04:48.047+07:00",
      "sensitive": false,
      "spoiler_text": "",
      "visibility": "public",
      "language": "vi",
      "post_type": null,
      "replies_count": 0,
      "off_comment": false,
      "reblogs_count": 0,
      "favourites_count": 0,
      "reactions": [
        {"type": "like", "likes_count": 0},
        {"type": "haha", "hahas_count": 0},
        {"type": "angry", "angrys_count": 0},
        {"type": "love", "loves_count": 0},
        {"type": "sad", "sads_count": 0},
        {"type": "wow", "wows_count": 0},
        {"type": "yay", "yays_count": 0}
      ],
      "replies_total": 0,
      "score": "109790330095515423",
      "hidden": false,
      "notify": false,
      "processing": "done",
      "comment_moderation": "public",
      "viewer_reaction": null,
      "reblogged": false,
      "muted": false,
      "bookmarked": false,
      "pinned": null,
      "card": null,
      "in_reply_to_parent_id": null,
      "reblog": null,
      "application": {"name": "Web", "website": null},
      "status_background": null,
      "status_activity": null,
      "tagable_page": null,
      "place": null,
      "page_owner": null,
      "album": null,
      "event": null,
      "project": null,
      "course": null,
      "series": null,
      "shared_event": null,
      "shared_project": null,
      "shared_recruit": null,
      "shared_course": null,
      "shared_page": null,
      "shared_group": null,
      "target_account": null,
      "media_attachments": [],
      "mentions": [],
      "tags": [],
      "replies": [],
      "favourites": [],
      "emojis": [],
      "status_tags": [],
      "poll": null,
      "life_event": null,
      "status_question": null,
      "status_target": null
    };

    setState(() {
      postComment = [newCommentPreview, ...postComment];
    });

    dynamic newComment = await PostApi().createStatus(
        {...data, "visibility": "public", "in_reply_to_id": widget.post['id']});

    setState(() {
      postComment = [newComment, ...postComment.sublist(1)];
    });
  }

  getCommentSelected(comment) {
    setState(() {
      commentSelected = comment;
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

    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
        setState(() {
          commentSelected = null;
        });
      },
      child: SafeArea(
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
                                  commentNode: commentNode,
                                  commentSelected: commentSelected,
                                  commentParent: postComment[index],
                                  getCommentSelected: getCommentSelected))),
                          commentCount - postComment.length > 0
                              ? InkWell(
                                  onTap: isLoadComment
                                      ? null
                                      : () {
                                          getListCommentPost(
                                              widget.post['id'], {
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CommentTextfield(
                        commentSelected: commentSelected,
                        getCommentSelected: getCommentSelected,
                        commentNode: commentNode,
                        handleComment: handleComment),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
