import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

const String closeTopToBottom = "topToBottom";
const String closeBottomToTop = "bottomToTop";

class PostMutipleMediaDetail extends StatefulWidget {
  final int? initialIndex;
  final dynamic post;
  const PostMutipleMediaDetail({Key? key, this.post, this.initialIndex})
      : super(key: key);

  @override
  State<PostMutipleMediaDetail> createState() =>
      _PostMutipleMediaDetail1State();
}

class _PostMutipleMediaDetail1State extends State<PostMutipleMediaDetail> {
  late ScrollController _scrollParentController;
  bool isShowImage = false;
  int? imgIndex;
  GlobalKey imageSingleKey = GlobalKey();
  double? imagSingleHeight;
  bool isDragOutside = false;
  bool canDragOutside = false;
  bool isHaveAppbar = true;
  double? spacerBottom = 0;
  double? spacerTop = 0;
  double? beginPositonY = 0;
  double? updatePositonY = 0;
  String closeDirection = "";
  @override
  void initState() {
    super.initState();
    beginPositonY = 0;
    updatePositonY = 0;
    _scrollParentController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollParentController.animateTo(
        (widget.initialIndex ?? 0) *
            _scrollParentController.position.viewportDimension,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    });

    _scrollParentController.addListener(() {
      showAppbar();
      dragForward();
      dragReverse();
    });
  }

  showAppbar() {
    // REVERSE: KEOPS TỪ DƯỚI LÊN
    // ẩn hiện appbar
    // khi người dùng kéo forward xuống trong trường hợp
    // canDrag==true và isDragOutside -> ẩn
    // canDrag==false -> hiện
    if (_scrollParentController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (canDragOutside && isDragOutside) {
        setState(() {
          isHaveAppbar = false;
        });
      } else {
        setState(() {
          isHaveAppbar = true;
        });
      }
    }
    if (_scrollParentController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (canDragOutside && isDragOutside) {
        setState(() {
          isHaveAppbar = false;
        });
        if (double.parse((_scrollParentController.offset).toStringAsFixed(1)) ==
            double.parse((_scrollParentController.position.maxScrollExtent)
                .toStringAsFixed(1))) {
          setState(() {
            isDragOutside = false;
            isHaveAppbar = true;
          });
        }
      } else {
        setState(() {
          isHaveAppbar = true;
        });
      }
    }
  }

  dragForward() {
    // kéo từ trên xuống
    // nếu canDrag ==true thì cử chỉ keeos xuống xuyên suốt là isdragoutside
    //
    if (_scrollParentController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (canDragOutside) {
        if (double.parse((_scrollParentController.offset).toStringAsFixed(1)) >
                -10.0 &&
            double.parse((_scrollParentController.offset).toStringAsFixed(1)) <
                0.0) {
          setState(() {
            isDragOutside = true;
          });
        }
      }
      if (canDragOutside == true && isDragOutside == true) {
        if (double.parse((_scrollParentController.offset).toStringAsFixed(1)) ==
            double.parse((_scrollParentController.position.maxScrollExtent)
                .toStringAsFixed(1))) {
          setState(() {
            isDragOutside = false;
            isHaveAppbar = true;
          });
        }
      }
    }
  }

  dragReverse() {
    // kéo từ duoi len ( min scvroll)
    // nếu canDrag ==true va isdragoutside cung bang true thi khi offset tro lai vi tri 0.0 appbar idragoutside tro ve false
    // keo tu duoi len (max scroll)
    // nếu canDrag ==true va isdragoutside cung bang true thi khi offset tro lai vi tri 0.0 appbar idragoutside tro ve false

    if (_scrollParentController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (canDragOutside == true && isDragOutside == true) {
        if (double.parse((_scrollParentController.offset).toStringAsFixed(1)) >
                0.0 &&
            double.parse((_scrollParentController.offset).toStringAsFixed(1)) <
                10.0) {
          setState(() {
            isDragOutside = false;
            isHaveAppbar = true;
          });
        }
      }
      if (canDragOutside) {
        if (double.parse((_scrollParentController.offset).toStringAsFixed(1)) >
                double.parse((_scrollParentController.position.maxScrollExtent)
                    .toStringAsFixed(1))
            //         &&
            // double.parse((_scrollParentController.offset).toStringAsFixed(1)) <
            //     double.parse((_scrollParentController.position.maxScrollExtent)
            //         .toStringAsFixed(1))
            ) {
          setState(() {
            isDragOutside = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  @override
  Widget build(BuildContext context) {

    List medias = widget.post['media_attachments'];
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
        appBar: isHaveAppbar ? buildAppbar() as PreferredSizeWidget : null,
        backgroundColor: blackColor.withOpacity(0.1),
        body: SafeArea(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: closeDirection == "" ? height : 0,
            width: width,
            curve: Curves.easeInOut, 
            transform: Matrix4.translationValues(
                0,
                closeDirection == closeBottomToTop
                    ? 0
                    : closeDirection == closeTopToBottom
                        ? height
                        : 0,
                0),
            onEnd: () {
              popToPreviousScreen(context);
            },
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: EdgeInsets.only(
                    top: ((updatePositonY! - beginPositonY!) > 0
                        ? (updatePositonY! - beginPositonY!)
                        : 0),
                    bottom: ((updatePositonY! - beginPositonY!) < 0
                        ? (updatePositonY! - beginPositonY!).abs()
                        : 0),
                  ),
                  child: NotificationListener(
                    onNotification: (notification) {
                      if (notification is OverscrollNotification) {}
                      if (notification is UserScrollNotification) {}
                      if (notification is DraggableScrollableNotification) {}
                      if (notification is ScrollMetricsNotification) {}
                      if (notification is ScrollStartNotification) {
                        if (_scrollParentController.offset == 0.0 ||
                            _scrollParentController.offset ==
                                _scrollParentController
                                    .position.maxScrollExtent) {
                          setState(() {
                            canDragOutside = true;
                            beginPositonY = notification.dragDetails != null
                                ? notification.dragDetails!.globalPosition.dy
                                : 0;
                            updatePositonY = notification.dragDetails != null
                                ? notification.dragDetails!.globalPosition.dy
                                : 0;
                          });
                        } else {
                          setState(() {
                            canDragOutside = false;
                          });
                        }
                      }
                      if (notification is ScrollUpdateNotification) {
                        if (isDragOutside) {
                          setState(() {
                            updatePositonY = notification.dragDetails != null
                                ? notification.dragDetails!.globalPosition.dy
                                : updatePositonY;
                          });
                        }
                      }
                      if (notification is ScrollEndNotification) {
                        if ((updatePositonY! - beginPositonY!).abs() < 50) {
                          setState(() {
                            updatePositonY = 0;
                            beginPositonY = 0;
                          });
                        } else {
                          if ((updatePositonY! - beginPositonY!) > 0) {
                            setState(() {
                              closeDirection = closeTopToBottom;
                            });
                          } else {
                            setState(() {
                              closeDirection = closeBottomToTop;
                            });
                          } 
                        }
                      }
                      return true;
                    },
                    child: Column(
                      children: [
                        const SizedBox(),
                        Flexible(
                          flex: 1,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollParentController,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isDragOutside
                                      ? buildAppbar()
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  PostHeader(
                                      post: widget.post,
                                      type: postMultipleMedia),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  PostContent(post: widget.post),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  PostFooter(
                                    post: widget.post,
                                    type: postMultipleMedia,
                                  ),
                                  // const SizedBox(
                                  //   height: 8.0,
                                  // ),
                                  const CrossBar(
                                    height: 5,
                                    onlyTop: 5,
                                    onlyBottom: 0,
                                  ),
                                  Column(
                                    children: List.generate(
                                        medias.length,
                                        (index) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // const CrossBar(
                                                //   height: 5,
                                                //   onlyTop: 5,
                                                //   onlyBottom: 0,
                                                // ),
                                                GestureDetector(
                                                    onTap: () {
                                                      pushCustomVerticalPageRoute(
                                                          context,
                                                          PostOneMediaDetail(
                                                              currentIndex:
                                                                  index,
                                                              medias:
                                                                  medias, //list anh
                                                              post: widget.post,
                                                              postMedia: medias[
                                                                  index], // anh hien tai dang duoc chon
                                                              backFunction: () {
                                                                popToPreviousScreen(
                                                                    context);
                                                              }),
                                                          opaque: false);
                                                    },
                                                    child: checkIsImage(
                                                            medias[index])
                                                        ? Stack(
                                                            children: [
                                                              Hero(
                                                                tag: medias[
                                                                        index]
                                                                    ['id'],
                                                                child: ExtendedImage.network(
                                                                    medias[index]
                                                                        ['url'],
                                                                    key: Key(medias[
                                                                            index]
                                                                        ['id']),
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: double.parse(medias[index]['meta']["small"]
                                                                            ["height"]
                                                                        .toString())
                                                                    // ImageCacheRender(
                                                                    //     key: Key(medias[index]['id']
                                                                    //         .toString()),
                                                                    //     path: medias[index]['url'],
                                                                    //     width: MediaQuery.of(context)
                                                                    //         .size
                                                                    //         .width,
                                                                    //     height: double.parse(
                                                                    //         medias[index]['meta']
                                                                    //                 ["small"]["height"]
                                                                    //             .toString())
                                                                    ),
                                                              ),
                                                              // isShowImage &&
                                                              //         imgIndex ==
                                                              //             index
                                                              //     ? SizedBox(
                                                              //         width: MediaQuery.of(
                                                              //                 context)
                                                              //             .size
                                                              //             .width,
                                                              //         height: double.parse(medias[index]['meta']["small"]
                                                              //                 [
                                                              //                 "height"]
                                                              //             .toString()))
                                                              //     : Container()
                                                            ],
                                                          )
                                                        : VideoPlayerNoneController(
                                                            path: medias[index]
                                                                ['url'],
                                                            type: postDetail)),
                                                PostFooter(
                                                  post: medias[index],
                                                  type: postMultipleMedia,
                                                ),
                                                const CrossBar(
                                                  height: 5,
                                                  onlyTop: 5,
                                                  onlyBottom: 0,
                                                ),
                                              ],
                                            )),
                                  ),
                                  Container(
                                    color: transparent,
                                    height: isDragOutside ? 80 : 20,
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildAppbar() {
    final size = MediaQuery.of(context).size;
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      leading: const BackIconAppbar(),
      title: SizedBox(
        width: size.width - 70,
        child: const Center(
          child: AppBarTitle(
            title: "Bài viết",
          ),
        ),
      ),
      actions: const [SizedBox()],
    );
  }
}
































