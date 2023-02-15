import 'package:flutter/material.dart';

import '../../../animations/animations.dart';
import '../../editor.dart';
import 'widgets.dart';

///
class EditorTextfieldButton extends StatelessWidget {
  ///
  const EditorTextfieldButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  ///
  final DrishyaEditingController controller;

  @override
  Widget build(BuildContext context) {
    return EditorBuilder(
      controller: controller,
      builder: (context, value, child) {
        final crossFadeState =
            value.hasStickers || value.hasFocus || value.isEditing
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond;
        return AppAnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: child!,
          crossFadeState: crossFadeState,
        );
      },
      child: GestureDetector(
        onTap: () {
          controller.updateValue(hasFocus: true);
        },
        child: const Text(
          'Tap to type...',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
