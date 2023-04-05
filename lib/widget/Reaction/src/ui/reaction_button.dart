import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import '../../../../providers/posts/reaction_message_content.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box.dart';

typedef OnReactionChanged<T> = void Function(T?);

class ReactionButton<T> extends ConsumerStatefulWidget {
  /// This triggers when reaction button value changed.
  final OnReactionChanged<T> onReactionChanged;

  /// Default reaction button widget
  final Reaction<T>? initialReaction;

  final List<Reaction<T>> reactions;
  

  /// Offset to add to the placement of the box
  final Offset boxOffset;

  /// Vertical position of the reactions box relative to the button [default = VerticalPosition.TOP]
  final VerticalPosition boxPosition;

  /// Horizontal position of the reactions box relative to the button [default = HorizontalPosition.START]
  final HorizontalPosition boxHorizontalPosition;

  /// Reactions box color [default = white]
  final Color boxColor;

  /// Reactions box elevation [default = 5]
  final double boxElevation;

  /// Reactions box radius [default = 50]
  final double boxRadius;

  /// Reactions box show/hide duration [default = 200 milliseconds]
  final Duration boxDuration;

  /// Change initial reaction after selected one [default = true]
  final bool shouldChangeReaction;

  /// Reactions box padding [default = EdgeInsets.zero]
  final EdgeInsetsGeometry boxPadding;

  /// Spacing between the reaction icons in the box
  final double boxReactionSpacing;

  /// Scale ratio when item hovered [default = 0.3]
  final double itemScale;

  /// Scale duration while dragging [default = const Duration(milliseconds: 100)]
  final Duration? itemScaleDuration;

  final Function? handlePressButton;

  final Function? onWaitingReaction;

  final Function? onIconFocus;

  final Function? onHoverReaction;

  const ReactionButton(
      {Key? key,
      required this.onReactionChanged,
      required this.reactions,
      this.initialReaction,
      this.boxOffset = Offset.zero,
      this.boxPosition = VerticalPosition.top,
      this.boxHorizontalPosition = HorizontalPosition.center,
      this.boxColor = Colors.white,
      this.boxElevation = 5,
      this.boxRadius = 50,
      this.boxDuration = const Duration(milliseconds: 200),
      this.shouldChangeReaction = true,
      this.boxPadding = EdgeInsets.zero,
      this.boxReactionSpacing = 0,
      this.itemScale = .3,
      this.itemScaleDuration,
      this.handlePressButton,
      this.onWaitingReaction,
      this.onIconFocus,
      this.onHoverReaction})
      : super(key: key);

  @override
  ConsumerState<ReactionButton<T>> createState() => _ReactionButtonState<T>();
}

class _ReactionButtonState<T> extends ConsumerState<ReactionButton<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  Reaction? _selectedReaction;
  Offset? offset;

  void _init() {
    _selectedReaction = widget.initialReaction;
  }

  @override
  void didUpdateWidget(ReactionButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      widget.onIconFocus != null ? widget.onIconFocus!() : null;
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        key: _buttonKey,
        behavior: HitTestBehavior.translucent,
        onTap: () {
          widget.handlePressButton!();
        },
        onLongPressStart: (details) {
          // ref
          //     .read(commentMessageStatusProvider1.notifier)
          //     .resetCommentMessageStatus();
          // ref
          //     .read(commentMessageContentProvider.notifier)
          //     .setCommentMessage("Trượt ngón tay để chọn");
          _showReactionsBox(details.globalPosition);
        },
        child: (_selectedReaction ?? widget.reactions.first).icon,
      );

  void _showReactionsBox(Offset buttonOffset) async {
    final buttonSize = _buttonKey.widgetSize;
    final reactionButton = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return ReactionsBox(
            buttonOffset: buttonOffset,
            buttonSize: buttonSize,
            reactions: widget.reactions,
            verticalPosition: widget.boxPosition,
            horizontalPosition: widget.boxHorizontalPosition,
            color: widget.boxColor,
            elevation: widget.boxElevation,
            radius: widget.boxRadius,
            offset: widget.boxOffset,
            duration: widget.boxDuration,
            boxPadding: widget.boxPadding,
            reactionSpacing: widget.boxReactionSpacing,
            itemScale: widget.itemScale,
            itemScaleDuration: widget.itemScaleDuration,
            onWaitingReaction: widget.onWaitingReaction,
            onIconFocus: widget.onIconFocus,
            onHoverReaction: widget.onHoverReaction,
          );
        },
      ),
    );

    if (reactionButton != null) _updateReaction(reactionButton);
  }

  void _updateReaction(Reaction<T> reaction) {
    widget.onReactionChanged.call(reaction.value);
    if (mounted && widget.shouldChangeReaction) {
      setState(() {
        _selectedReaction = reaction;
      });
    }
  }
}
