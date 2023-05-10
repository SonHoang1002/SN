import 'dart:async';
import 'dart:math' as math;
import 'package:extended_image/extended_image.dart';
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
    // REVERSE: KEOS TỪ DƯỚI LÊN
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
                            isDragOutside = false;
                            updatePositonY = 0;
                            beginPositonY = 0;
                          });
                        } else {
                          if ((updatePositonY! - beginPositonY!) > 0) {
                            setState(() {
                              isDragOutside = false;
                              closeDirection = closeTopToBottom;
                            });
                          } else {
                            setState(() {
                              isDragOutside = false;
                              closeDirection = closeBottomToTop;
                            });
                          }
                        }
                      }
                      return true;
                    },
                    child: Column(
                      children: [
                        isDragOutside ? buildAppbar() : const SizedBox(),
                        Flexible(
                            flex: 1,
                            child: Container(
                              color: transparent,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                controller: _scrollParentController,
                                child: Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // isDragOutside
                                        //     ? buildAppbar()
                                        //     : const SizedBox(),
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
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: double.parse(
                                                                  medias[index]['meta']
                                                                              ["small"]
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
                                          height: isDragOutside ? 100 : 20,
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
  const CustomBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    if (position.maxScrollExtent < value &&
        position.pixels < position.maxScrollExtent) {
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }
}

// class CustomBouncingScrollPhysics extends ScrollPhysics {
//   /// Creates scroll physics that bounce back from the edge.
//   const CustomBouncingScrollPhysics({
//     this.decelerationRate = ScrollDecelerationRate.normal,
//     this.isOverScroll ,
//     super.parent,
//   });

//   /// Used to determine parameters for friction simulations.
//   final ScrollDecelerationRate decelerationRate;
//   final bool? isOverScroll;

//   @override
//   CustomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
//     return CustomBouncingScrollPhysics(
//         parent: buildParent(ancestor), decelerationRate: decelerationRate);
//   }

//   @override
//   bool shouldAcceptUserOffset(ScrollMetrics position) => isOverScroll??true;

//   @override
//   bool get allowImplicitScrolling => isOverScroll??true;

//   /// The multiple applied to overscroll to make it appear that scrolling past
//   /// the edge of the scrollable contents is harder than scrolling the list.
//   /// This is done by reducing the ratio of the scroll effect output vs the
//   /// scroll gesture input.
//   ///
//   /// This factor starts at 0.52 and progressively becomes harder to overscroll
//   /// as more of the area past the edge is dragged in (represented by an increasing
//   /// `overscrollFraction` which starts at 0 when there is no overscroll).
//   double frictionFactor(double overscrollFraction) {
//     switch (decelerationRate) {
//       case ScrollDecelerationRate.fast:
//         return 0.07 * math.pow(1 - overscrollFraction, 2);
//       case ScrollDecelerationRate.normal:
//         return 0.52 * math.pow(1 - overscrollFraction, 2);
//     }
//   }

//   @override
//   double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
//     assert(offset != 0.0);
//     assert(position.minScrollExtent <= position.maxScrollExtent);

//     if (!position.outOfRange) {
//       return offset;
//     }

//     final double overscrollPastStart =
//         math.max(position.minScrollExtent - position.pixels, 0.0);
//     final double overscrollPastEnd =
//         math.max(position.pixels - position.maxScrollExtent, 0.0);
//     final double overscrollPast =
//         math.max(overscrollPastStart, overscrollPastEnd);
//     final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
//         (overscrollPastEnd > 0.0 && offset > 0.0);

//     final double friction = easing
//         // Apply less resistance when easing the overscroll vs tensioning.
//         ? frictionFactor(
//             (overscrollPast - offset.abs()) / position.viewportDimension)
//         : frictionFactor(overscrollPast / position.viewportDimension);
//     final double direction = offset.sign;

//     return direction * _applyFriction(overscrollPast, offset.abs(), friction);
//   }

//   static double _applyFriction(
//       double extentOutside, double absDelta, double gamma) {
//     assert(absDelta > 0);
//     double total = 0.0;
//     if (extentOutside > 0) {
//       final double deltaToLimit = extentOutside / gamma;
//       if (absDelta < deltaToLimit) {
//         return absDelta * gamma;
//       }
//       total += extentOutside;
//       absDelta -= deltaToLimit;
//     }
//     return total + absDelta;
//   }

//   @override
//   double applyBoundaryConditions(ScrollMetrics position, double value) => 0.0;

//   @override
//   Simulation? createBallisticSimulation(
//       ScrollMetrics position, double velocity) {
//     final Tolerance tolerance = this.tolerance;
//     if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
//       double constantDeceleration;
//       switch (decelerationRate) {
//         case ScrollDecelerationRate.fast:
//           constantDeceleration = 1400;
//           break;
//         case ScrollDecelerationRate.normal:
//           constantDeceleration = 0;
//           break;
//       }
//       return BouncingScrollSimulation(
//           spring: spring,
//           position: position.pixels,
//           velocity: velocity,
//           leadingExtent: position.minScrollExtent,
//           trailingExtent: position.maxScrollExtent,
//           tolerance: tolerance,
//           constantDeceleration: constantDeceleration);
//     }
//     return null;
//   }

//   // The ballistic simulation here decelerates more slowly than the one for
//   // ClampingScrollPhysics so we require a more deliberate input gesture
//   // to trigger a fling.
//   @override
//   double get minFlingVelocity => kMinFlingVelocity * 2.0;

//   // Methodology:
//   // 1- Use https://github.com/flutter/platform_tests/tree/master/scroll_overlay to test with
//   //    Flutter and platform scroll views superimposed.
//   // 3- If the scrollables stopped overlapping at any moment, adjust the desired
//   //    output value of this function at that input speed.
//   // 4- Feed new input/output set into a power curve fitter. Change function
//   //    and repeat from 2.
//   // 5- Repeat from 2 with medium and slow flings.
//   /// Momentum build-up function that mimics iOS's scroll speed increase with repeated flings.
//   ///
//   /// The velocity of the last fling is not an important factor. Existing speed
//   /// and (related) time since last fling are factors for the velocity transfer
//   /// calculations.
//   @override
//   double carriedMomentum(double existingVelocity) {
//     return existingVelocity.sign *
//         math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
//             40000.0);
//   }

//   // Eyeballed from observation to counter the effect of an unintended scroll
//   // from the natural motion of lifting the finger after a scroll.
//   @override
//   double get dragStartDistanceMotionThreshold => 3.5;

//   @override
//   double get maxFlingVelocity {
//     switch (decelerationRate) {
//       case ScrollDecelerationRate.fast:
//         return kMaxFlingVelocity * 8.0;
//       case ScrollDecelerationRate.normal:
//         return super.maxFlingVelocity;
//     }
//   }

//   @override
//   SpringDescription get spring {
//     switch (decelerationRate) {
//       case ScrollDecelerationRate.fast:
//         return SpringDescription.withDampingRatio(
//           mass: 0.3,
//           stiffness: 75.0,
//           ratio: 1.3,
//         );
//       case ScrollDecelerationRate.normal:
//         return super.spring;
//     }
//   }
// }

