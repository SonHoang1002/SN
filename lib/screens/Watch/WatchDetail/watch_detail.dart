import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/helper/split_link.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/video_repository.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screens/Post/comment_tree.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/AnimatedWidgets/animated_fly_icon.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/comment_textfield.dart';
import 'package:social_network_app_mobile/widgets/screen_share.dart';

final selectedVideoProvider = StateProvider<dynamic>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);

double getSizeGif(type) {
  if (type == 'love') return 60;
  if (type == 'yay') return 55;
  if (type == 'haha') return 50;
  return 40;
}

class WatchDetail extends ConsumerStatefulWidget {
  final dynamic media;
  final dynamic post;
  final String? type;
  final Function? updateDataFunction;
  final String? preType;
  const WatchDetail(
      {Key? key,
      this.media,
      this.post,
      this.type,
      this.updateDataFunction,
      this.preType})
      : super(key: key);

  @override
  ConsumerState<WatchDetail> createState() => _WatchDetailState();
}

class _WatchDetailState extends ConsumerState<WatchDetail>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double topPosition = 0;
  double leftPosition = 0;
  double scale = 1;
  late TabController _tabController;
  bool isLoadComment = false;
  FocusNode commentNode = FocusNode();
  dynamic commentSelected;
  dynamic commentChild;
  List postComment = [];
  bool isHiddenAction = true;
  bool isDragVideo = false;
  bool isDismissed = false;
  bool iconFlying = false;
  Offset? offset;
  // bool isShowAnimatedReactionIcon = false;
  Size? size;
  ValueNotifier<List> listAnimtedFlyIcon = ValueNotifier([]);
  dynamic watchData;

  @override
  void initState() {
    super.initState();
    getListCommentPost(widget.media['status_media']['id'] ?? widget.post['id'],
        {"sort_by": "newest"});
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    Future.delayed(Duration.zero, () {
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(widget.post);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          watchData = widget.post;
        });
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void updateHiddenAction() {
    setState(() {
      isHiddenAction = !isHiddenAction;
    });
  }

  Widget renderVideo() {
    return !isDismissed
        ? Dismissible(
            direction: DismissDirection.vertical,
            key: Key(widget.media['id'].toString()),
            resizeDuration: const Duration(milliseconds: 1),
            onDismissed: (direction) {
              ref
                  .read(selectedVideoProvider.notifier)
                  .update((state) => widget.post);
              setState(() {
                isDismissed = true;
              });
              ref
                  .read(betterPlayerControllerProvider)
                  .chewieController!
                  .pause();
              Future.delayed(Duration.zero, () {
                popToPreviousScreen(context);
              });
            },
            child: Hero(
                tag: widget.media['remote_url'] ?? widget.media['url'],
                child: isHiddenAction
                    ? Center(
                        child: VideoPlayerHasController(
                          type: widget.type,
                          media: widget.media,
                          isHiddenControl: false,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: VideoPlayerHasController(
                          type: widget.type,
                          media: widget.media,
                          isHiddenControl: false,
                        ),
                      )),
          )
        : const SizedBox();
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
    }
  }

  handleReaction(dynamic react) async {
    final viewerReaction = (widget.post?['viewer_reaction'] ?? "");
    var newPost = watchData;
    List newFavourites = newPost['reactions'];
    int index =
        newPost['reactions'].indexWhere((element) => element['type'] == react);
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
      ref
          .read(postControllerProvider.notifier)
          .actionUpdateDetailInPost(widget.type, newPost);
      ref.read(currentPostControllerProvider.notifier).saveCurrentPost(newPost);
      widget.updateDataFunction != null ? widget.updateDataFunction!() : null;
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
      ref
          .read(postControllerProvider.notifier)
          .actionUpdateDetailInPost(widget.type, newPost);
      ref.read(currentPostControllerProvider.notifier).saveCurrentPost(newPost);
      widget.updateDataFunction != null ? widget.updateDataFunction!() : null;
      await PostApi().unReactionPostApi(widget.post['id']);
    }

    // use status_media_id to react
    // check to see if the user reacted the same way he reacted before
    // var newPost = widget.post;
    // final indexOfMediaInPost = newPost['media_attachments']
    //     .map((ele) => ele['id'])
    //     .toList()
    //     .indexOf(widget.media['id']);
    // List viewerReaction = newPost['media_attachments'][indexOfMediaInPost]
    //     ['status_media']?['viewer_reaction'];
    // if (viewerReaction != react) {
    //   dynamic data = {"custom_vote_type": react};
    //   await PostApi().reactionPostApi(
    //       widget.post['media_attachments'][indexOfMediaInPost]['status_media']
    //           ['id'],
    //       data);
    // }
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
      "in_reply_to_id": widget.media['status_media']['id'] ?? widget.post['id'],
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
            "in_reply_to_id": data['in_reply_to_id'] ??
                widget.media['status_media']['id'] ??
                widget.post['id']
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
    }
  }

  _updatePostCount({int? addtionalIfChild, int? subIfChild}) {
    if (widget.media != null) {
      dynamic updateCountPostData = widget.post;
      dynamic count = widget.media['status_media']['replies_total'];
      final listIdMedia =
          widget.post['media_attachments'].map((e) => e['id']).toList();
      final indexOfMedia = listIdMedia.indexOf(widget.media['id']);
      updateCountPostData['media_attachments'][indexOfMedia]['status_media']
              ['replies_total'] =
          count + (addtionalIfChild ?? 0) - (subIfChild ?? 0);
      ref
          .read(postControllerProvider.notifier)
          .actionUpdatePostCount(widget.type, updateCountPostData);
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(updateCountPostData);
      widget.updateDataFunction != null ? widget.updateDataFunction!() : null;
      return;
    } else {
      int countAdditionalIfChild = addtionalIfChild ?? 0;
      int countSubIfChild = subIfChild ?? 0;
      dynamic updateCountPostData = widget.post;
      dynamic count = updateCountPostData['replies_total'];
      postComment.forEach((element) {
        count += element["replies_total"];
      });
      updateCountPostData['replies_total'] =
          count + countAdditionalIfChild - countSubIfChild;
      ref
          .read(postControllerProvider.notifier)
          .actionUpdatePostCount(widget.type, updateCountPostData);
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(updateCountPostData);
      widget.updateDataFunction != null ? widget.updateDataFunction!() : null;
    }
  }

  Widget renderPostInformation(size) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PostHeader(post: widget.post, textColor: white, type: postDetail),
            Container(
              color: !isHiddenAction ? blackColor.withOpacity(0.5) : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isHiddenAction)
                    Column(
                      children: [
                        Container(
                          constraints:
                              BoxConstraints(maxHeight: size.height / 5.2),
                          child:
                              TabBarView(controller: _tabController, children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: PostContent(
                                    post: widget.post,
                                    textColor: white,
                                  ),
                                ),
                              ],
                            ),
                            ListComment(
                                postComment: postComment,
                                commentChild: commentChild,
                                commentNode: commentNode,
                                commentSelected: commentSelected,
                                getCommentSelected: getCommentSelected,
                                handleDeleteComment: handleDeleteComment,
                                type: widget.type)
                          ]),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RotateIcon(updateHiddenAction: updateHiddenAction),
                        if (!isHiddenAction)
                          TabBar(
                              isScrollable: true,
                              controller: _tabController,
                              onTap: (index) {},
                              indicator: const BoxDecoration(),
                              indicatorWeight: 0,
                              labelColor: Colors.white,
                              unselectedLabelColor:
                                  Colors.white.withOpacity(0.5),
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: const [
                                Tab(
                                  text: "Tổng quan",
                                ),
                                Tab(
                                  text: "Bình luận",
                                )
                              ]),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: BottomAction(
                      widget: widget,
                      isHiddenAction: isHiddenAction,
                      handleComment: handleComment,
                      commentNode: commentNode,
                      getCommentSelected: getCommentSelected,
                      commentSelected: commentSelected,
                      handleReaction: handleReaction,
                      handleAdditionalAction: (String reactitonName) {
                        setState(() {
                          listAnimtedFlyIcon.value.add(reactitonName);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        ...buildAnimtedFlyIconWidget()
      ],
    );
  }

  List<Widget> buildAnimtedFlyIconWidget() {
    List<Widget> listWidget = [];
    for (int i = 0; i < listAnimtedFlyIcon.value.length; i++) {
      listWidget.add(AnimatedFlyIconWidget(
          key: GlobalKey(
              debugLabel:
                  "${listAnimtedFlyIcon.value[i]}${Random().nextDouble()}"),
          reactName: listAnimtedFlyIcon.value[i],
          onEnd: () {
            setState(() {
              listAnimtedFlyIcon.value = [];
              listAnimtedFlyIcon.value.remove(i);
            });
          }));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    watchData = ref.watch(currentPostControllerProvider).currentPost;
    return GestureDetector(
        onTap: () {
          hiddenKeyboard(context);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.media['preview_remote_url'] ??
                        widget.media['preview_url']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Center(child: renderVideo()),
                          renderPostInformation(size)
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  @override
  bool get wantKeepAlive => true;
}

class RotateIcon extends StatefulWidget {
  final Function updateHiddenAction;
  const RotateIcon({
    super.key,
    required this.updateHiddenAction,
  });

  @override
  State<RotateIcon> createState() => _RotateIconState();
}

class _RotateIconState extends State<RotateIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isRotated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation =
        Tween<double>(begin: 0, end: 180).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    setState(() {
      _isRotated = !_isRotated;
      if (_isRotated) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    widget.updateHiddenAction();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleRotation();
      },
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.3),
        ),
        child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                  angle: _animation.value * (3.1415926535 / 180),
                  child: const Icon(FontAwesomeIcons.chevronDown,
                      size: 15, color: white));
            }),
      ),
    );
  }
}

class ListComment extends StatelessWidget {
  const ListComment(
      {super.key,
      required this.postComment,
      required this.commentChild,
      required this.commentNode,
      required this.commentSelected,
      this.getCommentSelected,
      this.handleDeleteComment,
      this.type});

  final List postComment;
  final dynamic commentChild;
  final FocusNode commentNode;
  final dynamic commentSelected;
  final Function? getCommentSelected;
  final Function? handleDeleteComment;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // shrinkWrap: true,
        reverse: true,
        itemCount: postComment.length,
        itemBuilder: ((context, index) {
          return CommentTree(
            key: Key(postComment[index]['id']),
            type: postWatchDetail,
            commentChildCreate:
                postComment[index]['id'] == commentChild?['in_reply_to_id']
                    ? commentChild
                    : null,
            commentNode: commentNode,
            commentSelected: commentSelected,
            commentParent: postComment[index],
            getCommentSelected: getCommentSelected,
            handleDeleteComment: handleDeleteComment,
            preType: type,
          );
        }));
  }
}

class BottomAction extends StatefulWidget {
  final bool isHiddenAction;
  final Function handleComment;
  final dynamic commentNode;
  final dynamic commentSelected;
  final Function? getCommentSelected;
  final Function(dynamic data)? handleReaction;
  final Function? handleAdditionalAction;
  const BottomAction(
      {super.key,
      required this.widget,
      required this.isHiddenAction,
      required this.handleComment,
      required this.commentNode,
      required this.commentSelected,
      required this.getCommentSelected,
      required this.handleReaction,
      this.handleAdditionalAction});

  final WatchDetail widget;

  @override
  State<BottomAction> createState() => _BottomActionState();
}

class _BottomActionState extends State<BottomAction> {
  @override
  Widget build(BuildContext context) {
    const listReaction = ['like', 'love', 'yay', 'haha', 'wow', 'sad', 'angry'];
    return !widget.isHiddenAction
        ? Column(
            children: [
              buildDivider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: widget.commentSelected != null ? 20 : 0),
                      child: GestureDetector(
                        onTap: () {
                          showBarModalBottomSheet(
                              context: context,
                              barrierColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: ScreenShare(
                                      entityShare: widget.widget.post,
                                      type: 'post',
                                      entityType: 'post')));
                        },
                        child: Icon(
                          FontAwesomeIcons.share,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 70,
                        child: CommentTextfield(
                            commentSelected: widget.commentSelected,
                            getCommentSelected: widget.getCommentSelected,
                            commentNode: widget.commentNode,
                            autoFocus: false,
                            type: postWatchDetail,
                            handleComment: widget.handleComment)),
                    Container(
                      padding: EdgeInsets.only(
                          top: widget.commentSelected != null ? 20 : 0),
                      child: Row(
                          children: listReaction
                              .map((String el) => Stack(
                                    children: [
                                      Container(
                                          alignment: Alignment.bottomCenter,
                                          padding: EdgeInsets.only(
                                              left: 2,
                                              right: 2,
                                              bottom: el == 'yay' ? 10 : 0),
                                          height: 70,
                                          child: LikeButton(
                                            size: getSizeGif(el),
                                            circleColor: const CircleColor(
                                                start: primaryColor,
                                                end: secondaryColor),
                                            bubblesColor: const BubblesColor(
                                              dotPrimaryColor: primaryColor,
                                              dotSecondaryColor: secondaryColor,
                                            ),
                                            likeBuilder: (bool isLiked) {
                                              return renderGif('gif', el,
                                                  size: getSizeGif(el));
                                            },
                                            onTap: (value) async {
                                              widget.handleReaction!(el);
                                              widget.handleAdditionalAction !=
                                                      null
                                                  ? widget
                                                      .handleAdditionalAction!(el)
                                                  : null;
                                            },
                                          )),
                                      // widget.media['status_media']['viewer_reaction'] == el
                                      //     ?
                                      // Positioned(
                                      //   bottom: 0,
                                      //   left: 0,
                                      //   right: 0,
                                      //   child: Center(
                                      //     child: Container(
                                      //       decoration: BoxDecoration(
                                      //           color: secondaryColor,
                                      //           borderRadius:
                                      //               BorderRadius.circular(5)),
                                      //       height: 10,
                                      //       width: 10,
                                      //     ),
                                      //   ),
                                      // )
                                      // : const SizedBox()
                                    ],
                                  ))
                              .toList()),
                    )
                  ],
                ),
              ),
            ],
          )
        : const SizedBox(
            height: 71,
          );
  }
}
