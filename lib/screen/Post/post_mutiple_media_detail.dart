import 'dart:async';
import 'dart:math' as math;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

const String closeTopToBottom = "topToBottom";
const String closeBottomToTop = "bottomToTop";

class PostMutipleMediaDetail extends StatefulWidget {
  final int? initialIndex;
  final dynamic post;
  final dynamic preType;
  const PostMutipleMediaDetail(
      {Key? key, this.post, this.preType, this.initialIndex})
      : super(key: key);

  @override
  State<PostMutipleMediaDetail> createState() =>
      _PostMutipleMediaDetail1State();
}

class _PostMutipleMediaDetail1State extends State<PostMutipleMediaDetail> {
  late ScrollController _scrollParentController;
  bool isDragOutside = false;
  bool canDragOutside = false;
  bool isHaveAppbar = true;
  double? beginPositonY = 0;
  double? updatePositonY = 0;
  String closeDirection = "";
  // tránh conflict giữa cử chỉ drag outside lên rồi xuống
  ScrollDirection? beginDirection;
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
    // REVERSE: KEOS TỪ DƯỚI LÊN
    // ẩn hiện appbar
    // khi người dùng kéo forward xuống trong trường hợp
    // canDrag==true và isDragOutside -> ẩn
    // canDrag==false -> hiện
    if (_scrollParentController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (canDragOutside && isDragOutside) {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isHaveAppbar = false;
        });
        // });
      } else {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isHaveAppbar = true;
        });
        // });
      }
    }
    if (_scrollParentController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (canDragOutside && isDragOutside) {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isHaveAppbar = false;
        });
        // });
        if (double.parse((_scrollParentController.offset).toStringAsFixed(1)) ==
            double.parse((_scrollParentController.position.maxScrollExtent)
                .toStringAsFixed(1))) {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isDragOutside = false;
            showBgContainer.value = true;
            isHaveAppbar = true;
          });
          // });
        }
      } else {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isHaveAppbar = true;
        });
        // });
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
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isDragOutside = true;

            showBgContainer.value = false;
          });
          // });
        }
      }
      if (canDragOutside == true && isDragOutside == true) {
        if (double.parse((_scrollParentController.offset).toStringAsFixed(1)) ==
            double.parse((_scrollParentController.position.maxScrollExtent)
                .toStringAsFixed(1))) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isDragOutside = false;
              showBgContainer.value = true;
              isHaveAppbar = true;
            });
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isDragOutside = false;
              showBgContainer.value = true;
              isHaveAppbar = true;
            });
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isDragOutside = true;
              showBgContainer.value = false;
            });
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

  ValueNotifier<bool> showBgContainer = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    List medias = widget.post['media_attachments'];
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
        appBar: isHaveAppbar ? buildAppbar() as PreferredSizeWidget : null,
        backgroundColor: transparent,
        body: SafeArea(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: closeDirection == "" ? height : 0,
            width: width,
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(
                0,
                closeDirection == closeBottomToTop
                    ? -height
                    : closeDirection == closeTopToBottom
                        ? height
                        : 0,
                0),
            onEnd: () {
              popToPreviousScreen(context);
            },
            child: Stack(
              children: [
                // ValueListenableBuilder<bool>(
                //     valueListenable: showBgContainer,
                //     builder: (ctx, state, child) {
                //       if (state) {
                //         return Container(
                //           height: height,
                //           width: width,
                //           color: Theme.of(context).scaffoldBackgroundColor,
                //         );
                //       } else {
                //         return const SizedBox();
                //       }
                //     }),

                Container(
                  margin: EdgeInsets.only(
                    top: (beginDirection == ScrollDirection.forward &&
                            (updatePositonY! - beginPositonY!) > 0
                        ? (updatePositonY! - beginPositonY!)
                        : 0),
                    bottom: (beginDirection == ScrollDirection.reverse &&
                            (updatePositonY! - beginPositonY!) < 0
                        ? (updatePositonY! - beginPositonY!).abs()
                        : 0),
                  ),
                  child: NotificationListener<ScrollNotification>(
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
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            canDragOutside = true;
                            beginPositonY = notification.dragDetails != null
                                ? notification.dragDetails!.globalPosition.dy
                                : 0;
                            updatePositonY = notification.dragDetails != null
                                ? notification.dragDetails!.globalPosition.dy
                                : 0;
                          });
                          // });
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              canDragOutside = false;
                            });
                          });
                        }
                      }
                      if (notification is ScrollUpdateNotification) {
                        if (isDragOutside) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              updatePositonY = notification.dragDetails != null
                                  ? notification.dragDetails!.globalPosition.dy
                                  : updatePositonY;
                              beginDirection ??= _scrollParentController
                                  .position.userScrollDirection;
                            });
                          });
                        }
                      }
                      if (notification is ScrollEndNotification) {
                        if (
                            // (updatePositonY! - beginPositonY!)>0 &&
                            (updatePositonY! - beginPositonY!).abs() < 50
                            //  || (updatePositonY! - beginPositonY!)<0 && (updatePositonY! - beginPositonY!) > -100
                            ) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              isDragOutside = false;
                              showBgContainer.value = true;
                              updatePositonY = 0;
                              beginPositonY = 0;
                              isHaveAppbar = true;
                              beginDirection = null;
                            });
                          });
                        } else {
                          if (beginDirection == ScrollDirection.forward &&
                              (updatePositonY! - beginPositonY!) > 0) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                // isDragOutside = false;
                                showBgContainer.value = true;
                                closeDirection = closeTopToBottom;
                              });
                            });
                          } else if (beginDirection ==
                                  ScrollDirection.reverse &&
                              (updatePositonY! - beginPositonY!) < 0) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                // isDragOutside = false;
                                showBgContainer.value = true;
                                closeDirection = closeBottomToTop;
                              });
                            });
                          } else { 
                            if (beginDirection != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  beginDirection = null;
                                });
                              });
                            }
                          }
                        }
                      }
                      return true;
                    },
                    child: Column(
                      children: [
                        Flexible(
                            flex: 1,
                            child: Container(
                              color:isDragOutside ? transparent:Theme.of(context).scaffoldBackgroundColor,
                              child: SingleChildScrollView(
                                physics: !isDragOutside
                                    ? const BouncingScrollPhysics()
                                    : const CustomBouncingScrollPhysics(),
                                controller: _scrollParentController,
                                child: Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        const CrossBar(
                                          height: 5,
                                          onlyTop: 5,
                                          onlyBottom: 0,
                                        ),
                                        Column(
                                          children: List.generate(medias.length,
                                              (index) {
                                            dynamic mediaData;
                                            // while(mediaData==null){
                                            // Future.delayed(Duration.zero, () async {
                                            //   mediaData = await PostApi()
                                            //       .getPostDetailMedia(
                                            //           medias[index]['id']);
                                            // });
                                            // }
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                              type:
                                                                  postMultipleMedia,
                                                              preType: widget
                                                                  .preType,
                                                              backFunction: () {
                                                                popToPreviousScreen(
                                                                    context);
                                                              }),
                                                          opaque: false);
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Hero(
                                                          tag: medias[index]
                                                              ['id'],
                                                          child: ExtendedImage.network(
                                                              medias[index]
                                                                  ['url'],
                                                              key: Key(
                                                                  medias[index]
                                                                      ['id']),
                                                              fit: BoxFit.cover,
                                                              width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                              height: double.parse(medias[index]
                                                                              ['meta']
                                                                          ["small"]
                                                                      ["height"]
                                                                  .toString())),
                                                        ),
                                                      ],
                                                    )),
                                                PostFooter(
                                                  post: mediaData ??
                                                      medias[index],
                                                  type: postMultipleMedia,
                                                  preType: widget.preType,
                                                ),
                                                const CrossBar(
                                                  height: 5,
                                                  onlyTop: 5,
                                                  onlyBottom: 0,
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                        Container(
                                          color: transparent,
                                          height: 20,
                                        )
                                      ]),
                                ),
                              ),
                            )),
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
      title: Container(
        padding: const EdgeInsets.only(right: 30),
        width: size.width - 70,
        child: Center(
          child: AppBarTitle(
            title: "Bài viết của ${_appBarTitle()}",
          ),
        ),
      ),
      actions: const [SizedBox()],
    );
  }

  String _appBarTitle() {
    return widget.post["group"] != null
        ? widget.post["group"]['title'] ?? ""
        : widget.post["page"] != null
            ? widget.post["page"]['title'] ?? ""
            : widget.post["account"]['display_name'] ?? "";
  }
}

class CustomBouncingScrollPhysics extends BouncingScrollPhysics {
  final bool isAcceptScroll;
  const CustomBouncingScrollPhysics(
      {ScrollPhysics? parent, this.isAcceptScroll = true})
      : super(parent: parent);

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      double constantDeceleration;
      switch (decelerationRate) {
        case ScrollDecelerationRate.fast:
          constantDeceleration = 1400;
          break;
        case ScrollDecelerationRate.normal:
          constantDeceleration = 0;
          break;
      }
      return null;
    }
    return null;
  }
}
