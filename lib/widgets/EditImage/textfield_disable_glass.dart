import 'package:flutter/material.dart';

class CustomTextSelectionControls extends TextSelectionControls {
  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap]) {
    return Container();
  }

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset position,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier? clipboardStatus,
      Offset? offset) {
    // Trả về một widget rỗng để vô hiệu hóa kính lúp
    return Container();
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return Offset(0, 0);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return Size(0, 0);
  }
}
