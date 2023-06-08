import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';

class ReactionsBoxItem extends ConsumerStatefulWidget {
  final ValueChanged<Reaction?> onReactionSelected;
  final int index;
  final Reaction reaction;

  final double scale;

  final Duration? scaleDuration;

  final Stream<DragData?> dragStream;

  final Function? onHoverReaction;
  final Function? onSelectedReaction;
  final String title;
  final bool? isHaveFocus;
  const ReactionsBoxItem(
      {Key? key,
      required this.index,
      required this.reaction,
      required this.onReactionSelected,
      required this.scale,
      required this.title,
      this.scaleDuration,
      required this.dragStream,
      this.onHoverReaction,
      this.isHaveFocus,
      this.onSelectedReaction})
      : super(key: key);

  @override
  ConsumerState<ReactionsBoxItem> createState() => _ReactionsBoxItemState();
}

class _ReactionsBoxItemState extends ConsumerState<ReactionsBoxItem>
    with TickerProviderStateMixin {
  final GlobalKey _widgetKey = GlobalKey();

  late AnimationController _scaleController;

  late Tween<double> _scaleTween;

  late Animation<double> _scaleAnimation;

  Size? _widgetSize;

  Future _onSelected() async {
    _scaleController.reverse();
    widget.onReactionSelected.call(widget.reaction);
  }

  Future _onHovered() async {
    await _scaleController.forward();
  }

  bool _isWidgetHovered(DragData? dragData) {
    // size: Size(392.7, 802.9)
    final widgetRect = _widgetKey.widgetPositionRect;
    _widgetSize ??= _widgetKey.widgetSize;
    return (widgetRect?.contains(dragData!.offset) ?? false) ||
        (widgetRect
                ?.shift(Offset(0, _widgetSize!.height))
                .contains(dragData!.offset) ??
            false) ||
        (widgetRect
                ?.shift(Offset(0, -_widgetSize!.height))
                .contains(dragData!.offset) ??
            false);
  }

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleTween = Tween(
      begin: 1,
      end: widget.scale,
    );

    _scaleAnimation = _scaleTween.animate(_scaleController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.reaction.enabled,
      child: StreamBuilder<DragData?>(
        stream: widget.dragStream,
        builder: (_, snapshot) {
          bool isHovered = false;
          bool? isHaveFocus;
          if (snapshot.hasData) {
            final dragData = snapshot.data;
            isHovered = _isWidgetHovered(dragData);
            if (isHovered) {
              bool isSelected = snapshot.data?.isDragEnd ?? false;
              isHaveFocus ??= true;
              if (isSelected) {
                // ref
                //     .read(commentMessageStatusProvider1.notifier)
                //     .setCommentMessageStatus(widget.index, isSelected);
                _onSelected();
              } else {
                _onHovered();
              }
            } else {
              _scaleController.reverse();
              isHaveFocus = false;
            }
          }
          // if (isHovered) {
          //   if (widget.isHaveFocus == true) {
          //     ref
          //         .read(commentMessageContentProvider.notifier)
          //         .setCommentMessage(
          //             "widget.isHaveFocus == true Trượt để chọn cảm xúc");
          //   } else {
          //     ref
          //         .read(commentMessageContentProvider.notifier)
          //         .setCommentMessage("Trượt để chọn cảm xúc");
          //   }
          // }
          return FittedBox(
            alignment: Alignment.bottomCenter,
            key: _widgetKey,
            fit: BoxFit.none,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              child: FittedBox(
                fit: BoxFit.none,
                child: widget.reaction.previewIcon,
              ),
              builder: (_, child) {
                return Transform.scale(
                  alignment: Alignment.bottomCenter,
                  scale: isHovered
                      ? _scaleAnimation.value
                      : widget.isHaveFocus == true
                          ? 0.9
                          : 1,
                  child: AnimatedContainer(
                    width: _widgetSize != null
                        ? _widgetSize!.width * _scaleAnimation.value
                        : null,
                    duration: const Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 50),
                          opacity: isHovered ? 1 : 0,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: widget.reaction.title,
                          ),
                        ),
                        isHovered
                            ? Container(
                                width: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.2)),
                                child: buildTextContent(widget.title, false,
                                    fontSize: 9,
                                    colorWord: Colors.white,
                                    isCenterLeft: false))
                            : const SizedBox(),
                        Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    //    isHovered
                                    //       ? 10
                                    //       : widget.isHaveFocus == true &&
                                    //               widget.reaction.needBottomPadding
                                    //           ? 8
                                    //           : 0,
                                    // ),
                                    widget.isHaveFocus == true ? 10 : 0),
                            child: child!)
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
