import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/split_link.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/screens/Post/comment_tree.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/comment_textfield.dart';

import '../../providers/post_provider.dart';

class CommentPostModal extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  final dynamic preType;
  final int? indexImagePost;
  final Function? reloadFunction;
  final Function? updateDataPhotoPage;
  const CommentPostModal(
      {Key? key,
      this.post,
      this.type,
      this.preType,
      this.indexImagePost,
      this.reloadFunction,
      this.updateDataPhotoPage})
      : super(key: key);

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

  @override
  void dispose() {
    super.dispose();
    postDetail = null;
    postComment = [];
    commentNode.dispose();
    commentSelected = null;
    commentChild = null;
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
      if (widget.indexImagePost != null) {
        getListCommentPost(
            response['media_attachments'][widget.indexImagePost]['status_media']
                ['id'],
            {"sort_by": "newest"});
      } else {
        getListCommentPost(response['id'], {"sort_by": "newest"});
      }
    }
  }

  Future getListCommentPost(postId, params) async {
    setState(() {
      isLoadComment = true;
    });
    List newList =
        await PostApi().getListCommentPost(postId.toString(), params) ?? [];
    if (mounted) {
      setState(() {
        isLoadComment = false;
        postComment = postComment + newList;
      });
      // change count to
      final currentPost = ref.watch(currentPostControllerProvider).currentPost;
      if (currentPost['media_attachments'].isNotEmpty &&
          widget.indexImagePost != null &&
          newList.isNotEmpty) {
        int sumComment = postComment.length;
        newList.forEach((element) {
          sumComment += int.parse(
              (element['replies_count'] ?? element['replies_total'])
                  .toString());
        });
        currentPost['media_attachments'][widget.indexImagePost]['status_media']
            ['replies_total'] = sumComment;
        ref
            .read(currentPostControllerProvider.notifier)
            .saveCurrentPost(currentPost);
        ref.read(postControllerProvider.notifier).actionUpdatePostCount(
              widget.preType,
              currentPost,
            );
      }
    }
  }

  Future handleComment(data, previewLinkText) async {
    if (widget.indexImagePost != null) {
      if (!mounted) return;
      final preCardData = await getPreviewUrl(previewLinkText);
      final cardData = preCardData != null
          ? {
              "url": preCardData[0]['link'],
              "title": preCardData[0]['title'],
              "description": preCardData[0]['description'],
              "type": "link",
              "author_name": "",
              "author_url": "",
              "provider_name": "",
              "provider_url": "",
              "html": "",
              "width": 400,
              "height": 240,
              "image": preCardData[0]['url'],
              "embed_url": "",
              "blurhash": "UNKKi:%L~A9Fvesm%MX9pdR+RPV@wajZjtt6"
            }
          : null;
      var newCommentPreview = {
        "id": data['id'],
        "in_reply_to_id": widget.post['id'],
        "account": ref.watch(meControllerProvider)[0],
        "content": data['status'],
        "typeStatus": data['typeStatus'] ?? "previewComment",
        "created_at":
            '${DateTime.now().toIso8601String().substring(0, 23)}+07:00',
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
        //  data['typeStatus'] == 'editComment'
        //     ? widget.post["replies_total"]
        //     : (widget.post["replies_total"] + 1),
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
        "card": preCardData != null ? cardData : preCardData,
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
        //Comment parent
        dataPreComment = [newCommentPreview, ...postComment];
      } else if (data['type'] == 'child' && data['typeStatus'] == 'editChild') {
        //Edit comment child
        dataPreComment = postComment;
      } else if (data['type'] == 'child' && data['typeStatus'] == null) {
        //Comment child
        dataPreComment = postComment;
      } else if (data['type'] == 'parent' &&
          data['typeStatus'] == 'editComment') {
        //Edit comment parent
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
      _updatePostCount(
          addtionalIfChild: (data['type'] == 'child' &&
                      data['typeStatus'] != 'editChild' &&
                      data['typeStatus'] != "editComment") ||
                  widget.indexImagePost != null
              ? 1
              : 0);

      dynamic newComment;
      // cal api
      final params = {
        ...data,
        "visibility": "public",
        "in_reply_to_id": data['in_reply_to_id'] ??
            widget.post['media_attachments'][widget.indexImagePost]
                ['status_media']['id']
      };
      if (!['editComment', 'editChild'].contains(data['typeStatus'])) {
        newComment = await PostApi().createStatus(params) ?? newCommentPreview;

        if (newComment['card'] == null && preCardData != null) {
          newComment["card"] = newCommentPreview["card"];
        }
      } else {
        newComment = await PostApi().updatePost(data['id'], {
          "extra_body": data['extra_body'],
          "status": data['status'],
          "tags": data['tags']
        });
        if (newComment['card'] == null ||
            (newComment["card"] != newCommentPreview["card"])) {
          newComment["card"] = newCommentPreview["card"];
        }
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

        List dataCommentUpdate = postComment;

        if (data['type'] == 'parent' && data['typeStatus'] == null) {
          //Comment parent
          dataCommentUpdate = [newComment, ...postComment.sublist(1)];
        } else if (data['type'] == 'child' &&
            data['typeStatus'] == 'editChild') {
          //Edit comment child
          dataCommentUpdate = postComment;
        } else if (data['type'] == 'child' && data['typeStatus'] == null) {
          //Comment child
          dataCommentUpdate = postComment;
        } else if (data['type'] == 'parent' &&
            data['typeStatus'] == 'editComment') {
          //Edit comment parent
          dataCommentUpdate = newListUpdate;
        }
        setState(() {
          postComment = dataCommentUpdate;
          commentChild = newComment;
        });
        if (newComment != null) {
          _updatePostCount(
              addtionalIfChild: (data['type'] == 'child' &&
                      data['typeStatus'] != 'editChild' &&
                      data['typeStatus'] != "editComment")
                  ? 1
                  : 0);
        }
      }
    } else {
      if (!mounted) return;
      final preCardData = await getPreviewUrl(previewLinkText);
      final cardData = preCardData != null
          ? {
              "url": preCardData[0]['link'],
              "title": preCardData[0]['title'],
              "description": preCardData[0]['description'],
              "type": "link",
              "author_name": "",
              "author_url": "",
              "provider_name": "",
              "provider_url": "",
              "html": "",
              "width": 400,
              "height": 240,
              "image": preCardData[0]['url'],
              "embed_url": "",
              "blurhash": "UNKKi:%L~A9Fvesm%MX9pdR+RPV@wajZjtt6"
            }
          : null;
      var newCommentPreview = {
        "id": data['id'],
        "in_reply_to_id": widget.post['id'],
        "account": ref.watch(meControllerProvider)[0],
        "content": data['status'],
        "typeStatus": data['typeStatus'] ?? "previewComment",
        "created_at":
            '${DateTime.now().toIso8601String().substring(0, 23)}+07:00',
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
        //  data['typeStatus'] == 'editComment'
        //     ? widget.post["replies_total"]
        //     : (widget.post["replies_total"] + 1),
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
        "card": preCardData != null ? cardData : preCardData,
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
        //Comment parent
        dataPreComment = [newCommentPreview, ...postComment];
      } else if (data['type'] == 'child' && data['typeStatus'] == 'editChild') {
        //Edit comment child
        dataPreComment = postComment;
      } else if (data['type'] == 'child' && data['typeStatus'] == null) {
        //Comment child
        dataPreComment = postComment;
      } else if (data['type'] == 'parent' &&
          data['typeStatus'] == 'editComment') {
        //Edit comment parent
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

      _updatePostCount(
          addtionalIfChild: data['type'] == 'child' &&
                  data['typeStatus'] != 'editChild' &&
                  data['typeStatus'] != "editComment"
              ? 1
              : 0);

      dynamic newComment;
      // cal api
      if (!['editComment', 'editChild'].contains(data['typeStatus'])) {
        newComment = await PostApi().createStatus({
              ...data,
              "visibility": "public",
              "in_reply_to_id": data['in_reply_to_id'] ?? widget.post['id']
            }) ??
            newCommentPreview;
        if (newComment['card'] == null && preCardData != null) {
          newComment["card"] = newCommentPreview["card"];
        }
      } else {
        newComment = await PostApi().updatePost(data['id'], {
          "extra_body": data['extra_body'],
          "status": data['status'],
          "tags": data['tags']
        });
        if (newComment['card'] == null ||
            (newComment["card"] != newCommentPreview["card"])) {
          newComment["card"] = newCommentPreview["card"];
        }
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

        List dataCommentUpdate = postComment;

        if (data['type'] == 'parent' && data['typeStatus'] == null) {
          //Comment parent
          dataCommentUpdate = [newComment, ...postComment.sublist(1)];
        } else if (data['type'] == 'child' &&
            data['typeStatus'] == 'editChild') {
          //Edit comment child
          dataCommentUpdate = postComment;
        } else if (data['type'] == 'child' && data['typeStatus'] == null) {
          //Comment child
          dataCommentUpdate = postComment;
        } else if (data['type'] == 'parent' &&
            data['typeStatus'] == 'editComment') {
          //Edit comment parent
          dataCommentUpdate = newListUpdate;
        }
        setState(() {
          postComment = dataCommentUpdate;
          commentChild = newComment;
        });
        if (newComment != null) {
          _updatePostCount(
              addtionalIfChild: data['type'] == 'child' &&
                      data['typeStatus'] != 'editChild' &&
                      data['typeStatus'] != "editComment"
                  ? 1
                  : 0);
        }
      }
    }
  }

  getCommentSelected(comment) {
    setState(() {
      commentSelected = comment;
    });
  }

  handleDeleteComment(post) {
    if (post != null) {
      if (widget.indexImagePost != null) {
        if (postComment.map((e) => e['id']).toList().contains(post['id'])) {
          List newPostComment = postComment
              .where((element) => element['id'] != post['id'])
              .toList();
          setState(() {
            postComment = newPostComment;
          });
          _updatePostCount(subIfChild: 1);
          return;
        } else if (post['in_reply_to_id'] != null) {
          // cap nhat so luong khi xoa cmt con
          postComment.forEach((element) {
            if (element['id'] == post['in_reply_to_id']) {
              setState(() {
                postComment = postComment;
              });
              _updatePostCount(subIfChild: 1);
            }
          });
        }
      } else {
        if (postComment.map((e) => e['id']).toList().contains(post['id'])) {
          List newPostComment = postComment
              .where((element) => element['id'] != post['id'])
              .toList();
          setState(() {
            postComment = newPostComment;
          });
          _updatePostCount();
          return;
        } else if (post['in_reply_to_id'] != null) {
          // cap nhat so luong khi xoa cmt con
          postComment.forEach((element) {
            if (element['id'] == post['in_reply_to_id']) {
              setState(() {
                postComment = postComment;
              });
              _updatePostCount(subIfChild: 1);
            }
          });
        }
      }
    }
  }

  _updatePostCount({int addtionalIfChild = 0, int subIfChild = 0}) async {
    if (widget.indexImagePost != null) {
      dynamic updateCountPostData = widget.post;
      if (updateCountPostData['media_attachments'][widget.indexImagePost]
                  ['status_media']['replies_total'] ==
              0 &&
          subIfChild != 0) {
      } else {
        updateCountPostData['media_attachments'][widget.indexImagePost]
                ['status_media']['replies_total'] =
            (updateCountPostData['media_attachments'][widget.indexImagePost]
                    ['status_media']['replies_total'] +
                addtionalIfChild -
                subIfChild);
      }
      ref
          .read(postControllerProvider.notifier)
          .actionUpdatePostCount(widget.preType, updateCountPostData);
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(updateCountPostData);
      if (widget.type == imagePhotoPage || widget.preType == imagePhotoPage) {
        widget.updateDataPhotoPage != null
            ? widget.updateDataPhotoPage!(updateCountPostData)
            : null;
      }
    } else {
      dynamic updateCountPostData = widget.post;
      dynamic count = postComment.length;
      postComment.forEach((element) {
        count += element["replies_total"];
      });
      updateCountPostData['replies_total'] =
          count + addtionalIfChild - subIfChild;
      ref
          .read(postControllerProvider.notifier)
          .actionUpdatePostCount(widget.preType, updateCountPostData);
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(updateCountPostData);
    }
    widget.reloadFunction != null ? widget.reloadFunction!() : null;
  }

  checkPreType() {
    dynamic _preType = widget.preType;

    if (_preType != null) {
      if (_preType == postPageUser) {
        return postDetailFromUserPage;
      }
      if (_preType == feedPost) {
        return postDetailFromFeed;
      }
      return _preType;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentCount = widget.indexImagePost != null
        ? (postDetail['media_attachments'][widget.indexImagePost]
                ['status_media']['replies_total'] ??
            0)
        : postDetail?['replies_count'] ?? 0;
    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: widget.type == postWatch ? Colors.grey.shade900 : null,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor:
              widget.type == postWatch ? Colors.grey.shade900 : null,
          title: AppBarTitle(
            title: 'Bình luận',
            textColor: widget.type == postWatch ? Colors.white : null,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                size: 20,
              ),
              onTap: () {
                popToPreviousScreen(context);
              },
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 0.5, color: greyColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: postComment.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildSpacer(height: 30),
                          Image.asset(
                            "assets/images/comment_icon.png",
                            height: 150,
                            width: 200,
                            color: greyColor.withOpacity(0.4),
                          ),
                          buildTextContent("Chưa có bình luận !", true,
                              fontSize: 18,
                              colorWord: greyColor,
                              isCenterLeft: false),
                          buildSpacer(height: 10),
                          buildTextContent(
                              "Hãy là người đầu tiên bình luận", false,
                              fontSize: 18,
                              colorWord: greyColor,
                              isCenterLeft: false),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: postComment.length,
                                itemBuilder: ((context, index) => CommentTree(
                                    key: Key(postComment[index]['id']),
                                    type: widget.type,
                                    commentChildCreate: postComment[index]
                                                ['id'] ==
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
                    type: widget.type,
                    commentSelected: commentSelected,
                    getCommentSelected: getCommentSelected,
                    commentNode: commentNode,
                    handleComment: handleComment),
              ),
              Container(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
