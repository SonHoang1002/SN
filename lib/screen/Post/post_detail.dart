import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/comment_textfield.dart';

import 'comment_tree.dart';

class PostDetail extends ConsumerStatefulWidget {
  final dynamic post;
  const PostDetail({Key? key, this.post}) : super(key: key);

  @override
  ConsumerState<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends ConsumerState<PostDetail> {
  List postComment = [];
  bool isLoadComment = false;
  FocusNode commentNode = FocusNode();
  dynamic commentSelected;
  dynamic commentChild;

  Future getListCommentPost(postId, params) async {
    setState(() {
      isLoadComment = true;
    });
    List newList = await PostApi().getListCommentPost(postId, params) ?? [];
    if (mounted) {
      setState(() {
        isLoadComment = false;
        postComment = postComment + newList;
      });
    }
  }

  Future handleComment(data) async {
    if (!mounted) return;
    var newCommentPreview = {
      "id": data['id'],
      "in_reply_to_id": widget.post['id'],
      "account": ref.watch(meControllerProvider)[0],
      "content": data['status'],
      "typeStatus": data['typeStatus'] ?? "previewComment",
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

    List dataPreComment = [];

    if (data['type'] == 'parent' && data['typeStatus'] == null) {
      dataPreComment = [newCommentPreview, ...postComment];
    } else if (data['type'] == 'child' && data['typeStatus'] == null) {
      dataPreComment = postComment;
    } else if (data['typeStatus'] == 'editComment') {
      int indexComment = postComment
          .indexWhere((element) => element['id'] == newCommentPreview['id']);
      List newListUpdate = [];

      if (indexComment > -1) {
        newListUpdate = [
          ...postComment.sublist(0, indexComment),
          newCommentPreview,
          ...postComment.sublist(indexComment + 1)
        ];
      }
      dataPreComment = newListUpdate;
    }

    setState(() {
      postComment = dataPreComment;
      commentChild = data['type'] == 'child' ? newCommentPreview : null;
    });

    dynamic newComment;

    if (data['typeStatus'] != 'editComment') {
      newComment = await PostApi().createStatus({
            ...data,
            "visibility": "public",
            "in_reply_to_id": data['in_reply_to_id'] ?? widget.post['id']
          }) ??
          newCommentPreview;
    } else {
      newComment = await PostApi().updatePost(data['id'],
          {"extra_body": null, "status": data['status'], "tags": []});
    }
    if (mounted && newComment != null) {
      int indexComment = postComment
          .indexWhere((element) => element['id'] == newComment['id']);
      List newListUpdate = [];

      if (indexComment > -1) {
        newListUpdate = postComment.sublist(0, indexComment) +
            [newComment] +
            postComment.sublist(indexComment + 1);
      }

      List dataCommentUpdate = [];

      if (data['type'] == 'parent' && data['typeStatus'] == null) {
        dataCommentUpdate = [newComment, ...postComment.sublist(1)];
      } else if (data['type'] == 'child' && data['typeStatus'] == null) {
        dataCommentUpdate = postComment;
      } else if (data['typeStatus'] == 'editComment') {
        dataCommentUpdate = newListUpdate;
      }

      setState(() {
        postComment = dataCommentUpdate;
        commentChild = newComment;
      });
    }
  }

  getCommentSelected(comment) {
    setState(() {
      commentSelected = comment;
    });
  }

  handleDeleteComment(post) {
    if (post != null) {
      List newPostComment =
          postComment.where((element) => element['id'] != post['id']).toList();

      setState(() {
        postComment = newPostComment;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getListCommentPost(widget.post['id'], {"sort_by": "newest"});
  }

  @override
  Widget build(BuildContext context) {
    final commentCount = widget.post['replies_count'] ?? 0;

    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
        setState(() {
          commentSelected = null;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BackIconAppbar(),
              SizedBox(
                child: PostHeader(
                  post: widget.post,
                  type: postDetail,
                ),
              ),
            ],
          ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostCenter(
                        post: widget.post,
                        type: postDetail,
                      ),
                      PostFooter(post: widget.post, type: postDetail),
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
                          itemBuilder: ((context, index) => CommentTree(
                              key: Key(postComment[index]['id']),
                              commentChildCreate: postComment[index]['id'] ==
                                      commentChild?['in_reply_to_id']
                                  ? commentChild
                                  : null,
                              commentNode: commentNode,
                              commentSelected: commentSelected,
                              commentParent: postComment[index],
                              getCommentSelected: getCommentSelected,
                              handleDeleteComment: handleDeleteComment))),
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
                                            child: CupertinoActivityIndicator())
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
    );
  }
}
