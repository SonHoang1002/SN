
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/split_link.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_post.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Home/bottom_navigator_bar_emso.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/comment_textfield.dart';

import 'comment_tree.dart';

class PostDetail extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic preType;
  final int? indexImagePost;
  final bool? isInGroup;
  final Function(dynamic)? updateDataFunction;
  final dynamic postId;
  const PostDetail(
      {Key? key,
      this.preType,
      this.post,
      this.indexImagePost,
      this.updateDataFunction,
      this.postId,
      this.isInGroup})
      : super(key: key);

  @override
  ConsumerState<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends ConsumerState<PostDetail> {
  List postComment = [];
  bool isLoadComment = false;
  FocusNode commentNode = FocusNode();
  dynamic commentSelected;
  dynamic commentChild;
  dynamic postData;
  dynamic preUpdateData;
  int _selectedIndex = 0;
  List<dynamic> filterCommentList = [
    {
      'key': "fit",
      "title": "Phù hợp nhất",
      "description":
          "Hiển thị bình luận của bạn bè và những bình luận có nhiều tương tá nhất trước tiên"
    },
    {
      'key': "new",
      "title": "Mới nhất",
      "description":
          "Hiển thị bình luận mới nhất trước tiên. Một số bình luận đã được lọc ra"
    },
    {
      'key': "all",
      "title": "Tất cả bình luận",
      "description":
          "Hiển thị tất cả bình luận, bao gồm cả nội dung có thể là spam. Những bình luận phù hợp nhất sẽ hiển thị đầu tiên"
    },
  ];
  dynamic _filterSelection;
  dynamic postFromNoti;

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
      // data['typeStatus'] == 'editComment'
      //     ? postData["replies_total"]
      //     : (postData["replies_total"] + 1),
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
            "in_reply_to_id": data['in_reply_to_id'] ?? postData['id']
          }) ??
          newCommentPreview;
      if (newComment['card'] == null && preCardData != null) {
        // newComment["card"] = getPreviewData(preCardData);
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
      } else if (data['type'] == 'child' && data['typeStatus'] == 'editChild') {
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

  getCommentSelected(comment) {
    setState(() {
      commentSelected = comment;
    });
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
        _updatePostCount();
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
    dynamic count = postComment.length;
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

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      Future.delayed(Duration.zero, () async {
        final response = await PostApi().getPostApi(widget.postId);
        if (response != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ref
                .read(postControllerProvider.notifier)
                .createUpdatePost(feedPost, response);
            setState(() {
              postFromNoti = response;
            });
          });
        }
      });
    }
    Future.delayed(Duration.zero, () {
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(postFromNoti ?? widget.post);
    });
    getListCommentPost(
        widget.postId ?? widget.post['id'], {"sort_by": "newest"});
    _filterSelection = filterCommentList[0];
    // ref.read(postControllerProvider).postsPin.forEach((element) {
    //   if (element['id'] == widget.post['id']) {
    //     postData = element;
    //     return;
    //   }
    // });
    if (widget.postId == null) {
      postData =
          ref.read(currentPostControllerProvider).currentPost ?? widget.post;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkPreType() {
    dynamic preType = widget.preType;
    if (preType != null) {
      if (preType == postPageUser) {
        return postDetailFromUserPage;
      }
      if (preType == feedPost) {
        return postDetailFromFeed;
      }
      return preType;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(currentPostControllerProvider).currentPost != null &&
        ref.watch(currentPostControllerProvider).currentPost.isNotEmpty) {
      postData = ref.watch(currentPostControllerProvider).currentPost;
    } else {
      if (widget.postId != null) {
        postData = postFromNoti;
      } else {
        postData = widget.post;
      }
    }

    final commentCount = postData?['replies_count'] ?? 0;
    return GestureDetector(
        onTap: () {
          hiddenKeyboard(context);
        },
        child: postData != null
            ? Scaffold(
                resizeToAvoidBottomInset: true,
                // appBar: AppBar(
                //   elevation: 0,
                //   automaticallyImplyLeading: false,
                //   title: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const BackIconAppbar(),
                //       Flexible(
                //         child: SizedBox(
                //           child: PostHeader(
                //             post: postData,
                //             type: postDetail,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                body: SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      hiddenKeyboard(context);
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    // color: blueColor,
                                    child: const BackIconAppbar()),
                                Expanded(
                                  child: SizedBox(
                                    child: PostHeader(
                                      post: postData,
                                      type: postDetail,
                                      isInGroup: widget.isInGroup,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PostCenter(
                                      post: postData,
                                      type: postDetail,
                                      preType: checkPreType(),
                                      backFunction: () async {
                                        List newList = [];
                                        while (newList.isEmpty) {
                                          newList = await PostApi()
                                                  .getListCommentPost(
                                                      widget.postId ??
                                                          widget.post["id"],
                                                      {"sort_by": "newest"}) ??
                                              [];
                                        }
                                        setState(() {
                                          postComment = newList;
                                        });
                                      },
                                      updateDataFunction:
                                          widget.updateDataFunction),
                                  PostFooter(
                                      post: postData,
                                      type: postDetail,
                                      preType: checkPreType(),
                                      // reloadDetailFunction: () {
                                      //   setState(() {});
                                      // },
                                      updateDataFunction:
                                          widget.updateDataFunction),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      buildFilterCommentSelectionBottomSheet();
                                    },
                                    child: Row(
                                      children: [
                                        buildSpacer(width: 10),
                                        buildTextContent(
                                            _filterSelection['title'], false,
                                            colorWord: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color),
                                        buildSpacer(width: 7),
                                        Icon(
                                          FontAwesomeIcons.chevronDown,
                                          size: 15,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                        )
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: postComment.length,
                                      itemBuilder: ((context, index) =>
                                          CommentTree(
                                            key: Key(postComment[index]['id']),
                                            commentChildCreate:
                                                postComment[index]['id'] ==
                                                        commentChild?[
                                                            'in_reply_to_id']
                                                    ? commentChild
                                                    : null,
                                            preType: widget.preType,
                                            commentNode: commentNode,
                                            commentSelected: commentSelected,
                                            commentParent: postComment[index],
                                            getCommentSelected:
                                                getCommentSelected,
                                            handleDeleteComment:
                                                handleDeleteComment,
                                          ))),
                                  commentCount - postComment.length > 0
                                      ? InkWell(
                                          onTap: isLoadComment
                                              ? null
                                              : () {
                                                  getListCommentPost(
                                                      postData['id'], {
                                                    "max_id":
                                                        postComment.last['id'],
                                                    "sort_by": "newest"
                                                  });
                                                },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 12.0,
                                                top: 6.0,
                                                bottom: 6.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Xem thêm ${commentCount - postComment.length} bình luận",
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: greyColor,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                autoFocus: false,
                                handleComment: handleComment),
                          )
                        ]),
                  ),
                ),
                bottomNavigationBar: BottomNavigatorBarEmso(
                  onTap: _onItemTapped,
                  selectedIndex: _selectedIndex,
                ),
              )
            : buildCircularProgressIndicator());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      showBarModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (context) => const CreatePost());
    }
  }

  _callApiFilterComment(dynamic key) {}

  buildFilterCommentSelectionBottomSheet() {
    showCustomBottomSheet(context, 450,
        title: "Sắp xếp theo",
        isHaveCloseButton: false,
        bgColor: Colors.grey[300], widget: StatefulBuilder(
      builder: (ctx, setStatefull) {
        return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: filterCommentList.length,
            itemBuilder: (context, index) {
              final data = filterCommentList[index];
              return InkWell(
                child: Column(
                  children: [
                    GeneralComponent(
                      [
                        buildTextContent(data["title"], true),
                        buildSpacer(height: 5),
                        buildTextContent(data["description"], false,
                            colorWord: greyColor),
                      ],
                      changeBackground: transparent,
                      padding: const EdgeInsets.all(16),
                      suffixWidget: Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor),
                        groupValue: _filterSelection['key'],
                        value: data['key'],
                        onChanged: (value) async {
                          setState(() {
                            _filterSelection = data;
                          });
                          setStatefull(() {});
                          await _callApiFilterComment(data['key']);
                          popToPreviousScreen(context);
                        },
                      ),
                      function: () async {
                        setState(() {
                          _filterSelection = data;
                        });
                        setStatefull(() {});
                        await _callApiFilterComment(data['key']);
                        popToPreviousScreen(context);
                      },
                    ),
                    buildSpacer(height: 10)
                  ],
                ),
              );
            });
      },
    ));
  }
}
