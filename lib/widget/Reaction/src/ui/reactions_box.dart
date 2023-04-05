import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/posts/reaction_message_content.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box_item.dart';
import 'widget_size_render_object.dart';

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
      this.duration = const Duration(milliseconds: 1000),
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

  @override
  void initState() {
    super.initState();

    // Calculating how much we should scale up when item hovered
    _itemScale = 1.0 + widget.itemScale;

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
  }

  @override
  void dispose() {
    _boxSizeController.dispose();
    _scaleController.dispose();
    _dragStreamController.close();
    super.dispose();
  }

  bool? isHaveFocus;

  @override
  Widget build(BuildContext context) { 
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Listener(
              onPointerDown: (_) {
                _scaleController.reverse();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          PositionedDirectional(
            top: _getVerticalPosition(),
            start: _getHorizontalPosition(),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 13, bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: greyColor[200],
                  ),
                  height: isHaveFocus == true ? 45 : 50,
                  width: MediaQuery.of(context).size.width * 0.92,
                ),
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: AnimatedBuilder(
                    animation: _boxSizeAnimation,
                    child: _buildItems(),
                    builder: (_, child) {
                      return SizedBox(
                        height: _boxSizeAnimation.value?.height,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Material(
                              color: transparent,
                              // elevation: widget.elevation,
                              // clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widget.radius),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: _getBoxHeight(),
                                    width: 120,
                                  ),
                                ],
                              ),
                            ),
                            child!,
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return WidgetSizeOffsetWrapper(
      onSizeChange: (Size size) {
        _boxSizeTween
          ..begin = size
          ..end = size;
        if (_boxSizeController.isCompleted) {
          _boxSizeController.reverse();
        } else {
          _boxSizeController.forward();
        }
      },
      child: Padding(
        padding: widget.boxPadding,
        child: Listener(
          onPointerDown: (point) {
            _dragData = DragData(offset: point.position);
            _dragStreamController.add(_dragData);
            setState(() {
              isHaveFocus = true;
            });
            // ref.read(commentMessageContentProvider.notifier).setCommentMessage(
            //     "onPointerDown ${ref.watch(commentMessageStatusProvider).status} Buông để chọn");
          },
          onPointerMove: (point) {
            _dragData = DragData(offset: point.position);
            _dragStreamController.add(_dragData);
            // ref.read(commentMessageContentProvider.notifier).setCommentMessage(
            //     "onPointerMove ${ref.watch(commentMessageStatusProvider).status} Buông để chọn");
            setState(() {
              isHaveFocus = true;
            });
          },
          onPointerUp: (point) {
            _dragData = _dragData?.copyWith(isDragEnd: true);
            _dragStreamController.add(_dragData);
            setState(() {
              isHaveFocus = false;
            });
            //  if (!ref
            //       .watch(commentMessageStatusProvider1)
            //       .listStatus
            //       .contains(true)) {
            //     ref
            //         .read(commentMessageContentProvider.notifier)
            //         .setCommentMessage("");
             //         "ref.watch ${ref.watch(commentMessageStatusProvider).status}");
            //     ref.read(commentMessageContentProvider.notifier).setCommentMessage(
            //         "onPointerUp ${ref.watch(commentMessageStatusProvider).status} Nhấn để chọn cảm xúc");
            //   }
          },
          onPointerCancel: (point) {
            _dragData = _dragData?.copyWith(isDragEnd: true);
            _dragStreamController.add(_dragData);
            setState(() {
              isHaveFocus = false;
            });
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.92,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < widget.reactions.length; i++) ...[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.92 / 7,
                    alignment: Alignment.bottomCenter,
                    child: ReactionsBoxItem(
                      index: i,
                      onReactionSelected: (reaction) {
                        _selectedReaction = reaction;
                        _scaleController.reverse();
                      },
                      isHaveFocus: isHaveFocus,
                      scale: _itemScale,
                      title: getTitle(i),
                      scaleDuration: widget.itemScaleDuration,
                      reaction: widget.reactions[i]!,
                      dragStream: _dragStream,
                    ),
                  ),
                  if (i < widget.reactions.length - 1) ...{
                    SizedBox(
                      width: widget.reactionSpacing,
                    ),
                  },
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(int index) {
    String title = 'Thích';
    switch (index) {
      case 0:
        title = "Thích";
        break;
      case 1:
        title = "Yêu thích";
        break;
      case 2:
        title = "Tự hào";
        break;
      case 3:
        title = "Wow";
        break;
      case 4:
        title = "Haha";
        break;
      case 5:
        title = "Buồn";
        break;
      case 6:
        title = "Phẫn nộ";
        break;
      default:
    }
    return title;
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
    return value + xOffset;
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
}
