import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Partially visible bottom sheet that can be dragged into the screen. Provides different views for expanded and collapsed states
class CustomDraggableBottomSheet extends StatefulWidget {
  /// Alignment of the sheet. Default Alignment.bottomCenter
  final Alignment alignment;

  /// Widget above which draggable sheet will be placed.
  final Widget backgroundWidget;

  /// Color of the modal barrier. Default Colors.black54
  final Color barrierColor;

  /// Whether tapping on the barrier will dismiss the dialog. Default true.
  /// If false, draggable bottom sheet will act as persistent sheet
  final bool barrierDismissible;

  /// Whether the sheet is collapsed initially. Default true.
  final bool collapsed;

  /// Sheet expansion animation curve. Default Curves.linear
  final Curve curve;

  /// Duration for sheet expansion animation. Default Duration(milliseconds: 0)
  final Duration duration;

  /// Widget to show on expended sheet
  final Widget expandedWidget;

  /// Widget to show on expended sheet
  // final Widget endWidget;

  /// Increment [expansionExtent] on [minExtent] to change from [previewWidget] to [expandedWidget]
  final double expansionExtent;

  /// Maximum extent for sheet expansion
  final double maxExtent;

  /// Minimum extent for the sheet
  final double minExtent;

  /// Callback function when sheet is being dragged
  /// pass current extent (position) as an argument
  final Function(double) onDragging;

  /// Widget to show on collapsed sheet
  final Widget previewWidget;

  /// indicate if the dialog should only display in 'safe' areas of the screen. Default true
  final bool useSafeArea;

  /// end extent for the sheet
  // final double endExtent;

  final Function? onClose;

  const CustomDraggableBottomSheet({
    Key? key,
    required this.previewWidget,
    required this.backgroundWidget,
    required this.expandedWidget,
    // required this.endWidget,
    required this.onDragging,
    this.minExtent = 50.0,
    this.collapsed = true,
    this.useSafeArea = true,
    // this.endExtent = 30.0,
    this.curve = Curves.linear,
    this.expansionExtent = 10.0,
    this.barrierDismissible = true,
    this.maxExtent = double.infinity,
    this.barrierColor = Colors.black26,
    this.alignment = Alignment.bottomCenter,
    this.onClose,
    this.duration = const Duration(milliseconds: 0),
  })  : assert(minExtent > 0.0),
        assert(expansionExtent > 0.0),
        assert(minExtent + expansionExtent < maxExtent),
        super(key: key);

  @override
  CustomDraggableBottomSheetState createState() =>
      CustomDraggableBottomSheetState();
}

class CustomDraggableBottomSheetState
    extends State<CustomDraggableBottomSheet> {
  double _currentExtent = 0.0;
  bool? isDragToTop;
  int step = 0;
  @override
  void initState() {
    super.initState();
    _currentExtent = widget.collapsed ? widget.minExtent : widget.maxExtent;
  }

  @override
  Widget build(BuildContext context) {
    return widget.useSafeArea ? SafeArea(child: _body()) : _body();
  }

  /// body content
  Widget _body() {
    return Stack(
      children: [
        // background widget
        widget.backgroundWidget,
        // barrier
        _barrier(),
        Align(alignment: widget.alignment, child: _sheet()),
      ],
    );
  }

  /// barrier film between sheet & background widget
  Widget _barrier() {
    return _currentExtent.roundToDouble() >= widget.maxExtent - 10
        ? Positioned.fill(
            child: GestureDetector(
            onTap: widget.barrierDismissible
                ? () {
                    setState(() {
                      _currentExtent = widget.minExtent;
                    });
                  }
                : null,
            child: Container(color: widget.barrierColor),
          ))
        : _currentExtent == widget.minExtent
            ? GestureDetector(
                onTap: widget.barrierDismissible
                    ? () {
                        setState(() {
                          _currentExtent = _currentExtent - 10;
                        });
                        widget.onClose != null ? widget.onClose!() : null;
                      }
                    : null,
              )
            : const SizedBox();
  }

  /// draggable bottom sheet
  Widget _sheet() {
    return _currentExtent > 1
        ? GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: (details) {
              _onVerticalDragEnd(details);
            },
            child: AnimatedContainer(
                curve: widget.curve,
                duration: widget.duration,
                width: _axis() == Axis.horizontal ? _currentExtent : null,
                height: _axis() == Axis.horizontal ? null : _currentExtent,
                child:
                    _currentExtent >= widget.minExtent + widget.expansionExtent
                        ? widget.expandedWidget
                        // : _currentExtent <= widget.endExtent
                        //     ? widget.endWidget
                        : widget.previewWidget),
          )
        : const SizedBox();
  }

  /// determine scroll direction based on CustomDraggableBottomSheetPosition
  Axis _axis() {
    if (widget.alignment == Alignment.topLeft ||
        widget.alignment == Alignment.topRight ||
        widget.alignment == Alignment.topCenter ||
        widget.alignment == Alignment.bottomLeft ||
        widget.alignment == Alignment.bottomRight ||
        widget.alignment == Alignment.bottomCenter) {
      return Axis.vertical;
    }

    return Axis.horizontal;
  }

  /// callback function when sheet is dragged horizontally
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_axis() == Axis.vertical) return;
    // delta dx is positive when dragged towards right &
    // negative when dragged towards left
    final newExtent = (_currentExtent + details.delta.dx).roundToDouble();
    if (newExtent >= widget.minExtent && newExtent <= widget.maxExtent) {
      setState(() => _currentExtent = newExtent);
      widget.onDragging(_currentExtent);
    }
  }

  /// callback function when sheet is dragged vertically
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_axis() == Axis.horizontal) return;
    if (details.primaryDelta! > 0) {
      setState(() {
        isDragToTop = false;
      });
    } else if (details.primaryDelta! < 0) {
      setState(() {
        isDragToTop = true;
      });
    } else {
      setState(() {
        isDragToTop = null;
      });
    }
    setState(() =>
        _currentExtent = (_currentExtent - details.delta.dy).roundToDouble());
  }

  void _onVerticalDragEnd(dynamic details) {
    if (_axis() == Axis.horizontal) return;
    if (isDragToTop == true) {
      if (_currentExtent > widget.minExtent) {
        setState(() {
          _currentExtent = widget.maxExtent;
        });
      }
    } else if (isDragToTop == false) {
      if (_currentExtent < widget.maxExtent) {
        if (_currentExtent < widget.minExtent) {
          setState(() {
            _currentExtent = 0;
          });
          widget.onClose != null ? widget.onClose!() : null;
        } else {
          setState(() {
            _currentExtent = widget.minExtent;
          });
        }
      }
    } else {
      if (_currentExtent > widget.minExtent &&
          _currentExtent <
              ((widget.maxExtent + widget.minExtent) / 2 + widget.minExtent)) {
        setState(() {
          _currentExtent = widget.minExtent;
        });
      } else if (_currentExtent < widget.maxExtent &&
          _currentExtent >
              ((widget.maxExtent + widget.minExtent) / 2 + widget.minExtent)) {
        setState(() {
          _currentExtent = widget.maxExtent;
        });
      }
    }

    // kiểm tra người dùng kéo quá mạnh hoặc nhanh thì hãm lại 1 bậc
    // if (_currentExtent > widget.minExtent) {
    //   if (_currentExtent >
    //       ((widget.maxExtent - widget.minExtent) / 2 + widget.minExtent)) {
    //     setState(() {
    //       _currentExtent = widget.maxExtent;
    //     });
    //   } else {
    //     setState(() {
    //       _currentExtent = widget.minExtent;
    //     });
    //   }
    // } else if (_currentExtent < widget.minExtent) {
    //   setState(() {
    //     _currentExtent = 0.0;
    //   });
    //   widget.onClose != null ? widget.onClose!() : null;
    // } else {}
  }
}
