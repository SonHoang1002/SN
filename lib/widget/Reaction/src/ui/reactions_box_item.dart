// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:social_network_app_mobile/theme/colors.dart';
// import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

// import '../models/drag.dart';
// import '../models/reaction.dart';
// import '../utils/extensions.dart';

// class ReactionsBoxItem extends StatefulWidget {
//   final ValueChanged<Reaction?> onReactionSelected;

//   final Reaction reaction;

//   final double scale;

//   final Duration? scaleDuration;

//   final Stream<DragData?> dragStream;

//   const ReactionsBoxItem({
//     Key? key,
//     required this.reaction,
//     required this.onReactionSelected,
//     required this.scale,
//     this.scaleDuration,
//     required this.dragStream,
//   }) : super(key: key);

//   @override
//   State<ReactionsBoxItem> createState() => _ReactionsBoxItemState();
// }

// class _ReactionsBoxItemState extends State<ReactionsBoxItem>
//     with TickerProviderStateMixin {
//   final GlobalKey _widgetKey = GlobalKey();

//   late AnimationController _scaleController;

//   late Tween<double> _scaleTween;

//   late Animation<double> _scaleAnimation;

//   Size? _widgetSize;

//   void _onSelected() {
//     _scaleController.reverse();
//     widget.onReactionSelected.call(widget.reaction);
//   }

//   bool _isWidgetHovered(DragData? dragData) {
//     final widgetRect = _widgetKey.widgetPositionRect;

//     _widgetSize ??= _widgetKey.widgetSize;

//     return (widgetRect?.contains(dragData!.offset) ?? false) ||
//         (widgetRect
//                 ?.shift(Offset(0, _widgetSize!.height))
//                 .contains(dragData!.offset) ??
//             false) ||
//         (widgetRect
//                 ?.shift(Offset(0, -_widgetSize!.height))
//                 .contains(dragData!.offset) ??
//             false);
//   }

//   @override
//   void initState() {
//     super.initState();

//     _scaleController = AnimationController(
//       vsync: this,
//       duration: widget.scaleDuration ?? const Duration(milliseconds: 100),
//     );

//     _scaleTween = Tween(
//       begin: 1,
//       end: widget.scale,
//     );

//     _scaleAnimation = _scaleTween.animate(_scaleController);
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       ignoring: !widget.reaction.enabled,
//       child: StreamBuilder<DragData?>(
//         stream: widget.dragStream,
//         builder: (_, snapshot) {
//           bool isHovered = false;
//           if (snapshot.hasData) {
//             final dragData = snapshot.data;
//             isHovered = _isWidgetHovered(dragData);
//             if (isHovered) {
//               bool isSelected = snapshot.data?.isDragEnd ?? false;
//               if (isSelected) {
//                 _onSelected();
//               } else {
//                 _scaleController.forward();
//               }
//             } else {
//               _scaleController.reverse();
//             }
//           }

//           return FittedBox(
//             key: _widgetKey,
//             fit: BoxFit.scaleDown,
//             child: AnimatedBuilder(
//               animation: _scaleAnimation,
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: widget.reaction.previewIcon,
//               ),
//               builder: (_, child) {
//                 return Transform.scale(
//                   scale: _scaleAnimation.value,
//                   child: AnimatedContainer(
//                     width: _widgetSize != null
//                         ? _widgetSize!.width * _scaleAnimation.value
//                         : null,
//                     duration: const Duration(milliseconds: 250),
//                     child: Column(
//                       children: [
//                         AnimatedOpacity(
//                           duration: const Duration(milliseconds: 50),
//                           opacity: isHovered ? 1 : 0,
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             child: widget.reaction.title,
//                           ),
//                         ),
//                         isHovered
//                             ? Container(
//                                 width: 40,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 3, vertical: 3),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.black.withOpacity(0.4)),
//                                 child: buildTextContent("hello", false,
//                                     fontSize: 9,
//                                     colorWord: Colors.white,
//                                     isCenterLeft: false))
//                             : const SizedBox(),
//                         Container(color: red, child: child!),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';

class ReactionsBoxItem extends StatefulWidget {
  final ValueChanged<Reaction?> onReactionSelected;

  final Reaction reaction;

  final double scale;

  final Duration? scaleDuration;

  final Stream<DragData?> dragStream;

  final Function? onHoverReaction;
  final Function? onSelectedReaction;

  const ReactionsBoxItem(
      {Key? key,
      required this.reaction,
      required this.onReactionSelected,
      required this.scale,
      this.scaleDuration,
      required this.dragStream,
      this.onHoverReaction,
      this.onSelectedReaction})
      : super(key: key);

  @override
  State<ReactionsBoxItem> createState() => _ReactionsBoxItemState();
}

class _ReactionsBoxItemState extends State<ReactionsBoxItem>
    with TickerProviderStateMixin {
  final GlobalKey _widgetKey = GlobalKey();

  late AnimationController _scaleController;

  late Tween<double> _scaleTween;

  late Animation<double> _scaleAnimation;

  Size? _widgetSize;

  void _onSelected() {
    _scaleController.reverse();
    widget.onReactionSelected.call(widget.reaction);
  }

  bool _isWidgetHovered(DragData? dragData) {
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
      duration: widget.scaleDuration ?? const Duration(milliseconds: 100),
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
          if (snapshot.hasData) {
            final dragData = snapshot.data;
            isHovered = _isWidgetHovered(dragData);
            if (isHovered) {
              bool isSelected = snapshot.data?.isDragEnd ?? false;
              if (isSelected) {
                _onSelected();
              } else {
                _scaleController.forward();
              }
            } else {
              _scaleController.reverse();
            }
          }

          return FittedBox(
            key: _widgetKey,
            fit: BoxFit.scaleDown,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: widget.reaction.previewIcon,
              ),
              builder: (_, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: AnimatedContainer(
                    width: _widgetSize != null
                        ? _widgetSize!.width * _scaleAnimation.value
                        : null,
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 50),
                          opacity: isHovered ? 1 : 0,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
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
                                    color: Colors.black.withOpacity(0.4)),
                                child: buildTextContent("hello", false,
                                    fontSize: 9,
                                    colorWord: Colors.white,
                                    isCenterLeft: false))
                            : const SizedBox(),
                        child!,
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
