import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/providers/posts/reaction_message_content.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Reaction/src/models/reaction.dart';
import 'package:social_network_app_mobile/widget/Reaction/src/ui/reaction_button.dart';
import 'package:social_network_app_mobile/widget/Reaction/src/ui/test/show_position_fill.dart';
import 'package:social_network_app_mobile/widget/Reaction/src/utils/extensions.dart';
import 'package:social_network_app_mobile/widget/Reaction/src/utils/reactions_position.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ReactionsBox extends ConsumerStatefulWidget {
  final Offset buttonOffset;

  final Size buttonSize;

  final List<Reaction?> reactions;

  final VerticalPosition verticalPosition;

  final HorizontalPosition horizontalPosition;

  final Color color;

  final double elevation;

  final double radius;

  final Offset offset;

  final Duration duration;

  final EdgeInsetsGeometry boxPadding;

  final double reactionSpacing;

  final double itemScale;

  final Duration? itemScaleDuration;

  final Function? onIconFocus;

  final Function? onWaitingReaction;

  final Function? onHoverReaction;
  final Function? onCancelReaction;
  // final Function? onCancelReaction;

  const ReactionsBox(
      {Key? key,
      required this.buttonOffset,
      required this.buttonSize,
      required this.reactions,
      required this.verticalPosition,
      required this.horizontalPosition,
      this.color = Colors.white,
      this.elevation = 5,
      this.radius = 50,
      this.offset = Offset.zero,
      this.duration = const Duration(milliseconds: 50),
      this.boxPadding = EdgeInsets.zero,
      this.reactionSpacing = 0,
      this.itemScale = .3,
      this.itemScaleDuration,
      this.onIconFocus,
      this.onWaitingReaction,
      this.onHoverReaction,
      this.onCancelReaction})
      : assert(itemScale > 0.0 && itemScale < 1),
        super(key: key);

  @override
  ConsumerState<ReactionsBox> createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends ConsumerState<ReactionsBox>
    with TickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();

  int durationAnimationBox = 200;
  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 1000;

  // For long press btn
  late AnimationController animControlBtnLongPress, animControlBox;
  late Animation zoomIconLikeInBtn, tiltIconLikeInBtn, zoomTextLikeInBtn;
  late Animation fadeInBox;
  late Animation moveRightGroupIcon;
  late Animation pushIconLikeUp,
      pushIconLoveUp,
      pushIconYayUp,
      pushIconHahaUp,
      pushIconWowUp,
      pushIconSadUp,
      pushIconAngryUp;

  late Animation zoomIconLike,
      zoomIconLove,
      zoomIconYay,
      zoomIconHaha,
      zoomIconWow,
      zoomIconSad,
      zoomIconAngry;

  // For short press btn
  late AnimationController animControlBtnShortPress;
  late Animation zoomIconLikeInBtn2, tiltIconLikeInBtn2;

  // For zoom icon when drag
  late AnimationController animControlIconWhenDrag;
  late AnimationController animControlIconWhenDragInside;
  late AnimationController animControlIconWhenDragOutside;
  late AnimationController animControlBoxWhenDragOutside;
  late Animation zoomIconChosen, zoomIconNotChosen;
  late Animation zoomIconWhenDragOutside;
  late Animation zoomIconWhenDragInside;
  late Animation zoomBoxWhenDragOutside;
  late Animation zoomBoxIcon;

  // For jump icon when release
  late AnimationController animControlIconWhenRelease;
  late Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  late Animation moveLeftIconLikeWhenRelease,
      moveLeftIconLoveWhenRelease,
      moveLeftIconYayWhenRelease,
      moveLeftIconHahaWhenRelease,
      moveLeftIconWowWhenRelease,
      moveLeftIconSadWhenRelease,
      moveLeftIconAngryWhenRelease;

  Duration durationLongPress = const Duration(milliseconds: 250);
  late Timer holdTimer;
  bool isLongPress = true;
  bool isLiked = false;

  // 0 = nothing, 1 = like, 2 = love, 3 = yay, 4 = hahe, 5 = wow, 6 = sad, 7 = angry
  int whichIconUserChoose = 0;

  // 0 = nothing, 1 = like, 2 = love, 3 = yay, 4 = hahe, 5 = wow, 6 = sad, 7 = angry
  int currentIconFocus = 0;
  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  Offset? offset;

  late Animation<Size?> _boxSizeAnimation;
  late Tween<Size?> _boxSizeTween;
  late AnimationController _boxSizeController;
  double width = 0;
  double height = 0;
  bool isFirstDrag = true;
  double compareWidth = 360;

  late AudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    holdTimer = Timer(durationLongPress, showBox);
    _boxSizeController =
        AnimationController(vsync: this, duration: widget.duration);
    _boxSizeTween = Tween();
    _boxSizeAnimation = _boxSizeTween.animate(_boxSizeController);
    // Button Like
    initAnimationBtnLike();

    // Box and Icons
    initAnimationBoxAndIcons();

    // Icon when drag
    initAnimationIconWhenDrag();

    // Icon when drag outside
    initAnimationIconWhenDragOutside();

    // Box when drag outside
    initAnimationBoxWhenDragOutside();

    // Icon when first drag
    initAnimationIconWhenDragInside();

    // Icon when release
    initAnimationIconWhenRelease();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Material(
        elevation: 0,
        color: Colors.transparent,
        child: Stack(children: [
          Positioned.fill(
            child: Listener(
              onPointerDown: (_) {
                onTapUpBtn(null);
                widget.onCancelReaction != null
                    ? widget.onCancelReaction!()
                    : null;
                Navigator.of(context).pop();
              },
              onPointerUp: (_) {},
              onPointerMove: (_) {},
              child: Container(color: transparent),
            ),
          ),
          PositionedDirectional(
              top: _getVerticalPosition() - 100,
              start: _getHorizontalPosition(),
              child: NotificationListener(
                onNotification: (notification) {
                  if (notification is CustomNotification &&
                      notification.name == 'long_press_event') {
                    final details = notification.data;
                    onHorizontalDragUpdateBoxIcon(details);
                    return true;
                  }
                  return false;
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    onTapBtn();
                    onDragUpdateBoxIcon(details);
                    Future.delayed(const Duration(milliseconds: 250), () {
                      onDragEndBoxIcon();
                    });
                  },
                  onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
                  onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,
                  child: Column(
                    children: <Widget>[
                      // main content
                      Stack(
                        children: <Widget>[
                          // Box and icons
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              // Box
                              renderBox(),
                              // Icons
                              renderIcons(),
                            ],
                          ),
                          // Icon like
                          whichIconUserChoose == 1 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: processTopPosition(
                                            moveUpIconWhenRelease.value) +
                                        50,
                                    left: moveLeftIconLikeWhenRelease.value,
                                  ),
                                  child: Transform.scale(
                                    scale: zoomIconWhenRelease.value,
                                    child: Image.asset(
                                      'assets/reaction/like.gif',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                )
                              : Container(),
                          // Icon love
                          whichIconUserChoose == 2 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left: moveLeftIconLoveWhenRelease.value,
                                  ),
                                  child: Transform.scale(
                                    scale: zoomIconWhenRelease.value,
                                    child: Image.asset(
                                      'assets/reaction/tym.gif',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                )
                              : Container(),
                          // Icon yay
                          whichIconUserChoose == 3 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left: moveLeftIconYayWhenRelease.value,
                                  ),
                                  child: Transform.scale(
                                    scale: zoomIconWhenRelease.value,
                                    child: Image.asset(
                                      'assets/reaction/hug.gif',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                )
                              : Container(),
                          // Icon haha
                          whichIconUserChoose == 4 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left: moveLeftIconHahaWhenRelease.value,
                                  ),
                                  child: Transform.scale(
                                    scale: zoomIconWhenRelease.value,
                                    child: Image.asset(
                                      'assets/reaction/haha.gif',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                )
                              : Container(),
                          // Icon Wow
                          whichIconUserChoose == 5 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left: moveLeftIconWowWhenRelease.value,
                                  ),
                                  child: Transform.scale(
                                    scale: zoomIconWhenRelease.value,
                                    child: Image.asset(
                                      'assets/reaction/wow.gif',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                )
                              : Container(),
                          // Icon sad
                          whichIconUserChoose == 6 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left: moveLeftIconSadWhenRelease.value,
                                  ),
                                  child: Transform.scale(
                                    scale: zoomIconWhenRelease.value,
                                    child: Image.asset(
                                      'assets/reaction/cry.gif',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                )
                              : Container(),
                          // Icon angry
                          whichIconUserChoose == 7 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left: moveLeftIconAngryWhenRelease.value,
                                  ),
                                  child: Transform.scale(
                                    scale: zoomIconWhenRelease.value,
                                    child: Image.asset(
                                      'assets/reaction/mad.gif',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
        ]));
  }

  double setBottomMarginBox() {
    double margin = 0;
    bool isSizeBig = width > compareWidth;
    if (isSizeBig) {
      margin = 80;
      if (whichIconUserChoose != 0 && isDragging) {
        margin = 85;
        if (currentIconFocus == 2) {
          margin = 98;
        } else if (currentIconFocus == 3) {
          // margin = 100;
          margin = 90;
        }
      }
    } else {
      margin = 60;
      if (whichIconUserChoose != 0 && isDragging) {
        margin = 75;
        if (currentIconFocus == 2) {
          margin = 83;
        }
        if (currentIconFocus == 3) {
          // margin = 98;
          margin = 88;
        }
        // if (currentIconFocus == 4) {
        //   margin = 70;
        // }
      }
    }
    return margin;
  }

  Widget renderBox() {
    bool isSizeBig = width > compareWidth;
    return Opacity(
      opacity: fadeInBox.value,
      child: Container(
        margin: EdgeInsets.only(bottom: setBottomMarginBox()),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey.shade300, width: 0.3),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                offset: Offset.lerp(
                    const Offset(0.0, 0.0), const Offset(0.0, 0.5), 10.0)!),
          ],
        ),
        width: width * 0.91,
        height:
            //  isDragging
            //     ? (previousIconFocus == 0 ? zoomBoxIcon.value : 40.0)
            //     : isDraggingOutside
            //         ? zoomBoxWhenDragOutside.value
            //         :
            isSizeBig ? 50.0 : 40,
      ),
    );
  }

  double setTopPaddingIcons() {
    //padding top
    bool isSizeBig = width > compareWidth;
    double padding = 0;
    if (isSizeBig) {
      padding = 20;
      if (whichIconUserChoose != 0 && isDragging) {
        if (currentIconFocus == 2) {
          padding = 7;
        } else if (currentIconFocus == 3) {
          padding = 5;
        }
      }
    } else {
      padding = 40;
      if (whichIconUserChoose != 0 && isDragging) {
        padding = 38;
        if (currentIconFocus == 2) {
          // padding = 15;
          padding = 25;
        } else if (currentIconFocus == 3) {
          padding = 21;
        } else if (currentIconFocus == 4) {
          padding = 35;
        }
      }
    }
    return padding;
  }

  double setBottomMarginIcons() {
    bool isSizeBig = width > compareWidth;
    double bottomMargin = 0;
    if (isSizeBig) {
      if (whichIconUserChoose != 0 && isDragging) {
        bottomMargin = 10;
        if (currentIconFocus == 3) {}
      } else {
        bottomMargin = 0;
      }
    } else {
      if (whichIconUserChoose != 0 && isDragging) {
        bottomMargin = 15;
        if (currentIconFocus == 2) {
          bottomMargin = 20;
        }
      } else {
        bottomMargin = 0;
      }
    }
    return bottomMargin;
  }

  double setBottomPaddingIcons() {
    bool isSizeBig = width > compareWidth;
    double bottomPadding = 0;
    if (isSizeBig) {
    } else {
      if (whichIconUserChoose != 0 && isDragging) {
        // bottomPadding = 0;
        if (currentIconFocus == 2) {
          // bottomPadding = 40;
        }
      }
    }
    return bottomPadding;
  }

  Widget renderIcons() {
    bool isSizeBig = width > compareWidth;
    return Container(
      alignment: Alignment.bottomCenter,
      width: width * 0.9,
      margin: EdgeInsets.only(bottom: setBottomMarginIcons()),
      padding: EdgeInsets.only(
        top: setTopPaddingIcons(),
        bottom: setBottomPaddingIcons(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // icon like
          Transform.scale(
            alignment: isDragging && currentIconFocus == 1
                ? Alignment.center
                : Alignment.centerRight,
            scale: isDragging
                ? (currentIconFocus == 1
                    ? zoomIconChosen.value
                    : (previousIconFocus == 1
                        ? zoomIconNotChosen.value
                        : isJustDragInside
                            ? zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? zoomIconWhenDragOutside.value
                    : zoomIconLike.value,
            child: Container(
              margin: EdgeInsets.only(
                  top: (currentIconFocus == 1) ? 4 : 0,
                  bottom: isSizeBig
                      ? currentIconFocus == 1
                          ? pushIconLikeUp.value - 5
                          : (currentIconFocus == 3)
                              ? pushIconLikeUp.value - 10
                              : pushIconLikeUp.value
                      : currentIconFocus == 1
                          ? pushIconLikeUp.value - 10
                          : pushIconLikeUp.value - 20),
              width: isSizeBig ? 38.0 : 30.0,
              height: isSizeBig
                  ? currentIconFocus == 1
                      ? 70.0
                      : 38.0
                  : currentIconFocus == 1
                      ? 60.0
                      : 30.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 1
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            'Like',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        )
                      : Container(),
                  Image.asset(
                    'assets/reaction/like.gif',
                    width: isSizeBig ? 38.0 : 30.0,
                    height: isSizeBig ? 38.0 : 30.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // icon love
          Transform.scale(
            alignment: isDragging && currentIconFocus == 2
                ? Alignment.center
                : Alignment.centerRight,
            scale: isDragging
                ? (currentIconFocus == 2
                    ? Tween(begin: 1.0, end: 1.4)
                        .animate(animControlIconWhenDrag)
                        .value
                    : (previousIconFocus == 2
                        ? zoomIconNotChosen.value
                        : isJustDragInside
                            ? zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? zoomIconWhenDragOutside.value
                    : zoomIconLove.value,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: isSizeBig
                      ? currentIconFocus == 2
                          ? pushIconLoveUp.value + 20
                          : (currentIconFocus == 3)
                              ? pushIconLoveUp.value - 10
                              : pushIconLoveUp.value
                      : currentIconFocus == 2
                          ? pushIconLoveUp.value - 7
                          : pushIconLoveUp.value - 20),
              padding: EdgeInsets.only(
                left: isSizeBig
                    ? currentIconFocus == 2
                        ? 7
                        : 0
                    : 0,
                top: isSizeBig
                    ? 0
                    : currentIconFocus == 2
                        ? 0
                        : 5,
                // bottom: isSizeBig
                //     ? 0
                //     : currentIconFocus == 2
                //         ? 7
                //         : 0,
              ),
              height: isSizeBig
                  ? currentIconFocus == 2
                      ? 96.0
                      : 90.0
                  : currentIconFocus == 2
                      ? 86.0
                      : 80.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 2
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            'Love',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        )
                      : Container(),
                  Image.asset(
                    'assets/reaction/tym.gif',
                    width: isSizeBig ? 75.0 : 58.0,
                    height: isSizeBig ? 75.0 : 58.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // icon yay
          Transform.scale(
            alignment: isDragging && currentIconFocus == 3
                ? Alignment.center
                : Alignment.centerRight,
            scale: isDragging
                ? (currentIconFocus == 3
                    ? zoomIconChosen.value
                    : (previousIconFocus == 3
                        ? zoomIconNotChosen.value
                        : isJustDragInside
                            ? zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? zoomIconWhenDragOutside.value
                    : zoomIconYay.value,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: isSizeBig
                      ? currentIconFocus == 3
                          ? pushIconYayUp.value + 10
                          : pushIconYayUp.value
                      : currentIconFocus == 3
                          ? pushIconYayUp.value
                          : pushIconYayUp.value - 20),
              padding: EdgeInsets.only(
                left: currentIconFocus == 3 ? 10.0 : 0,
                top: (currentIconFocus == 3) ? 4 : 0,
              ),
              width: isSizeBig ? 50.0 : 40.0,
              height: isSizeBig
                  ? currentIconFocus == 3
                      ? 100.0
                      : 90.0
                  : currentIconFocus == 3
                      ? 90
                      : 80,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 3
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            'Yay',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        )
                      : Container(),
                  Image.asset(
                    'assets/reaction/hug.gif',
                    width: isSizeBig ? 65.0 : 55.0,
                    height: isSizeBig ? 65.0 : 55.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // icon haha
          Transform.scale(
            alignment: isDragging && currentIconFocus == 4
                ? Alignment.center
                : Alignment.centerRight,
            scale: isDragging
                ? (currentIconFocus == 4
                    ? zoomIconChosen.value
                    : (previousIconFocus == 4
                        ? zoomIconNotChosen.value
                        : isJustDragInside
                            ? zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? zoomIconWhenDragOutside.value
                    : zoomIconHaha.value,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: isSizeBig
                      ? currentIconFocus == 4
                          ? pushIconHahaUp.value + 8
                          : (currentIconFocus == 3)
                              ? pushIconHahaUp.value - 10
                              : pushIconHahaUp.value
                      : currentIconFocus == 4
                          ? pushIconHahaUp.value - 5
                          : pushIconHahaUp.value - 15,
                  left: isSizeBig
                      ? currentIconFocus == 4
                          ? 7.0
                          : 0
                      : 0),
              padding: EdgeInsets.only(
                  top: isSizeBig
                      ? 0
                      : currentIconFocus == 4
                          ? 2
                          : 0),
              width: isSizeBig ? 55.0 : 45.0,
              height: isSizeBig
                  ? currentIconFocus == 4
                      ? 76.0
                      : 55.0
                  : currentIconFocus == 4
                      ? 69.0
                      : 45.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 4
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            'Haha',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        )
                      : Container(),
                  Image.asset(
                    'assets/reaction/haha.gif',
                    width: isSizeBig ? 55.0 : 45.0,
                    height: isSizeBig ? 55.0 : 45.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // icon wow
          Transform.scale(
            alignment: isDragging && currentIconFocus == 5
                ? Alignment.center
                : Alignment.centerRight,
            scale: isDragging
                ? (currentIconFocus == 5
                    ? zoomIconChosen.value
                    : (previousIconFocus == 5
                        ? zoomIconNotChosen.value
                        : isJustDragInside
                            ? zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? zoomIconWhenDragOutside.value
                    : zoomIconWow.value,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: isSizeBig
                      ? (currentIconFocus == 5)
                          ? pushIconWowUp.value + 2
                          : pushIconWowUp.value
                      : currentIconFocus == 5
                          ? pushIconWowUp.value - 5
                          : pushIconWowUp.value - 15,
                  top: (currentIconFocus == 3) ? 7 : 0,
                  left: isSizeBig
                      ? currentIconFocus == 5
                          ? 2
                          : 0
                      : 0),
              padding: EdgeInsets.only(
                top: isSizeBig
                    ? 0
                    : (currentIconFocus == 5)
                        ? 0
                        : 0,
              ),
              width: isSizeBig ? 43.0 : 37.0,
              height: isSizeBig
                  ? currentIconFocus == 5
                      ? 70.0
                      : 43.0
                  : currentIconFocus == 5
                      ? 60.0
                      : 35.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 5
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            'Wow',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        )
                      : Container(),
                  Image.asset(
                    'assets/reaction/wow.gif',
                    width: isSizeBig ? 43.0 : 35.0,
                    height: isSizeBig ? 43.0 : 35.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // icon sad
          Transform.scale(
            alignment: isDragging && currentIconFocus == 6
                ? Alignment.center
                : Alignment.centerRight,
            scale: isDragging
                ? (currentIconFocus == 6
                    ? zoomIconChosen.value
                    : (previousIconFocus == 6
                        ? zoomIconNotChosen.value
                        : isJustDragInside
                            ? zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? zoomIconWhenDragOutside.value
                    : zoomIconSad.value,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: isSizeBig
                      ? currentIconFocus == 6
                          ? pushIconSadUp.value + 3
                          : pushIconSadUp.value
                      : pushIconSadUp.value - 15,
                  top: (currentIconFocus == 3) ? 7 : 0,
                  left: currentIconFocus == 6 ? 5.0 : 0),
              width: isSizeBig ? 45.0 : 37.0,
              height: isSizeBig
                  ? currentIconFocus == 6
                      ? 70.0
                      : 45.0
                  : currentIconFocus == 6
                      ? 60.0
                      : 37.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 6
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            'Sad',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        )
                      : Container(),
                  Image.asset(
                    'assets/reaction/cry.gif',
                    width: isSizeBig ? 45.0 : 37.0,
                    height: isSizeBig ? 45.0 : 37.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // icon angry
          Transform.scale(
            alignment: isDragging && currentIconFocus == 7
                ? Alignment.center
                : Alignment.centerRight,
            scale: isDragging
                ? (currentIconFocus == 7
                    ? zoomIconChosen.value
                    : (previousIconFocus == 7
                        ? zoomIconNotChosen.value
                        : isJustDragInside
                            ? zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? zoomIconWhenDragOutside.value
                    : zoomIconAngry.value,
            child: Container(
              margin: EdgeInsets.only(
                // top: (currentIconFocus == 3) ? 3 : 0,
                bottom: isSizeBig
                    ? (currentIconFocus == 3)
                        ? pushIconAngryUp.value - 10
                        : pushIconAngryUp.value
                    : (currentIconFocus == 7)
                        ? pushIconAngryUp.value + 11
                        : pushIconAngryUp.value - 16,
                left: currentIconFocus == 7 ? 5.0 : 0,
              ),
              padding: EdgeInsets.only(
                top: currentIconFocus == 7 ? 2 : 0,
              ),
              width: isSizeBig ? 40.0 : 33.0,
              height: isSizeBig
                  ? currentIconFocus == 7
                      ? 70.0
                      : 40.0
                  : currentIconFocus == 7
                      ? 60.0
                      : 33.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 7
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            'Angry',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        )
                      : Container(),
                  Image.asset(
                    'assets/reaction/mad.gif',
                    width: isSizeBig ? 40.0 : 33.0,
                    height: isSizeBig ? 40.0 : 33.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // color: Colors.amber.withOpacity(0.5),
    );
  }

  double _getHorizontalPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * .09 / 2;
  }

  double _getVerticalPosition() {
    final yOffset = widget.offset.dy;
    final boxHeight = _boxSizeAnimation.value?.height ?? 0;
    final topPosition =
        widget.buttonOffset.dy - widget.buttonSize.height - boxHeight;
    final bottomPosition = widget.buttonOffset.dy;

    // check if TOP space not enough for the box
    if (topPosition - widget.buttonSize.height * 4.5 < 0) {
      return bottomPosition + yOffset;
    }

    // check if BOTTOM space not enough for the box
    if (bottomPosition + (widget.buttonSize.height * 5.5) >
        context.screenSize.height) {
      return topPosition + yOffset;
    }

    if (widget.verticalPosition == VerticalPosition.top) {
      return topPosition + yOffset;
    }

    return bottomPosition + yOffset;
  }

  double handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  double handleOutputRangeZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  void onTapBtn() {
    playSound('short_press_like.mp3');
    animControlBtnShortPress.forward();
    animControlBtnShortPress.reverse();
  }

  void showBox() {
    playSound('box_up.mp3');
    isLongPress = true;
    animControlBtnLongPress.forward();
    setForwardValue();
    animControlBox.forward();
  }

  void setForwardValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, .4)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, .4)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.1, .5)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.1, .5)),
    );
    pushIconYayUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.2, .6)),
    );
    zoomIconYay = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.2, .6)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.3, .7)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.3, .7)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.4, .8)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.4, .8)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, .9)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, .9)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.6, 1.0)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.6, 1.0)),
    );
  }

  String getTextBtn() {
    if (isDragging) {
      return 'Like';
    }
    switch (whichIconUserChoose) {
      case 1:
        return 'Like';
      case 2:
        return 'Love';
      case 3:
        return 'Yay';
      case 4:
        return 'Haha';
      case 5:
        return 'Wow';
      case 6:
        return 'Sad';
      case 7:
        return 'Angry';
      default:
        return 'Like';
    }
  }

  Color getColorTextBtn() {
    if ((!isLongPress && isLiked)) {
      return const Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return const Color(0xff3b5998);
        case 2:
          return const Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return const Color(0xffFFD96A);
        case 6:
          return const Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }

  String getImageIconBtn() {
    if (!isLongPress && isLiked) {
      return 'assets/reaction/like.png';
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return 'assets/reaction/like.png';
        case 2:
          return 'assets/reaction/love.png';
        case 3:
          return 'assets/reaction/yay.png';
        case 4:
          return 'assets/reaction/haha.png';
        case 5:
          return 'assets/reaction/wow.png';
        case 6:
          return 'assets/reaction/sad.png';
        case 7:
          return 'assets/reaction/angry.png';
        default:
          return 'assets/reaction/img_like_fill.png';
      }
    } else {
      return 'assets/reaction/img_like_fill.png';
    }
  }

  Color? getTintColorIconBtn() {
    if (!isLongPress && isLiked) {
      return const Color(0xff3b5998);
    } else if (!isDragging && whichIconUserChoose != 0) {
      return null;
    } else {
      return Colors.grey;
    }
  }

  double processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)

    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
  }

  Color getColorBorderBtn() {
    if ((!isLongPress && isLiked)) {
      return const Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return const Color(0xff3b5998);
        case 2:
          return const Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return const Color(0xffFFD96A);
        case 6:
          return const Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey.shade400;
    }
  }

  onDragUpdateBoxIcon(details) {
    double iconItemLength = width * 0.91 / 7;
    double beginOffsetX = width * (1 - 0.91) / 2;
    // 392.72727272727275 -  802.9090909090909
    if (!isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (details.globalPosition.dy >= _getVerticalPosition() - 160 &&
        details.globalPosition.dy <= _getVerticalPosition() + 160) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (details.globalPosition.dx >= beginOffsetX &&
          details.globalPosition.dx < beginOffsetX + iconItemLength) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (details.globalPosition.dx >= beginOffsetX + iconItemLength &&
          details.globalPosition.dx < beginOffsetX + 2 * iconItemLength) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (details.globalPosition.dx >=
              beginOffsetX + 2 * iconItemLength &&
          details.globalPosition.dx < beginOffsetX + 3 * iconItemLength) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (details.globalPosition.dx >=
              beginOffsetX + 3 * iconItemLength &&
          details.globalPosition.dx < beginOffsetX + 4 * iconItemLength) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (details.globalPosition.dx >=
              beginOffsetX + 4 * iconItemLength &&
          details.globalPosition.dx < beginOffsetX + 5 * iconItemLength) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (details.globalPosition.dx >=
              beginOffsetX + 5 * iconItemLength &&
          details.globalPosition.dx < beginOffsetX + 6 * iconItemLength) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      } else if (details.globalPosition.dx >=
              beginOffsetX + 6 * iconItemLength &&
          details.globalPosition.dx < beginOffsetX + 7 * iconItemLength) {
        if (currentIconFocus != 7) {
          handleWhenDragBetweenIcon(7);
        }
      }
    } else {
      whichIconUserChoose = 0;
      previousIconFocus = 0;
      currentIconFocus = 0;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    onDragUpdateBoxIcon(dragUpdateDetail);
  }

  void handleWhenDragBetweenIcon(int currentIcon) {
    playSound('icon_focus.mp3');
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  onDragEndBoxIcon() {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;
    onTapUpBtn(null);
    widget.onCancelReaction != null ? widget.onCancelReaction!() : null;
    Navigator.of(context).pop(chooseReactionReturn());
  }

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    onDragEndBoxIcon();
  }

  void onTapUpBtn(TapUpDetails? tapUpDetail) async {
    if (isLongPress) {
      if (whichIconUserChoose == 0) {
        playSound('box_down.mp3');
      } else {
        playSound('icon_choose.mp3');
      }
    }
    Timer(Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });

    holdTimer.cancel();
    animControlBtnLongPress.reverse();
    setReverseValue();
    animControlBox.reverse();
    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
    await animControlBtnLongPress.reverse();
    await animControlBox.reverse();
    await animControlIconWhenDrag.reverse();
    await animControlIconWhenDragInside.reverse();
    await animControlIconWhenDragOutside.reverse();
    await animControlBoxWhenDragOutside.reverse();
  }

  chooseReactionReturn() {
    String value = '';
    switch (whichIconUserChoose) {
      case 1:
        value = "like";
        break;
      case 2:
        value = "love";
        break;
      case 3:
        value = "yay";
        break;
      case 4:
        value = "haha";
        break;
      case 5:
        value = "wow";
        break;
      case 6:
        value = "sad";
        break;
      case 7:
        value = "angry";
        break;
      default:
        break;
    }
    return value != ""
        ? Reaction(
            icon: renderGif('png', value, size: 20),
            value: value,
          )
        : null;
  }

  void setReverseValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.7, 1.0)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.7, 1.0)),
    );
    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.6, .9)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.6, .9)),
    );
    pushIconYayUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, .8)),
    );
    zoomIconYay = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, .8)),
    );

    pushIconYayUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.4, 0.7)),
    );
    zoomIconYay = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.4, 0.7)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.3, 0.6)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.3, 0.6)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.2, 0.5)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.2, 0.5)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.1, 0.4)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.1, 0.4)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 0.3)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 0.3)),
    );
  }

  @override
  void dispose() {
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
    super.dispose();
  }

  initAnimationBtnLike() {
    // long press
    animControlBtnLongPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnLongPress));
    zoomIconLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);
    tiltIconLikeInBtn =
        Tween(begin: 0.0, end: 0.2).animate(animControlBtnLongPress);
    zoomTextLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);

    zoomIconLikeInBtn.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn.addListener(() {
      setState(() {});
    });
    zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    // short press
    animControlBtnShortPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconLikeInBtn2 =
        Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconLikeInBtn2 =
        Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);

    zoomIconLikeInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn2.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxAndIcons() {
    animControlBox = AnimationController(
        vsync: this, duration: Duration(milliseconds: durationAnimationBox));

    // General
    moveRightGroupIcon = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    // Box
    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.7, 1.0)),
    );
    fadeInBox.addListener(() {
      setState(() {});
    });

    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 0.4)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 0.4)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.1, 0.5)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.1, 0.5)),
    );

    //new
    pushIconYayUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.2, 0.6)),
    );
    zoomIconYay = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.2, 0.6)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.3, 0.7)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.3, 0.7)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.4, 0.8)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.4, 0.8)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, 0.9)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, 0.9)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.6, 1.0)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.6, 1.0)),
    );

    pushIconLikeUp.addListener(() {
      setState(() {});
    });
    zoomIconLike.addListener(() {
      setState(() {});
    });
    pushIconLoveUp.addListener(() {
      setState(() {});
    });
    zoomIconLove.addListener(() {
      setState(() {});
    });
    pushIconYayUp.addListener(() {
      setState(() {});
    });
    zoomIconYay.addListener(() {
      setState(() {});
    });
    pushIconHahaUp.addListener(() {
      setState(() {});
    });
    zoomIconHaha.addListener(() {
      setState(() {});
    });
    pushIconWowUp.addListener(() {
      setState(() {});
    });
    zoomIconWow.addListener(() {
      setState(() {});
    });
    pushIconSadUp.addListener(() {
      setState(() {});
    });
    zoomIconSad.addListener(() {
      setState(() {});
    });
    pushIconAngryUp.addListener(() {
      setState(() {});
    });
    zoomIconAngry.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDrag() {
    animControlIconWhenDrag = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));

    zoomIconChosen =
        Tween(begin: 1.0, end: 1.6).animate(animControlIconWhenDrag);
    zoomIconNotChosen =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon =
        Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragOutside =
        Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomBoxWhenDragOutside =
        Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragInside =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  initAnimationIconWhenRelease() {
    animControlIconWhenRelease = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0).animate(CurvedAnimation(
        parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveLeftIconLikeWhenRelease = Tween(begin: 20.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconLoveWhenRelease = Tween(begin: 68.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    //new
    moveLeftIconYayWhenRelease = Tween(begin: 116.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconHahaWhenRelease = Tween(begin: 164.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconWowWhenRelease = Tween(begin: 212.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconSadWhenRelease = Tween(begin: 260.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconAngryWhenRelease = Tween(begin: 318.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconLikeWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconLoveWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconYayWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconHahaWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconWowWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconSadWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconAngryWhenRelease.addListener(() {
      setState(() {});
    });
  }

  Future playSound(String nameSound) async {
    await audioPlayer.stop();
    final file = File('${(await getTemporaryDirectory()).path}/$nameSound');
    await file.writeAsBytes((await loadAsset(nameSound)).buffer.asUint8List());
    audioPlayer.play(UrlSource(file.path));
  }

  Future loadAsset(String nameSound) async {
    return await rootBundle.load('assets/sounds/$nameSound');
  }
}
