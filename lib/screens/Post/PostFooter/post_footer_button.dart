import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/helper/split_link.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screens/Post/comment_tree.dart';
import 'package:social_network_app_mobile/screens/Post/post_detail.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_comment.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Reaction/flutter_reaction_button.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/comment_textfield.dart';
import 'package:social_network_app_mobile/widgets/screen_share.dart';

String suggestReaction = "Trượt ngón tay để chọn";
String cancelReaction = "Buông ra để hủy";

class PostFooterButton extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  final String? preType;

  /// Reload post one media screen when user see iamge in photo page on page screen
  final Function? updateDataPhotoPage;
  final Function? reloadFunction;
  final int? indexImage;

  /// Reload post detail screen
  final Function? reloadDetailFunction;
  final bool? isShowCommentBox;
  final bool? fromOneMediaPost;

  /// Update data from post and post detail screen
  final Function(dynamic)? updateDataFunction;

  /// Transfer current offset of textformfield to scroll post listview
  final Function(Offset)? jumpToOffsetFunction;
  final dynamic friendData;
  final dynamic groupData;
  final bool? isInGroup;

  const PostFooterButton(
      {Key? key,
      this.post,
      this.type,
      this.updateDataPhotoPage,
      this.reloadFunction,
      this.preType,
      this.indexImage,
      this.reloadDetailFunction,
      this.isShowCommentBox,
      this.updateDataFunction,
      this.fromOneMediaPost = false,
      this.jumpToOffsetFunction,
      this.friendData,
      this.groupData,
      this.isInGroup})
      : super(key: key);

  @override
  ConsumerState<PostFooterButton> createState() => _PostFooterButtonState();
}

class _PostFooterButtonState extends ConsumerState<PostFooterButton>
    with TickerProviderStateMixin {
  // bool suggestReactionStatus = false;
  String suggestReactionContent = "";
  dynamic postData;
  List postComment = [];
  dynamic commentSelected;
  FocusNode commentNode = FocusNode();
  String viewerReaction = "";
  final GlobalKey textFieldGlobalKey = GlobalKey();
  @override
  void initState() {
    commentNode.addListener(() {
      if (commentNode.hasFocus) {
        RenderBox renderBox =
            textFieldGlobalKey.currentContext!.findRenderObject() as RenderBox;

        widget.jumpToOffsetFunction != null
            ? widget.jumpToOffsetFunction!(renderBox.localToGlobal(Offset.zero))
            : null;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    suggestReactionContent = "";
    postData = null;
    postComment = [];
    commentSelected = null;
    commentNode.dispose();
  }

  List buttonAction = [
    {
      "key": "comment",
      "icon": "assets/reaction/comment_light.png",
      "label": "Bình luận",
    },
    {
      "key": "share",
      "icon": "assets/reaction/share_light.png",
      "label": "Chia sẻ",
    }
  ];

  handlePress(key) {
    if (key == 'comment') {
      if (![postDetail, postMultipleMedia, postWatch, imagePhotoPage]
              .contains(widget.type) &&
          widget.fromOneMediaPost == false) {
        pushCustomCupertinoPageRoute(
            context,
            PostDetail(
                post: widget.post,
                preType: widget.type,
                isInGroup: widget.isInGroup,
                groupData: widget.groupData,
                updateDataFunction: widget.updateDataFunction));
      } else if (([postMultipleMedia, imagePhotoPage].contains(widget.type)) ||
          widget.fromOneMediaPost == true) {
        showBarModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => CommentPostModal(
                post: widget.post,
                preType: widget.preType,
                indexImagePost: widget.indexImage,
                reloadFunction: widget.reloadDetailFunction,
                updateDataPhotoPage: widget.updateDataPhotoPage));
      } else if (widget.type == postWatch) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => WatchComment(post: widget.post)));
      }
    } else if (key == 'share') {
      showBarModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ScreenShare(
              entityShare: widget.post, type: widget.type, entityType: 'post'));
    }
  }

  handleReaction(react) async {
    // only update reaction in image in media_attachments
    if (([postMultipleMedia, imagePhotoPage].contains(widget.type)) &&
        widget.post['media_attachments'].isNotEmpty &&
        widget.indexImage != null) {
      var newPost = widget.post;
      List newFavourites = newPost['media_attachments'][widget.indexImage]
          ['status_media']?['reactions'];
      int index = newPost['media_attachments'][widget.indexImage]
              ['status_media']?['reactions']
          .indexWhere((element) => element['type'] == react);
      int indexCurrent = viewerReaction.isNotEmpty && react != viewerReaction
          ? (newPost['media_attachments'][widget.indexImage]['status_media']
                  ?['reactions'])
              .indexWhere((element) => element['type'] == viewerReaction)
          : -1;
      if (index >= 0) {
        newPost['media_attachments'][widget.indexImage]['status_media']
            ?['reactions'][index] = {
          "type": react,
          "${react}s_count": newFavourites[index]['${react}s_count'] + 1
        };
      }
      if (indexCurrent >= 0) {
        newPost['media_attachments'][widget.indexImage]['status_media']
            ?['reactions'][indexCurrent] = {
          "type": viewerReaction,
          "${viewerReaction}s_count":
              newFavourites[indexCurrent]["${viewerReaction}s_count"] - 1
        };
      }

      if (react != null) {
        dynamic data = {"custom_vote_type": react};
        newPost['media_attachments'][widget.indexImage]['status_media']
            ['favourites_count'] = newPost['media_attachments']
                    [widget.indexImage]['status_media']?['viewer_reaction'] !=
                null
            ? (newPost['media_attachments'][widget.indexImage]?['status_media']
                ['favourites_count'])
            : (newPost['media_attachments'][widget.indexImage]['status_media']
                    ?['favourites_count']) +
                1;
        newPost['media_attachments'][widget.indexImage]['status_media']
            ?['viewer_reaction'] = react;
        if (newPost['media_attachments'].length == 1) {
          newPost['viewer_reaction'] = react;
        }
        newPost['media_attachments'][widget.indexImage]['status_media']
            ?['reactions'] = newFavourites;
        ref.read(postControllerProvider.notifier).actionUpdateDetailInPost(
            widget.type, newPost,
            preType: widget.preType,
            isIdCurrentUser: widget.friendData != null
                ? ref.watch(meControllerProvider)[0]['id'] ==
                    widget.friendData['id']
                : true);
        ref
            .read(currentPostControllerProvider.notifier)
            .saveCurrentPost(newPost);
        widget.updateDataFunction != null
            ? widget.updateDataFunction!(newPost)
            : null;
        if (widget.type == imagePhotoPage) {
          widget.updateDataPhotoPage != null
              ? widget.updateDataPhotoPage!(newPost)
              : null;
        }
        await PostApi().reactionPostApi(
            widget.post['media_attachments'][widget.indexImage]['status_media']
                ['id'],
            data);
      } else {
        newPost['media_attachments'][widget.indexImage]['status_media']
            ['favourites_count'] = newPost['media_attachments']
                    [widget.indexImage]['status_media']['viewer_reaction'] !=
                null
            ? newPost['media_attachments'][widget.indexImage]['status_media']
                    ['favourites_count'] -
                1
            : newPost['media_attachments'][widget.indexImage]['status_media']
                ['favourites_count'];
        newPost['media_attachments'][widget.indexImage]['status_media']
            ?['viewer_reaction'] = null;
        if (newPost['media_attachments'].length == 1) {
          newPost['viewer_reaction'] = null;
        }
        newPost['media_attachments'][widget.indexImage]['status_media']
            ?['reactions'] = newFavourites;
        ref.read(postControllerProvider.notifier).actionUpdateDetailInPost(
            widget.type, newPost,
            preType: widget.preType,
            isIdCurrentUser: widget.friendData != null
                ? ref.watch(meControllerProvider)[0]['id'] ==
                    widget.friendData['id']
                : true);
        ref
            .read(currentPostControllerProvider.notifier)
            .saveCurrentPost(newPost);
        if (widget.type == imagePhotoPage) {
          widget.updateDataPhotoPage != null
              ? widget.updateDataPhotoPage!(newPost)
              : null;
        }
        await PostApi().unReactionPostApi(widget.post['media_attachments']
            [widget.indexImage]['status_media']['id']);
        widget.updateDataFunction != null
            ? widget.updateDataFunction!(newPost)
            : null;
      }
      widget.reloadDetailFunction != null
          ? widget.reloadDetailFunction!()
          : null;
    } else {
      // only update reaction in post
      var newPost = widget.post;
      List newFavourites = newPost?['reactions'] ??
          newPost?["avatar_media"]?["status_media"]?['reactions'];
      int index = newPost?['reactions']
          .indexWhere((element) => element['type'] == react);
      int indexCurrent = viewerReaction.isNotEmpty && react != viewerReaction
          ? newPost['reactions']
              .indexWhere((element) => element['type'] == viewerReaction)
          : -1;
      if (index >= 0) {
        newFavourites[index] = {
          "type": react,
          "${react}s_count": newFavourites[index]['${react}s_count'] + 1
        };
      }

      if (indexCurrent >= 0) {
        newFavourites[indexCurrent] = {
          "type": viewerReaction,
          "${viewerReaction}s_count":
              newFavourites[indexCurrent]["${viewerReaction}s_count"] - 1
        };
      }

      if (react != null) {
        dynamic data = {"custom_vote_type": react};
        newPost = {
          ...newPost,
          "favourites_count": newPost['viewer_reaction'] != null
              ? newPost['favourites_count']
              : newPost['favourites_count'] + 1,
          "viewer_reaction": react,
          "reactions": newFavourites
        };
        if (widget.type == postWatch) {
          ref.read(watchControllerProvider.notifier).updateWatchDetail(
                widget.preType ?? widget.type,
                newPost,
              );
        }
        ref.read(postControllerProvider.notifier).actionUpdateDetailInPost(
            widget.type, newPost,
            preType: widget.preType,
            isIdCurrentUser: widget.friendData != null
                ? ref.watch(meControllerProvider)[0]['id'] ==
                    widget.friendData['id']
                : true);
        ref
            .read(currentPostControllerProvider.notifier)
            .saveCurrentPost(newPost);
        widget.updateDataFunction != null
            ? widget.updateDataFunction!(newPost)
            : null;
        await PostApi().reactionPostApi(widget.post['id'], data);
      } else {
        newPost = {
          ...newPost,
          "favourites_count": newPost['favourites_count'] != null
              ? newPost['favourites_count'] - 1
              : newPost['favourites_count'],
          "viewer_reaction": null,
          "reactions": newFavourites
        };
        ref.read(postControllerProvider.notifier).actionUpdateDetailInPost(
            widget.type, newPost,
            preType: widget.preType,
            isIdCurrentUser: widget.friendData != null
                ? ref.watch(meControllerProvider)[0]['id'] ==
                    widget.friendData['id']
                : true);
        ref
            .read(currentPostControllerProvider.notifier)
            .saveCurrentPost(newPost);
        widget.updateDataFunction != null
            ? widget.updateDataFunction!(newPost)
            : null;
        await PostApi().unReactionPostApi(widget.post['id']);
      }
      widget.reloadFunction != null ? widget.reloadFunction!(newPost) : null;
    }
  }

  handlePressButton() {
    if (viewerReaction.isNotEmpty) {
      handleReaction(null);
    } else {
      handleReaction('like');
    }
  }

  @override
  Widget build(BuildContext context) {
    viewerReaction = (widget.indexImage != null &&
            widget.post['media_attachments'].isNotEmpty
        ? (widget.post['media_attachments'][widget.indexImage]?['status_media']
                ?['viewer_reaction'] ??
            widget.post['viewer_reaction'] ??
            '')
        : (widget.post?['viewer_reaction'] ?? ""));
    postData ??= widget.post;
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                suggestReactionContent = "";
              });
            },
            child: suggestReactionContent == ""
                ? SizedBox(
                    height: 30,
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ReactionButton(
                            onReactionChanged: (value) {
                              handleReaction(value);
                            },
                            handlePressButton: handlePressButton,
                            onWaitingReaction: () {
                              setState(() {
                                suggestReactionContent = "Trượt để chọn";
                                // suggestReactionStatus = false;
                              });
                            },
                            onCancelReaction: () {
                              setState(() {
                                suggestReactionContent = "";
                              });
                            },
                            reactions: <Reaction>[
                              Reaction(
                                previewIcon: renderGif('gif', 'like'),
                                icon: renderGif('png', 'like', size: 20),
                                value: 'like',
                              ),
                            ],
                            initialReaction: Reaction(
                                icon: viewerReaction.isNotEmpty
                                    ? viewerReaction != "like"
                                        ? renderGif(
                                            'png',
                                            viewerReaction,
                                            size: 20,
                                            iconPadding: 5,
                                          )
                                        : Container(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 4,
                                                bottom: 1),
                                            child: const ButtonLayout(
                                              button: {
                                                "key": "reaction",
                                                "icon":
                                                    "assets/reaction/img_like_fill.png",
                                                "label": "Thích",
                                                "textColor": secondaryColor,
                                                "color": secondaryColor
                                              },
                                            ),
                                          )
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 6,
                                            bottom: 1),
                                        child: const ButtonLayout(
                                          button: {
                                            "key": "reaction",
                                            "icon":
                                                "assets/reaction/like_light.png",
                                            "label": "Thích"
                                          },
                                        ),
                                      ),
                                value: 'kakakak'),
                          ),
                        ),
                        ...List.generate(
                            buttonAction.length,
                            (index) => Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      handlePress(buttonAction[index]['key']);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        // left: 8,
                                        // right: 8,
                                        top: 6,
                                      ),
                                      child: Container(
                                          margin: index == 1
                                              ? const EdgeInsets.only(right: 20)
                                              : null,
                                          child: ButtonLayout(
                                              button: buttonAction[index])),
                                    ),
                                  ),
                                )),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 30,
                    child: buildTextContent(suggestReactionContent, false,
                        isCenterLeft: false),
                  )),
        widget.isShowCommentBox == true
            ? Column(
                children: [
                  buildSpacer(height: 5),
                  buildDivider(color: greyColor),
                  buildSpacer(height: 7),
                ],
              )
            : const SizedBox(),
        postComment.isNotEmpty
            ? ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: postComment.length,
                itemBuilder: ((context, index) => CommentTree(
                    key: Key(postComment[index]['id'] ??
                        (Random().nextInt(10000).toString())),
                    // commentChildCreate: postComment[index]
                    //             ['id'] ==
                    //         commentChild?['in_reply_to_id']
                    //     ? commentChild
                    //     : null,
                    preType: widget.preType,
                    commentNode: commentNode,
                    commentSelected: commentSelected,
                    commentParent: postComment[index],
                    getCommentSelected: getCommentSelected,
                    handleDeleteComment: handleDeleteComment,
                    boxCommentReplyFunction: () {
                      pushCustomCupertinoPageRoute(
                          context,
                          pushCustomCupertinoPageRoute(
                              context,
                              PostDetail(
                                  post: widget.post,
                                  preType: widget.type,
                                  isInGroup: widget.isInGroup,
                                  groupData: widget.groupData,
                                  updateDataFunction:
                                      widget.updateDataFunction)));
                    })))
            : const SizedBox(),
        widget.isShowCommentBox == true ? _buildCommentBox() : const SizedBox()
      ],
    );
  }

  getCommentSelected(comment) {
    setState(() {
      commentSelected = comment;
    });
  }

  Widget _buildCommentBox() {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 5.0,
                ),
                child: AvatarSocial(
                    width: 35,
                    height: 35,
                    object: ref.watch(meControllerProvider)[0],
                    path: ref.watch(meControllerProvider)[0]['avatar_media']
                            ?['preview_url'] ??
                        linkAvatarDefault),
              ),
              Flexible(
                  child: CommentTextfield(
                      key: textFieldGlobalKey,
                      handleComment: handleComment,
                      commentNode: commentNode,
                      autoFocus: false,
                      isOnBoxComment: true)),
            ],
          ),
        ],
      ),
    );
  }

  Future handleComment(data, previewLinkText) async {
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
      "in_reply_to_id": postData['id'],
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
      "tags": data['tags'],
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
    }
    setState(() {
      postComment = dataPreComment;
    });
    _updatePostCount(addtionalIfChild: 1);

    dynamic newComment;
    // cal api
    if (!['editComment', 'editChild'].contains(data['typeStatus'])) {
      newComment = await PostApi().createStatus({
            ...data,
            "visibility": "public",
            "in_reply_to_id": data['in_reply_to_id'] ?? postData['id']
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

      if (indexComment > -1) {}

      List dataCommentUpdate = postComment;

      if (data['type'] == 'parent' && data['typeStatus'] == null) {
        //Comment parent
        dataCommentUpdate = [newComment, ...postComment.sublist(1)];
      }
      setState(() {
        postComment = dataCommentUpdate;
      });
    }
  }

  handleDeleteComment(post) {
    if (post != null) {
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
        for (var element in postComment) {
          if (element['id'] == post['in_reply_to_id']) {
            setState(() {
              postComment = postComment;
            });
            _updatePostCount(subIfChild: 1);
          }
        }
      }
    }
  }

  _updatePostCount({int? addtionalIfChild, int? subIfChild}) {
    int countAdditionalIfChild = addtionalIfChild ?? 0;
    int countSubIfChild = subIfChild ?? 0;
    dynamic updateCountPostData = postData;
    dynamic count = updateCountPostData['replies_total'];
    for (var element in postComment) {
      count += element["replies_total"];
    }
    updateCountPostData['replies_total'] =
        count + countAdditionalIfChild - countSubIfChild;
    ref
        .read(postControllerProvider.notifier)
        .actionUpdatePostCount(widget.preType, updateCountPostData);
    ref
        .read(currentPostControllerProvider.notifier)
        .saveCurrentPost(updateCountPostData);
    widget.updateDataFunction != null
        ? widget.updateDataFunction!(updateCountPostData)
        : null;
  }
}

class ButtonLayout extends StatelessWidget {
  final dynamic button;
  const ButtonLayout({
    super.key,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          button['icon'] is IconData
              ? Icon(
                  button['icon'],
                  size: 18,
                  color: button["color"] ?? greyColor,
                )
              : Image.asset(
                  button['icon'],
                  height: 15,
                  color: button["color"] ?? greyColor,
                ),
          const SizedBox(
            width: 3,
          ),
          Text(
            button['label'],
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: button["textColor"] ?? greyColor,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}
