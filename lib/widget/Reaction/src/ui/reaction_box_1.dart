// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:social_network_app_mobile/theme/colors.dart';

// import '../models/drag.dart';
// import '../models/reaction.dart';
// import '../utils/extensions.dart';
// import '../utils/reactions_position.dart';
// import 'reactions_box_item.dart';
// import 'widget_size_render_object.dart';

// class ReactionsBox1 extends StatefulWidget {
//   final Offset buttonOffset;

//   final Size buttonSize;

//   final List<Reaction?> reactions;

//   final VerticalPosition verticalPosition;

//   final HorizontalPosition horizontalPosition;

//   final Color color;

//   final double elevation;

//   final double radius;

//   final Offset offset;

//   final Duration duration;

//   final EdgeInsetsGeometry boxPadding;

//   final double reactionSpacing;

//   final double itemScale;

//   final Duration? itemScaleDuration;

//   const ReactionsBox1({
//     Key? key,
//     required this.buttonOffset,
//     required this.buttonSize,
//     required this.reactions,
//     required this.verticalPosition,
//     required this.horizontalPosition,
//     this.color = Colors.white,
//     this.elevation = 5,
//     this.radius = 50,
//     this.offset = Offset.zero,
//     this.duration = const Duration(milliseconds: 200),
//     this.boxPadding = EdgeInsets.zero,
//     this.reactionSpacing = 0,
//     this.itemScale = .3,
//     this.itemScaleDuration,
//   })  : assert(itemScale > 0.0 && itemScale < 1),
//         super(key: key);

//   @override
//   State<ReactionsBox1> createState() => _ReactionsBox1State();
// }

// class _ReactionsBox1State extends State<ReactionsBox1>
//     with TickerProviderStateMixin {
//   final StreamController<DragData?> _dragStreamController =
//       StreamController<DragData?>();

//   late Stream<DragData?> _dragStream;

//   late AnimationController _boxSizeController;

//   late Animation<Size?> _boxSizeAnimation;

//   late Tween<Size?> _boxSizeTween;

//   late AnimationController _scaleController;

//   late Animation<double> _scaleAnimation;

//   late double _itemScale;

//   Reaction? _selectedReaction;

//   DragData? _dragData;

//   double? _getBoxHeight() {
//     if (_boxSizeAnimation.value == null) return null;

//     bool anyItemHasTitle = widget.reactions.any(
//       (item) => item?.title != null,
//     );

//     if (anyItemHasTitle) return _boxSizeAnimation.value!.height * .75;

//     return _boxSizeAnimation.value!.height;
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Calculating how much we should scale up when item hovered
//     _itemScale = 1.5 + widget.itemScale;

//     _boxSizeController =
//         AnimationController(vsync: this, duration: widget.duration);
//     _boxSizeTween = Tween();
//     _boxSizeAnimation = _boxSizeTween.animate(_boxSizeController);

//     _scaleController =
//         AnimationController(vsync: this, duration: widget.duration);
//     final Tween<double> scaleTween = Tween(begin: 0, end: 1);
//     _scaleAnimation = scaleTween.animate(_scaleController)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.reverse) {
//           Navigator.of(context).pop(_selectedReaction);
//         }
//       });

//     _scaleController
//       ..forward()
//       ..addListener(() {
//         setState(() {});
//       });

//     _dragStream = _dragStreamController.stream.asBroadcastStream();
//   }

//   @override
//   void dispose() {
//     _boxSizeController.dispose();
//     _scaleController.dispose();
//     _dragStreamController.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double top = _getVerticalPosition();

//     return Material(
//       elevation: 0,
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: Listener(
//               onPointerDown: (_) {
//                 _scaleController.reverse();
//               },
//               child: Container(
//                 color: Colors.transparent,
//               ),
//             ),
//           ),
//           PositionedDirectional(
//             top: top,
//             start: _getHorizontalPosition(),
//             child: Transform.scale(
//               scale: _scaleAnimation.value,
//               child: AnimatedBuilder(
//                 animation: _boxSizeAnimation,
//                 child: _buildItems(),
//                 builder: (_, child) {
//                   return Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       Container(
//                           margin: const EdgeInsets.only(bottom: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: white,
//                           ),
//                           height: 45,
//                           width: 380),
//                       SizedBox(
//                         height: _boxSizeAnimation.value?.height,
//                         child: Stack(
//                           alignment: Alignment.bottomCenter,
//                           children: [
//                             Material(
//                               color: transparent,
//                               // elevation: widget.elevation,
//                               // clipBehavior: Clip.antiAlias,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(widget.radius),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   SizedBox(
//                                     height: _getBoxHeight(),
//                                     width:  120,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             child!,
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItems() {
//     return WidgetSizeOffsetWrapper(
//       onSizeChange: (Size size) {
//         _boxSizeTween
//           ..begin = size
//           ..end = size;
//         if (_boxSizeController.isCompleted) {
//           _boxSizeController.reverse();
//         } else {
//           _boxSizeController.forward();
//         }
//       },
//       child: Padding(
//         padding: widget.boxPadding,
//         child: Listener(
//           onPointerDown: (point) {
//             _dragData = DragData(offset: point.position);
//             _dragStreamController.add(_dragData);
//           },
//           onPointerMove: (point) {
//             _dragData = DragData(offset: point.position);
//             _dragStreamController.add(_dragData);
//           },
//           onPointerUp: (point) {
//             _dragData = _dragData?.copyWith(isDragEnd: true);
//             _dragStreamController.add(_dragData);
//           },
//           onPointerCancel: (point) {
//             _dragData = _dragData?.copyWith(isDragEnd: true);
//             _dragStreamController.add(_dragData);
//           },
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               for (var i = 0; i < widget.reactions.length; i++) ...[
//                 ReactionsBox1Item(
//                   onReactionSelected: (reaction) {
//                     _selectedReaction = reaction;
//                     _scaleController.reverse();
//                   },
//                   scale: _itemScale,
//                   scaleDuration: widget.itemScaleDuration,
//                   reaction: widget.reactions[i]!,
//                   dragStream: _dragStream,
//                 ),
//                 if (i < widget.reactions.length - 1) ...{
//                   SizedBox(
//                     width: widget.reactionSpacing,
//                   ),
//                 },
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   double _getHorizontalPosition() {
//     final xOffset = widget.offset.dx;
//     final buttonX = widget.buttonOffset.dx;
//     final buttonRadius = (widget.buttonSize.width / 2);
//     final screenWidth = MediaQuery.of(context).size.width;
//     final boxWidth = _boxSizeAnimation.value?.width ?? 0;

//     if (buttonX + boxWidth < screenWidth) {
//       switch (widget.horizontalPosition) {
//         case HorizontalPosition.start:
//           return buttonX - buttonRadius + xOffset;
//         case HorizontalPosition.center:
//           return buttonX - boxWidth / 2 + xOffset;
//       }
//     }

//     final value = buttonX + buttonRadius - boxWidth;

//     //add this below code.
//     if (value.isNegative) {
//       return 20 +
//           xOffset; // this is 20 horizontal width is fix you can play with it as you want.
//     }
//     return value + xOffset;
//   }

//   double _getVerticalPosition() {
//     final yOffset = widget.offset.dy;
//     final boxHeight = _boxSizeAnimation.value?.height ?? 0;
//     final topPosition =
//         widget.buttonOffset.dy - widget.buttonSize.height - boxHeight;
//     final bottomPosition = widget.buttonOffset.dy;

//     // check if TOP space not enough for the box
//     if (topPosition - widget.buttonSize.height * 4.5 < 0) {
//       return bottomPosition + yOffset;
//     }

//     // check if BOTTOM space not enough for the box
//     if (bottomPosition + (widget.buttonSize.height * 5.5) >
//         context.screenSize.height) {
//       return topPosition + yOffset;
//     }

//     if (widget.verticalPosition == VerticalPosition.top) {
//       return topPosition + yOffset;
//     }

//     return bottomPosition + yOffset;
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box_item.dart';
import 'widget_size_render_object.dart';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ReactionsBox1 extends StatefulWidget {
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

  final Function? onSelectedReaction;

  final Function? onWaitingReaction;
  final Function? onHoverReaction;
  const ReactionsBox1(
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
      this.duration = const Duration(milliseconds: 200),
      this.boxPadding = EdgeInsets.zero,
      this.reactionSpacing = 0,
      this.itemScale = .3,
      this.itemScaleDuration,
      this.onSelectedReaction,
      this.onWaitingReaction,
      this.onHoverReaction})
      : assert(itemScale > 0.0 && itemScale < 1),
        super(key: key);

  @override
  State<ReactionsBox1> createState() => _ReactionsBox1State();
}

class _ReactionsBox1State extends State<ReactionsBox1>
    with TickerProviderStateMixin {
  final StreamController<DragData?> _dragStreamController =
      StreamController<DragData?>();

  late Stream<DragData?> _dragStream;

  late AnimationController _boxSizeController;

  late Animation<Size?> _boxSizeAnimation;

  late Tween<Size?> _boxSizeTween;

  late AnimationController _scaleController;

  late Animation<double> _scaleAnimation;

  late double _itemScale;

  Reaction? _selectedReaction;

  DragData? _dragData;

  double? _getBoxHeight() {
    if (_boxSizeAnimation.value == null) return null;

    bool anyItemHasTitle = widget.reactions.any(
      (item) => item?.title != null,
    );

    if (anyItemHasTitle) return _boxSizeAnimation.value!.height * .75;
    return _boxSizeAnimation.value!.height;
  }

  int durationAnimationBox = 500;
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
  Timer? holdTimer;
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

  @override
  void initState() {
    super.initState();
    holdTimer ??= Timer(durationLongPress, showBox);
    // Calculating how much we should scale up when item hovered
    _itemScale = 1.5 + widget.itemScale;

    _boxSizeController =
        AnimationController(vsync: this, duration: widget.duration);
    _boxSizeTween = Tween();
    _boxSizeAnimation = _boxSizeTween.animate(_boxSizeController);

    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);
    final Tween<double> scaleTween = Tween(begin: 0, end: 1);
    _scaleAnimation = scaleTween.animate(_scaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse) {
          Navigator.of(context).pop(_selectedReaction);
        }
      });

    _scaleController
      ..forward()
      ..addListener(() {
        setState(() {});
      });

    _dragStream = _dragStreamController.stream.asBroadcastStream();

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
        vsync: this, duration: const Duration(milliseconds: 200));

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
        Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
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
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenRelease));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0).animate(CurvedAnimation(
        parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 80.0).animate(
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

  @override
  void dispose() {
    _boxSizeController.dispose();
    _scaleController.dispose();
    _dragStreamController.close();
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        color: Colors.transparent,
        child: Stack(children: [
          Positioned.fill(
            child: Listener(
              onPointerDown: (_) {
                _scaleController.reverse();
                onTapUpBtn(null);
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          PositionedDirectional(
              top: _getVerticalPosition(),
              start: _getHorizontalPosition(),
              child: GestureDetector(
                onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
                onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,
                child: Column(
                  children: <Widget>[
                    // main content
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      // Area of the content can drag
                      // decoration:  BoxDecoration(border: Border.all(color: Colors.grey)),
                      width: double.infinity,
                      height: 350.0,
                      child: Stack(
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

                          // Icons when jump
                          // Icon like
                          whichIconUserChoose == 1 && !isDragging
                              ? Container(
                                  margin: EdgeInsets.only(
                                    top: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left:
                                        moveLeftIconLikeWhenRelease.value,
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
                                    top: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left:
                                        moveLeftIconLoveWhenRelease.value,
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
                                    top: processTopPosition(
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
                                    top: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left:
                                        moveLeftIconHahaWhenRelease.value,
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
                                    top: processTopPosition(
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
                                    top: processTopPosition(
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
                                    top: processTopPosition(
                                        moveUpIconWhenRelease.value),
                                    left:
                                        moveLeftIconAngryWhenRelease.value,
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
                    ),
                  ],
                ),
              ))
        ]));
  }

  Widget renderBox() {
    return Opacity(
      opacity: fadeInBox.value,
      child: Container(
        decoration: BoxDecoration(
          // color: greyColor,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey.shade300, width: 0.3),
          boxShadow: [
            BoxShadow(
                color: white,
                blurRadius: 5.0,
                // LTRB
                offset: Offset.lerp(
                    const Offset(0.0, 0.0), const Offset(0.0, 0.5), 10.0)!),
          ],
        ),
        width: 400.0,
        height: isDragging
            ? (previousIconFocus == 0 ? zoomBoxIcon.value : 40.0)
            : isDraggingOutside
                ? zoomBoxWhenDragOutside.value
                : 50.0,
        margin: const EdgeInsets.only(
          top: 7.0,
        ),
      ),
    );
  }

  Widget renderIcons() {
    return Stack(
      children: [
        Opacity(
          opacity: fadeInBox.value,
          child: Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.grey.shade300, width: 0.3),
              boxShadow: [
                BoxShadow(
                    color: white,
                    blurRadius: 5.0,
                    offset: Offset.lerp(
                        const Offset(0.0, 0.0), const Offset(0.0, 0.5), 10.0)!),
              ],
            ),
            width: 350.0,
            height:
                // isDragging
                // ? (previousIconFocus == 0 ? zoomBoxIcon.value : 60.0)
                // : isDraggingOutside
                //     ? zoomBoxWhenDragOutside.value
                //     :
                50.0,
          ),
        ),
        Container(
          // color: greyColor[200],
          width: 350,
          // height: 60,
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          margin: EdgeInsets.only(
              // left: moveRightGroupIcon.value,
              top: isDragging
                  ? isDraggingOutside
                      ? 5.0
                      : 0.0
                  : 5.0,
              bottom: 10.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // icon like
                Transform.scale(
                  scale: isDragging
                      ? (currentIconFocus == 1
                          ? zoomIconChosen.value
                          : (previousIconFocus == 1
                              ? zoomIconNotChosen.value
                              : isJustDragInside
                                  ? 1.0
                                  : 0.8))
                      : isDraggingOutside
                          ? zoomIconWhenDragOutside.value
                          : zoomIconLike.value,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: isDraggingOutside ? 30 : pushIconLikeUp.value),
                    width: 40.0,
                    height: currentIconFocus == 1 ? 70.0 : 40.0,
                    child: Column(
                      children: <Widget>[
                        currentIconFocus == 1
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 7.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: const Text(
                                  'Like',
                                  style: TextStyle(
                                      fontSize: 8.0, color: Colors.white),
                                ),
                              )
                            : Container(),
                        Image.asset(
                          'assets/reaction/like.gif',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),

                // icon love
                Transform.scale(
                  scale: isDragging
                      ? (currentIconFocus == 2
                          ? zoomIconChosen.value
                          : (previousIconFocus == 2
                              ? zoomIconNotChosen.value
                              : isJustDragInside
                                  ? zoomIconWhenDragInside.value
                                  : 0.8))
                      : isDraggingOutside
                          ? zoomIconWhenDragOutside.value
                          : zoomIconLove.value,
                  child: Container(
                    margin: EdgeInsets.only(bottom: pushIconLoveUp.value),
                    width: 40.0,
                    height: currentIconFocus == 2 ? 70.0 : 40.0,
                    child: Column(
                      children: <Widget>[
                        currentIconFocus == 2
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black.withOpacity(0.3)),
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 7.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: const Text(
                                  'Love',
                                  style: TextStyle(
                                      fontSize: 8.0, color: Colors.white),
                                ),
                              )
                            : Container(),
                        Image.asset(
                          'assets/reaction/tym.gif',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),

                // icon yay
                Transform.scale(
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
                    margin: EdgeInsets.only(bottom: pushIconYayUp.value),
                    width: 40.0,
                    height: currentIconFocus == 3 ? 70.0 : 40.0,
                    child: Column(
                      children: <Widget>[
                        currentIconFocus == 3
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black.withOpacity(0.3)),
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 7.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: const Text(
                                  'Yay',
                                  style: TextStyle(
                                      fontSize: 8.0, color: Colors.white),
                                ),
                              )
                            : Container(),
                        Image.asset(
                          'assets/reaction/hug.gif',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),

                // icon haha
                Transform.scale(
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
                    margin: EdgeInsets.only(bottom: pushIconHahaUp.value),
                    width: 40.0,
                    height: currentIconFocus == 4 ? 70.0 : 40.0,
                    child: Column(
                      children: <Widget>[
                        currentIconFocus == 4
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black.withOpacity(0.3)),
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 7.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: const Text(
                                  'Haha',
                                  style: TextStyle(
                                      fontSize: 8.0, color: Colors.white),
                                ),
                              )
                            : Container(),
                        Image.asset(
                          'assets/reaction/haha.gif',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),

                // icon wow
                Transform.scale(
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
                    margin: EdgeInsets.only(bottom: pushIconWowUp.value),
                    width: 40.0,
                    height: currentIconFocus == 5 ? 70.0 : 40.0,
                    child: Column(
                      children: <Widget>[
                        currentIconFocus == 5
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black.withOpacity(0.3)),
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 7.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: const Text(
                                  'Wow',
                                  style: TextStyle(
                                      fontSize: 8.0, color: Colors.white),
                                ),
                              )
                            : Container(),
                        Image.asset(
                          'assets/reaction/wow.gif',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),

                // icon sad
                Transform.scale(
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
                    margin: EdgeInsets.only(bottom: pushIconSadUp.value),
                    width: 40.0,
                    height: currentIconFocus == 6 ? 70.0 : 40.0,
                    child: Column(
                      children: <Widget>[
                        currentIconFocus == 6
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 7.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: const Text(
                                  'Sad',
                                  style: TextStyle(
                                      fontSize: 8.0, color: Colors.white),
                                ),
                              )
                            : Container(),
                        Image.asset(
                          'assets/reaction/cry.gif',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),

                // icon angry
                Transform.scale(
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
                    margin: EdgeInsets.only(bottom: pushIconAngryUp.value),
                    width: 40.0,
                    height: currentIconFocus == 7 ? 70.0 : 40.0,
                    child: Column(
                      children: <Widget>[
                        currentIconFocus == 7
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 7.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: const Text(
                                  'Angry',
                                  style: TextStyle(
                                      fontSize: 8.0, color: Colors.white),
                                ),
                              )
                            : Container(),
                        Image.asset(
                          'assets/reaction/mad.gif',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getHorizontalPosition() {
    final xOffset = widget.offset.dx;

    final buttonX = widget.buttonOffset.dx;

    final buttonRadius = (widget.buttonSize.width / 2);

    final screenWidth = MediaQuery.of(context).size.width;

    final boxWidth = _boxSizeAnimation.value?.width ?? 0;

    if (buttonX + boxWidth < screenWidth) {
      switch (widget.horizontalPosition) {
        case HorizontalPosition.start:
          return buttonX - buttonRadius + xOffset;
        case HorizontalPosition.center:
          return buttonX - boxWidth / 2 + xOffset;
      }
    }

    final value = buttonX + buttonRadius - boxWidth;

    //add this below code.
    if (value.isNegative) {
      return 20 +
          xOffset; // this is 20 horizontal width is fix you can play with it as you want.
    }
    print("reaction value + xOffset ${value + xOffset}");
    return value + xOffset;
  }

  double _getVerticalPosition() {
    final yOffset = widget.offset.dy;
    final boxHeight = _boxSizeAnimation.value?.height ?? 80;
    final topPosition =
        widget.buttonOffset.dy - widget.buttonSize.height - boxHeight;
    final bottomPosition = widget.buttonOffset.dy;
    // check if TOP space not enough for the box
    if (topPosition - widget.buttonSize.height * 4.5 < 0) {
      return bottomPosition + yOffset + 25;
    }

    // check if BOTTOM space not enough for the box
    if (bottomPosition + (widget.buttonSize.height * 5.5) >
        context.screenSize.height) {
      return topPosition + yOffset;
    }

    if (widget.verticalPosition == VerticalPosition.top) {
      return topPosition + yOffset;
    }

    return bottomPosition + yOffset - 200;
  }

  // Widget renderBtnLike() {
  //   return Container(
  //     width: 100.0,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(4.0),
  //       color: Colors.white,
  //       border: Border.all(color: getColorBorderBtn()),
  //     ),
  //     margin: const EdgeInsets.only(top: 190.0),
  //     child: GestureDetector(
  //       onTapDown: onTapDownBtn,
  //       onTapUp: onTapUpBtn,
  //       onTap: onTapBtn,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           // Icon like
  //           Transform.scale(
  //             scale: !isLongPress
  //                 ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value)
  //                 : zoomIconLikeInBtn.value,
  //             child: Transform.rotate(
  //               angle: !isLongPress
  //                   ? handleOutputRangeTiltIconLike(tiltIconLikeInBtn2.value)
  //                   : tiltIconLikeInBtn.value,
  //               child: Image.asset(
  //                 getImageIconBtn(),
  //                 width: 25.0,
  //                 height: 25.0,
  //                 fit: BoxFit.contain,
  //                 color: getTintColorIconBtn(),
  //               ),
  //             ),
  //           ),
  //           // Text like
  //           Transform.scale(
  //             scale: !isLongPress
  //                 ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value)
  //                 : zoomTextLikeInBtn.value,
  //             child: Text(
  //               getTextBtn(),
  //               style: TextStyle(
  //                 color: getColorTextBtn(),
  //                 fontSize: 14.0,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    onTapUpBtn(null);
    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  void onTapReactionIcon(TapDownDetails details) {
    final boxHeight = _boxSizeAnimation.value?.height ?? 123;
    final topPosition =
        widget.buttonOffset.dy - widget.buttonSize.height - boxHeight;
    final bottomPosition = widget.buttonOffset.dy;

    if (details.globalPosition.dy >= topPosition - 75 &&
        details.globalPosition.dy <= bottomPosition + 46) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (details.globalPosition.dx >= 20 && details.globalPosition.dx < 83) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (details.globalPosition.dx >= 83 &&
          details.globalPosition.dx < 126) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (details.globalPosition.dx >= 126 &&
          details.globalPosition.dx < 180) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (details.globalPosition.dx >= 180 &&
          details.globalPosition.dx < 233) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (details.globalPosition.dx >= 233 &&
          details.globalPosition.dx < 286) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (details.globalPosition.dx >= 286 &&
          details.globalPosition.dx < 340) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      } else if (details.globalPosition.dx >= 383 &&
          details.globalPosition.dx < 417) {
        if (currentIconFocus != 7) {
          handleWhenDragBetweenIcon(7);
        }
      }
      showMoveLeftAndReset();
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

  void showMoveLeftAndReset() {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;
    onTapUpBtn(null);
    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    final boxHeight = _boxSizeAnimation.value?.height ?? 123;
    final topPosition =
        widget.buttonOffset.dy - widget.buttonSize.height - boxHeight;
    final bottomPosition = widget.buttonOffset.dy;

    if (dragUpdateDetail.globalPosition.dy >= topPosition - 75 &&
        dragUpdateDetail.globalPosition.dy <= bottomPosition + 46) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (dragUpdateDetail.globalPosition.dx >= 20 &&
          dragUpdateDetail.globalPosition.dx < 83) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 83 &&
          dragUpdateDetail.globalPosition.dx < 126) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 126 &&
          dragUpdateDetail.globalPosition.dx < 180) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 180 &&
          dragUpdateDetail.globalPosition.dx < 233) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 233 &&
          dragUpdateDetail.globalPosition.dx < 286) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 286 &&
          dragUpdateDetail.globalPosition.dx < 340) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 383 &&
          dragUpdateDetail.globalPosition.dx < 417) {
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

  void handleWhenDragBetweenIcon(int currentIcon) {
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  void onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = Timer(durationLongPress, showBox);
  }

  void onTapUpBtn(TapUpDetails? tapUpDetail) {
    if (isLongPress) {
      if (whichIconUserChoose == 0) {
        // playSound('box_down.mp3');
      } else {
        // playSound('icon_choose.mp3');
      }
    }
    Timer(Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });
    holdTimer!.cancel();
    animControlBtnLongPress.reverse();
    setReverseValue();
    animControlBox.reverse();
  }

  // when user short press the button
  void onTapBtn() {
    if (!isLongPress) {
      if (whichIconUserChoose == 0) {
        isLiked = !isLiked;
      } else {
        whichIconUserChoose = 0;
      }
      if (isLiked) {
        animControlBtnShortPress.forward();
      } else {
        animControlBtnShortPress.reverse();
      }
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

  double handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  void showBox() {
    isLongPress = true;
    animControlBtnLongPress.forward();
    setForwardValue();
    animControlBox.forward();
  }

  // We need to set the value for reverse because if not
  // the angry-icon will be pulled down first, not the like-icon
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

  // When set the reverse value, we need set value to normal for the forward
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

  Future loadAsset(String nameSound) async {
    return await rootBundle.load('sounds/$nameSound');
  }
}
