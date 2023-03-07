import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screen/Post/comment_tree.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/comment_textfield.dart';
// import 'package:social_network_app_mobile/widget/no_comment.dart';

class CommentPostModal extends ConsumerStatefulWidget {
  final dynamic post;
  const CommentPostModal({Key? key, this.post}) : super(key: key);

  @override
  ConsumerState<CommentPostModal> createState() => _CommentPostModalState();
}

class _CommentPostModalState extends ConsumerState<CommentPostModal> {
  dynamic postDetail;
  List postComment = [];
  bool isLoadComment = false;
  FocusNode commentNode = FocusNode();
  dynamic commentSelected;
  dynamic commentChild;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    if (widget.post != null) {
      fetchDataPostDetail();
    }
  }

  fetchDataPostDetail() async {
    dynamic response;
    if (['video', 'image'].contains(widget.post['type'])) {
      response = await PostApi().getPostDetailMedia(widget.post['id']);
    } else {
      response = widget.post;
    }

    if (response != null) {
      setState(() {
        postDetail = response;
      });

      getListCommentPost(response['id'], {"sort_by": "newest"});
    }
  }

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
      "id": "11111111111",
      "in_reply_to_id": widget.post['id'],
      "account": ref.watch(meControllerProvider)[0],
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
      postComment = data['type'] == 'child'
          ? postComment
          : [newCommentPreview, ...postComment];
      commentChild = data['type'] == 'child' ? newCommentPreview : null;
    });

    dynamic newComment = await PostApi().createStatus({
          ...data,
          "visibility": "public",
          "in_reply_to_id": data['in_reply_to_id'] ?? postDetail?['id']
        }) ??
        newCommentPreview;
    if (mounted) {
      setState(() {
        postComment = data['type'] == 'child'
            ? postComment
            : [newComment, ...postComment.sublist(1)];
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
  Widget build(BuildContext context) {
    final commentCount = postDetail?['replies_count'] ?? 0;

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
          centerTitle: true,
          title: const AppBarTitle(title: 'Bình luận'),
        ),
        body: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 0.5, color: greyColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Expanded(
              //     child: SingleChildScrollView(
              //   child: NoComment(),
              // )),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                ),
              ),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: CommentTextfield(
                    commentSelected: commentSelected,
                    getCommentSelected: getCommentSelected,
                    commentNode: commentNode,
                    handleComment: handleComment),
              )
            ],
          ),
        ),
      ),
    );
  }
}
