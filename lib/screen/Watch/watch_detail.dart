import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/comment_tree.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widget/comment_textfield.dart';
import 'package:social_network_app_mobile/widget/screen_share.dart';

class WatchDetail extends StatefulWidget {
  final dynamic media;
  final dynamic post;
  const WatchDetail({Key? key, this.media, this.post}) : super(key: key);

  @override
  State<WatchDetail> createState() => _WatchDetailState();
}

class _WatchDetailState extends State<WatchDetail>
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    print(newList);
    if (mounted) {
      setState(() {
        isLoadComment = false;
        postComment = postComment + newList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // String averageColor = widget.media['meta']['original']['average_color'];

    double getSizeGif(type) {
      if (type == 'tym') return 60;
      if (type == 'hug') return 55;
      if (type == 'haha') return 50;
      return 40;
    }

    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
      },
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: Container(
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
                      child: Column(
                        children: [
                          PostHeader(
                              post: widget.post,
                              textColor: white,
                              type: postDetail),
                          const SizedBox(
                            height: 20,
                          ),
                          Dismissible(
                              direction: DismissDirection.vertical,
                              key: const Key('page2'),
                              resizeDuration: const Duration(milliseconds: 1),
                              onDismissed: (direction) {
                                Navigator.pop(context);
                              },
                              child: Hero(
                                tag: widget.media['remote_url'] ??
                                    widget.media['url'],
                                child: VideoPlayerHasController(
                                  media: widget.media,
                                ),
                              )),
                          Expanded(
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: PostContent(
                                      post: widget.post,
                                      textColor: white,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: postComment.length,
                                            itemBuilder: ((context, index) =>
                                                CommentTree(
                                                    key: Key(
                                                        postComment[index][
                                                            'id']),
                                                    type: postWatch,
                                                    commentChildCreate:
                                                        postComment[
                                                                        index]
                                                                    ['id'] ==
                                                                commentChild?[
                                                                    'in_reply_to_id']
                                                            ? commentChild
                                                            : null,
                                                    commentNode: commentNode,
                                                    commentSelected:
                                                        commentSelected,
                                                    commentParent:
                                                        postComment[index],
                                                    getCommentSelected: () {},
                                                    handleDeleteComment:
                                                        () {}))),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 12, right: 12),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        child: const Icon(
                                            FontAwesomeIcons.chevronDown,
                                            size: 15,
                                            color: white),
                                      ),
                                      TabBar(
                                          isScrollable: true,
                                          controller: _tabController,
                                          onTap: (index) {},
                                          indicator: const BoxDecoration(),
                                          indicatorWeight: 0,
                                          labelColor: Colors.white,
                                          unselectedLabelColor:
                                              Colors.white.withOpacity(0.5),
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
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
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showBarModalBottomSheet(
                                                context: context,
                                                barrierColor:
                                                    Colors.transparent,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) => SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child: ScreenShare(
                                                        entityShare:
                                                            widget.post,
                                                        type: 'post',
                                                        entityType: 'post')));
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.share,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            size: 24,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70,
                                          child: CommentTextfield(
                                              autoFocus: false,
                                              type: postWatchDetail,
                                              commentSelected: null,
                                              getCommentSelected: () {},
                                              commentNode: null,
                                              handleComment: () {}),
                                        ),
                                        ...[
                                          'like',
                                          'tym',
                                          'hug',
                                          'haha',
                                          'wow',
                                          'cry',
                                          'mad'
                                        ].map((String el) => Container(
                                            margin: EdgeInsets.only(
                                                left: 2,
                                                right: 2,
                                                bottom: el == 'hug' ? 10 : 0),
                                            child: LikeButton(
                                              size: getSizeGif(el),
                                              circleColor: const CircleColor(
                                                  start: primaryColor,
                                                  end: secondaryColor),
                                              bubblesColor: const BubblesColor(
                                                dotPrimaryColor: primaryColor,
                                                dotSecondaryColor:
                                                    secondaryColor,
                                              ),
                                              likeBuilder: (bool isLiked) {
                                                return renderGif('gif', el,
                                                    size: getSizeGif(el));
                                              },
                                            )))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
