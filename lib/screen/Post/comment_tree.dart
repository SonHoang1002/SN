import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_card.dart';
import 'package:social_network_app_mobile/screen/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/Reaction/flutter_reaction_button.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/reaction_list.dart';
import 'package:social_network_app_mobile/widget/report_category.dart';
import 'package:transparent_image/transparent_image.dart';

class CommentTree extends StatefulWidget {
  const CommentTree(
      {Key? key,
      this.commentParent,
      this.commentNode,
      this.getCommentSelected,
      this.commentSelected,
      this.commentChildCreate})
      : super(key: key);

  final dynamic commentChildCreate;
  final dynamic commentParent;
  final dynamic commentSelected;

  final FocusNode? commentNode;
  final Function? getCommentSelected;

  @override
  State<CommentTree> createState() => _CommentTreeState();
}

class _CommentTreeState extends State<CommentTree> {
  bool isShowCommentChild = false;
  bool isLoadCommentChild = false;
  List<Comment> commentChild = [];
  List postChildComment = [];
  int replyCount = 0;

  Future getListCommentChild() async {
    setState(() {
      isLoadCommentChild = true;
    });
    List newList =
        await PostApi().getListCommentPost(widget.commentParent['id'], null) ??
            [];
    setState(() {
      postChildComment = newList;
    });

    List<Comment>? newListCommentChild = newList
        .map((e) => Comment(
            avatar: e['account']['avatar_media'] != null
                ? e['account']['avatar_media']['preview_url']
                : linkAvatarDefault,
            userName: e['account']['display_name'],
            content: e['id']))
        .toList();
    setState(() {
      isLoadCommentChild = false;
      isShowCommentChild = true;
      commentChild = newListCommentChild;
    });
  }

  @override
  void initState() {
    commentChild = widget.commentParent['replies_total'] > 0
        ? [Comment(avatar: 'icon', userName: 'null', content: '')]
        : [];

    setState(() {
      replyCount = widget.commentParent?['replies_total'];
    });

    GetTimeAgo.setDefaultLocale('vi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic avatarMedia = widget.commentParent?['account']?['avatar_media'];

    checkElement() {
      int indexCommentChild = postChildComment.indexWhere(
          (element) => element['id'] == widget.commentChildCreate['id']);

      if (indexCommentChild < 0) return true;

      return false;
    }

    if (widget.commentChildCreate != null && checkElement()) {
      setState(() {
        postChildComment = [...postChildComment, widget.commentChildCreate];
        commentChild = [
          ...commentChild,
          Comment(
              avatar:
                  widget.commentChildCreate['account']['avatar_media'] != null
                      ? widget.commentChildCreate['account']['avatar_media']
                          ['preview_url']
                      : linkAvatarDefault,
              userName: widget.commentChildCreate['account']['display_name'],
              content: widget.commentChildCreate['id'])
        ];
        replyCount = replyCount + 1;
        isShowCommentChild = true;
      });
    }

    handleUpdatePost(post) {}

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: CommentTreeWidget<Comment, Comment>(
        Comment(
          avatar: avatarMedia?['preview_url'] ?? linkAvatarDefault,
          userName: widget.commentParent?['account']?['display_name'],
          content: widget.commentParent?['content'],
        ),
        commentChild,
        treeThemeData: TreeThemeData(
            lineColor: replyCount == 0 ? Colors.transparent : greyColor,
            lineWidth: 0.5),
        avatarRoot: (context, data) => PreferredSize(
            preferredSize: const Size.fromRadius(18),
            child: AvatarSocial(width: 36, height: 36, path: data.avatar!)),
        avatarChild: (context, data) => PreferredSize(
          preferredSize: const Size.fromRadius(12),
          child: data.avatar == 'icon'
              ? Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: const Icon(
                    Icons.reply,
                    color: greyColor,
                    size: 14,
                  ),
                )
              : AvatarSocial(width: 30, height: 30, path: data.avatar!),
        ),
        contentChild: (context, data) {
          return replyCount > 0 && !isShowCommentChild
              ? GestureDetector(
                  onTap: isLoadCommentChild
                      ? null
                      : () {
                          getListCommentChild();
                        },
                  child: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "$replyCount phản hồi",
                          style: const TextStyle(
                              color: greyColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        isLoadCommentChild
                            ? const SizedBox(
                                width: 10,
                                height: 10,
                                child: CupertinoActivityIndicator(),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                )
              : BoxComment(
                  widget: widget,
                  data: data,
                  getCommentSelected: widget.getCommentSelected!,
                  handleUpdatePost: handleUpdatePost,
                  commentNode: widget.commentNode,
                  post: postChildComment.firstWhere(
                      (element) => element['id'] == data.content,
                      orElse: () => null));
        },
        contentRoot: (context, data) {
          return BoxComment(
            widget: widget,
            data: data,
            getCommentSelected: widget.getCommentSelected!,
            handleUpdatePost: handleUpdatePost,
            commentNode: widget.commentNode,
            post: widget.commentParent,
          );
        },
      ),
    );
  }
}

class BoxComment extends StatefulWidget {
  final dynamic post;
  final Function? getCommentSelected;
  final FocusNode? commentNode;
  final Function? handleUpdatePost;

  const BoxComment({
    super.key,
    required this.widget,
    required this.data,
    this.post,
    this.getCommentSelected,
    this.commentNode,
    this.handleUpdatePost,
  });

  final CommentTree widget;
  final dynamic data;

  @override
  State<BoxComment> createState() => _BoxCommentState();
}

class _BoxCommentState extends State<BoxComment> {
  dynamic postRender;
  String textRender = '';

  @override
  void initState() {
    super.initState();

    if (mounted && widget.post != null) {
      setState(() {
        postRender = widget.post;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String viewerReaction = postRender['viewer_reaction'] ?? '';
    List reactions = postRender['reactions'];

    List sortReactions = reactions
        .map((element) => {
              "type": element['type'],
              "count": element['${element['type']}s_count']
            })
        .toList()
        .where((element) => element['count'] > 0)
        .toList()
      ..sort(
        (a, b) => a['count'].compareTo(b['count']),
      );

    List renderListReactions = sortReactions.reversed.toList();

    handleGetComment() {
      if (postRender == null) return const [TextSpan(text: '')];
      List tags = postRender['status_tags'] ?? [];
      String str = postRender['content'] ?? '';

      List<TextSpan> listRender = [];

      List matches = str.split(RegExp(r'\[|\]'));

      List listIdTags = tags.map((e) => e['entity_id']).toList();

      for (final subStr in matches) {
        listRender.add(
          TextSpan(
              text: listIdTags.contains(subStr)
                  ? tags.firstWhere((element) => element['entity_id'] == subStr,
                      orElse: () => {})['name']
                  : subStr,
              style: listIdTags.contains(subStr)
                  ? const TextStyle(
                      color: secondaryColor, fontWeight: FontWeight.w500)
                  : null),
        );
      }

      String text = postRender['content'];

      for (var mention in tags) {
        text = text.replaceAll('[${mention['entity_id']}]', mention['name']);
      }

      setState(() {
        textRender = text;
      });

      return listRender;
    }

    handleReaction(react) async {
      var newPost = postRender;
      List newFavourites = newPost['reactions'];

      int index = newPost['reactions']
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

        setState(() {
          postRender = newPost;
        });

        await PostApi().reactionPostApi(postRender['id'], data);
      } else {
        newPost = {
          ...newPost,
          "favourites_count": newPost['favourites_count'] != null
              ? newPost['favourites_count'] - 1
              : newPost['favourites_count'],
          "viewer_reaction": null,
          "reactions": newFavourites
        };

        setState(() {
          postRender = newPost;
        });

        await PostApi().unReactionPostApi(postRender['id']);
      }
    }

    handlePressButton() {
      if (viewerReaction.isNotEmpty) {
        handleReaction(null);
      } else {
        handleReaction('like');
      }
    }

    renderImageOther(link, key) {
      double size = key == 'love'
          ? 24
          : ['angry', 'sad', 'like'].contains(key)
              ? key == 'yay'
                  ? 28
                  : 16
              : 18;
      return Image.asset(
        link,
        height: size,
        width: size,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(FontAwesomeIcons.faceAngry),
      );
    }

    renderReaction(key) {
      if (key != null) {
        return renderImageOther('assets/reaction/$key.png', key);
      } else {
        return const SizedBox();
      }
    }

    void showActionSheet(BuildContext context) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => ActionComment(
              post: postRender,
              textRender: textRender,
              commentNode: widget.commentNode!,
              handleUpdatePost: widget.handleUpdatePost,
              getCommentSelected: widget.getCommentSelected!));
    }

    return postRender != null
        ? GestureDetector(
            onLongPress: () {
              showActionSheet(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data.content != ''
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                            color: widget.widget.commentSelected != null &&
                                    widget.widget.commentSelected!['id'] ==
                                        postRender['id']
                                ? secondaryColorSelected
                                : Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.data.userName}',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            RichText(
                                text: TextSpan(
                              text: '',
                              children: handleGetComment(),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ))
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: Text(
                          '${widget.data.userName}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        )),
                postRender['media_attachments'].isNotEmpty ||
                        postRender['card'] != null
                    ? PostMediaComment(post: postRender)
                    : const SizedBox(),
                DefaultTextStyle(
                  style: const TextStyle(
                      color: greyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: postRender['typeStatus'] == 'previewComment'
                        ? const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text("Đang viết ..."),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: ReactionButton(
                                      onReactionChanged: (value) {
                                        handleReaction(value);
                                      },
                                      handlePressButton: handlePressButton,
                                      reactions: <Reaction>[
                                        Reaction(
                                          previewIcon: renderGif('gif', 'like'),
                                          icon: renderGif('png', 'like',
                                              size: 20),
                                          value: 'like',
                                        ),
                                        Reaction(
                                          previewIcon: renderGif('gif', 'tym'),
                                          icon: renderGif('png', 'love',
                                              size: 20),
                                          value: 'love',
                                        ),
                                        Reaction(
                                          previewIcon: renderGif('gif', 'hug'),
                                          icon:
                                              renderGif('png', 'yay', size: 20),
                                          value: 'yay',
                                        ),
                                        Reaction(
                                          previewIcon: renderGif('gif', 'wow'),
                                          icon:
                                              renderGif('png', 'wow', size: 20),
                                          value: 'wow',
                                        ),
                                        Reaction(
                                          previewIcon: renderGif('gif', 'haha'),
                                          icon: renderGif('png', 'haha',
                                              size: 20),
                                          value: 'haha',
                                        ),
                                        Reaction(
                                          previewIcon: renderGif('gif', 'cry'),
                                          icon:
                                              renderGif('png', 'sad', size: 20),
                                          value: 'sad',
                                        ),
                                        Reaction(
                                          previewIcon: renderGif('gif', 'mad'),
                                          icon: renderGif('png', 'angry',
                                              size: 20),
                                          value: 'angry',
                                        ),
                                      ],
                                      initialReaction: Reaction(
                                          icon: Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      viewerReaction.isNotEmpty
                                                          ? 5
                                                          : 8,
                                                  right: 8,
                                                  top: 2,
                                                  bottom: 2),
                                              child: viewerReaction.isNotEmpty
                                                  ? renderText(
                                                      viewerReaction,
                                                    )
                                                  : const Text(
                                                      'Thích',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: greyColor,
                                                          fontSize: 12),
                                                    )),
                                          value: 'kakakak'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        widget.widget.commentNode!
                                            .requestFocus();
                                        widget.widget
                                            .getCommentSelected!(postRender);
                                      },
                                      child: const Text('Trả lời')),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    GetTimeAgo.parse(DateTime.parse(widget
                                        .widget.commentParent['created_at'])),
                                  ),
                                ],
                              ),
                              postRender['favourites_count'] > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        showBarModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                ReactionList(post: postRender));
                                      },
                                      child: Row(
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(8, 0),
                                            child: Text(
                                                '${shortenLargeNumber(postRender['favourites_count'])} '),
                                          ),
                                          renderListReactions.isNotEmpty
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Transform.translate(
                                                        offset:
                                                            const Offset(6, 0),
                                                        child: renderReaction(
                                                            renderListReactions[
                                                                0]['type'])),
                                                    renderListReactions
                                                                .length >=
                                                            2
                                                        ? Transform.translate(
                                                            offset:
                                                                const Offset(
                                                                    4, 0),
                                                            child: renderReaction(
                                                                renderListReactions[
                                                                    1]['type']),
                                                          )
                                                        : const SizedBox(),
                                                    renderListReactions
                                                                .length >=
                                                            3
                                                        ? renderReaction(
                                                            renderListReactions[
                                                                2]['type'])
                                                        : const SizedBox(),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}

class ActionComment extends StatelessWidget {
  final dynamic post;
  final String textRender;
  final FocusNode? commentNode;
  final Function? handleUpdatePost;

  final Function? getCommentSelected;

  const ActionComment({
    super.key,
    this.post,
    required this.textRender,
    this.getCommentSelected,
    this.commentNode,
    this.handleUpdatePost,
  });

  @override
  Widget build(BuildContext context) {
    List action = [
      {'key': 'reply', 'label': 'Phản hồi', "visible": true},
      {'key': 'copy', 'label': 'Sao chép', "visible": true},
      {'key': 'edit', 'label': 'Chỉnh sửa bình luận', "visible": true},
      {'key': 'delete', 'label': 'Xóa bình luận', "visible": true},
      {'key': 'report', 'label': 'Báo cáo', "visible": true},
    ];

    void showAlertDialog(BuildContext context) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => AlertDialogDelete(
              post: post,
              handleDelete: () {
                handleUpdatePost!(post);
              }));
    }

    handleAction(key) async {
      if (key == 'copy') {
        Navigator.pop(context);
        await Clipboard.setData(ClipboardData(text: textRender));
      } else if (key == 'report') {
        Navigator.pop(context);
        await showBarModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                ReportCategory(entityReport: post, entityType: "post"));
      } else if (key == 'reply') {
        Navigator.pop(context);
        commentNode!.requestFocus();
        await getCommentSelected!(post);
      } else if (key == 'delete') {
        Navigator.pop(context);
        showAlertDialog(context);
      }
    }

    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        ...List.generate(
          action.length,
          (index) => CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              handleAction(action[index]['key']);
            },
            child: Text(
              action[index]['label'],
              style: const TextStyle(
                  color: secondaryColor, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Hủy", style: TextStyle(color: Colors.red))),
    );
  }
}

class PostMediaComment extends StatefulWidget {
  final dynamic post;
  const PostMediaComment({
    super.key,
    this.post,
  });

  @override
  State<PostMediaComment> createState() => _PostMediaCommentState();
}

class _PostMediaCommentState extends State<PostMediaComment> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    dynamic card = widget.post['card'];
    List medias = widget.post['media_attachments'] ?? [];
    final size = MediaQuery.of(context).size;
    renderCard() {
      if (card['description'] == 'sticky') {
        return ImageCacheRender(
          path: card['link'],
          width: 90.0,
        );
      } else if (card['provider_name'] == 'GIPHY') {
        return Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImageCacheRender(
              path: card['link'],
            ),
          ),
        );
      } else {
        return PostCard(post: widget.post);
      }
    }

    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    renderMedia() {
      if (checkIsImage(medias[0])) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: medias[0]['url'],
            imageErrorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FeedVideo(
              path: medias[0]['remote_url'] ?? medias[0]['url'],
              flickMultiManager: flickMultiManager,
              image: medias[0]['preview_remote_url'] ??
                  medias[0]['preview_url'] ??
                  ''),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: card != null
          ? renderCard()
          : medias.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostOneMediaDetail(
                                  postMedia: widget.post,
                                )));
                  },
                  child: Container(
                      constraints: BoxConstraints(
                          maxHeight: size.width * 0.7,
                          maxWidth: size.width * 0.7),
                      child: renderMedia()),
                )
              : const SizedBox(),
    );
  }
}

class AlertDialogDelete extends StatelessWidget {
  final dynamic post;
  final Function handleDelete;

  const AlertDialogDelete({Key? key, this.post, required this.handleDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    handleDeletePost(key) async {
      var response = await PostApi().deletePostApi(post!['id']);
      handleDelete();

      if (response != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Xóa bình luận thành công")));
      }
    }

    return CupertinoAlertDialog(
      title: const Text('Xóa bình luận'),
      content: const Text(
          'Bạn chắc chắn muốn xóa bình luận? Hành động này không thể hoàn tác'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Hủy'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            handleDeletePost('delete_post');
          },
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
