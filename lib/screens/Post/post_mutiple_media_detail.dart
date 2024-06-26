import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/screens/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

const String closeTopToBottom = "topToBottom";
const String closeBottomToTop = "bottomToTop";

class PostMutipleMediaDetail extends ConsumerStatefulWidget {
  final int? initialIndex;
  final dynamic post;
  final dynamic preType;
  final Function(dynamic)? updateDataFunction;
  final dynamic friendData;
  final dynamic groupData;
  final bool? isInGroup;

  const PostMutipleMediaDetail(
      {Key? key,
      this.post,
      this.preType,
      this.initialIndex,
      this.updateDataFunction,
      this.friendData,
      this.isInGroup,
      this.groupData})
      : super(key: key);

  @override
  ConsumerState<PostMutipleMediaDetail> createState() =>
      _PostMutipleMediaDetail1State();
}

class _PostMutipleMediaDetail1State
    extends ConsumerState<PostMutipleMediaDetail> {
  late ScrollController _scrollParentController;
  ValueNotifier<bool> showBgContainer = ValueNotifier(true);

  bool isDragOutside = false;
  bool canDragOutside = false;
  bool isHaveAppbar = true;
  double? beginPositonY = 0;
  double? updatePositonY = 0;
  String closeDirection = "";
  List medias = [];
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
    Future.delayed(Duration.zero, () {
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(widget.post);
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
    showBgContainer.dispose();
    _scrollParentController.dispose();
    super.dispose();
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  reloadDetailFunction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    dynamic postData =
        ref.watch(currentPostControllerProvider).currentPost ?? widget.post;
    if (postData.isNotEmpty) {
      medias = postData['media_attachments'];
    }

    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;
    return Scaffold(
        appBar: isHaveAppbar ? buildAppbar() as PreferredSizeWidget : null,
        backgroundColor: transparent,
        body: AnimatedContainer(
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
            Navigator.pop(context);
          },
          child: Stack(
            children: [
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
                        } else if (beginDirection == ScrollDirection.reverse &&
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
                            color: isDragOutside
                                ? transparent
                                : Theme.of(context).scaffoldBackgroundColor,
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
                                        post: postData,
                                        type: postMultipleMedia,
                                        isInGroup: widget.isInGroup,
                                        friendData: widget.friendData,
                                        groupData: widget.groupData,
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      PostContent(post: postData),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      PostFooter(
                                        post: postData,
                                        type: postMultipleMedia,
                                        preType: widget.preType,
                                        updateDataFunction:
                                            widget.updateDataFunction,
                                      ),
                                      const CrossBar(
                                        height: 5,
                                        onlyTop: 5,
                                        onlyBottom: 0,
                                      ),
                                      Column(
                                        children: List.generate(medias.length,
                                            (index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    if (medias[index]['type'] ==
                                                        "image") {
                                                      pushCustomVerticalPageRoute(
                                                          context,
                                                          PostOneMediaDetail(
                                                              currentIndex:
                                                                  index,
                                                              medias:
                                                                  medias, //list anh
                                                              post: postData,
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
                                                    }
                                                    // else if (medias[index]
                                                    //         ['type'] ==
                                                    //     "video") {
                                                    //   pushCustomVerticalPageRoute(
                                                    //       context,
                                                    //       WatchDetail(
                                                    //         post: widget.post,
                                                    //         media:
                                                    //             medias[index],
                                                    //       ),
                                                    //       opaque: false);
                                                    // } else {
                                                    // }
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      medias[index][
                                                                  'type'] ==
                                                              'image'
                                                          ? (!isDragOutside
                                                              ? Hero(
                                                                  tag: medias[
                                                                              index]
                                                                          [
                                                                          'id'] ??
                                                                      index,
                                                                  child:
                                                                      _buildImageMediaNetwork(
                                                                          index))
                                                              : _buildImageMediaNetwork(
                                                                  index))
                                                          : (!isDragOutside
                                                              ? Hero(
                                                                  tag: medias[index]
                                                                          [
                                                                          'id'] ??
                                                                      index,
                                                                  child:
                                                                      _buildVideoMedia(
                                                                          index))
                                                              : _buildVideoMedia(
                                                                  index))
                                                    ],
                                                  )),
                                              PostFooter(
                                                  post: postData,
                                                  type: postMultipleMedia,
                                                  preType: widget.preType,
                                                  indexOfImage: index,
                                                  reloadDetailFunction:
                                                      reloadDetailFunction),
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
        ));
  }

  Widget _buildVideoMedia(int index) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
        height: (medias[index]['aspect'] ??
                    medias[index]['meta']['small']['aspect']) <
                1
            ? size.width
            : null,
        // width: MediaQuery.sizeOf(context).width,
        // width: double.infinity,
        child: medias[index]['file'] != null
            ? VideoPlayerNoneController(
                path: medias[index]['file'].path,
                type: "local",
                removeObserver: false, isPause: true,
                // aspectRatio: size.height / size.width,
              )
            : VideoPlayerHasController(
                media: medias[index],
                aspectRatio: widget.post?['media_attachments']?[0]?['meta']
                    ?['original']?['aspect'],
                handleAction: () {
                  pushCustomVerticalPageRoute(
                      context,
                      WatchDetail(
                        post: widget.post,
                        media: medias[index],
                        preType: widget.preType,
                        updateDataFunction: () {
                          // updateNewPost() {
                          // setState(() {
                          //   postData = ref.watch(currentPostControllerProvider).currentPost;
                          // });
                          // }
                        },
                      ),
                      opaque: false);
                },
              ));
  }

  Widget _buildImageMediaNetwork(int index) {
    return ExtendedImage.network(
      medias[index]['url'],
      key: Key(medias[index]['id']),
      fit: BoxFit.fitWidth,
      width: MediaQuery.sizeOf(context).width,
      loadStateChanged: (state) {
        _buildLoadingExtendexImage(state, index);
        return null;
      },
    );
  }

  Widget? _buildLoadingExtendexImage(state, index) {
    if (state.extendedImageLoadState != LoadState.completed) {
      return Container(
        height: double.parse(
            (medias[index]?['meta']?['small']?['height'] ?? 400).toString()),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: greyColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.0)),
      );
    }
    return null;
  }

  Widget buildAppbar() {
    final size = MediaQuery.sizeOf(context);
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          setState(() {
            isDragOutside = true;
          });
          Navigator.pop(context);
        },
        child: Icon(
          FontAwesomeIcons.chevronLeft,
          color: Theme.of(context).textTheme.displayLarge!.color,
        ),
      ),
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
      switch (decelerationRate) {
        case ScrollDecelerationRate.fast:
          break;
        case ScrollDecelerationRate.normal:
          break;
      }
      return null;
    }
    return null;
  }
}
