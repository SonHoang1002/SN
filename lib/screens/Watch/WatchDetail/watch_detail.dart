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
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screens/Post/comment_tree.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widgets/comment_textfield.dart';
import 'package:social_network_app_mobile/widgets/screen_share.dart';

final selectedVideoProvider = StateProvider<dynamic>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);

class WatchDetail extends ConsumerStatefulWidget {
  final dynamic media;
  final dynamic post;
  final String? type;
  const WatchDetail({Key? key, this.media, this.post, this.type})
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

  @override
  void initState() {
    super.initState();
    getListCommentPost(widget.post['id'], {"sort_by": "newest"});
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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
              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
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
                    : VideoPlayerHasController(
                        type: widget.type,
                        media: widget.media,
                        isHiddenControl: false,
                      )),
          )
        : const SizedBox();
  }

  Widget renderPostInformation(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isHiddenAction)
          Container(
            constraints: BoxConstraints(maxHeight: size.height / 3),
            child: TabBarView(controller: _tabController, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PostHeader(
                      post: widget.post, textColor: white, type: postDetail),
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
                  commentSelected: commentSelected)
            ]),
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
                    unselectedLabelColor: Colors.white.withOpacity(0.5),
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
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: BottomAction(widget: widget, isHiddenAction: isHiddenAction),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;

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
                        children: [renderVideo(), renderPostInformation(size)],
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
  const ListComment({
    super.key,
    required this.postComment,
    required this.commentChild,
    required this.commentNode,
    required this.commentSelected,
  });

  final List postComment;
  final dynamic commentChild;
  final FocusNode commentNode;
  final dynamic commentSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
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
              getCommentSelected: () {},
              handleDeleteComment: () {});
        }));
  }
}

class BottomAction extends StatelessWidget {
  final bool isHiddenAction;
  const BottomAction({
    super.key,
    required this.widget,
    required this.isHiddenAction,
  });

  final WatchDetail widget;

  @override
  Widget build(BuildContext context) {
    double getSizeGif(type) {
      if (type == 'tym') return 60;
      if (type == 'hug') return 55;
      if (type == 'haha') return 50;
      return 40;
    }

    const listReaction = ['like', 'tym', 'hug', 'haha', 'wow', 'cry', 'mad'];

    return !isHiddenAction
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showBarModalBottomSheet(
                        context: context,
                        barrierColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ScreenShare(
                                entityShare: widget.post,
                                type: 'post',
                                entityType: 'post')));
                  },
                  child: Icon(
                    FontAwesomeIcons.share,
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  child: CommentTextfield(
                      autoFocus: false,
                      type: postWatchDetail,
                      commentSelected: null,
                      getCommentSelected: () {},
                      commentNode: null,
                      handleComment: () {}),
                ),
                ...listReaction.map((String el) => Container(
                    margin: EdgeInsets.only(
                        left: 2, right: 2, bottom: el == 'hug' ? 10 : 0),
                    child: LikeButton(
                      size: getSizeGif(el),
                      circleColor: const CircleColor(
                          start: primaryColor, end: secondaryColor),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: primaryColor,
                        dotSecondaryColor: secondaryColor,
                      ),
                      likeBuilder: (bool isLiked) {
                        return renderGif('gif', el, size: getSizeGif(el));
                      },
                    )))
              ],
            ),
          )
        : const SizedBox(
            height: 71,
          );
  }
}
