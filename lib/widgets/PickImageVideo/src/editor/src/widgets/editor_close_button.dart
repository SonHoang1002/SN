import 'dart:async';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/icons/custom_icons.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/drishya_picker.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/animations/animations.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/camera/src/widgets/ui_handler.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/editor/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

///
class EditorCloseButton extends StatelessWidget {
  ///
  const EditorCloseButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  ///
  final DrishyaEditingController controller;

  Future<bool> _onPressed(BuildContext context, {bool pop = true}) async {
    if (!controller.value.hasStickers) {
      if (pop) {
        UIHandler.of(context).pop();
      }
      //  else {
      //   await UIHandler.showStatusBar();
      // }
      return true;
    } else {
      await showDialog<bool>(
        context: context,
        builder: (context) => const _AppDialog(),
      ).then((value) {
        if (value ?? false) {
          controller.clear();
        }
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onPressed(context, pop: false),
      child: EditorBuilder(
        controller: controller,
        builder: (context, value, child) {
          final crossFadeState = value.isEditing || value.hasFocus
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond;
          return AppAnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: child!,
            crossFadeState: crossFadeState,
          );
        },
        child: InkWell(
          onTap: () {
            _onPressed(context);
          },
          child: Container(
            height: 36,
            width: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black26,
            ),
            child: const Icon(
              CustomIcons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _AppDialog extends StatelessWidget {
  const _AppDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cancel = TextButton(
      onPressed: Navigator.of(context).pop,
      child: const Text(
        'Giữ lại',
        style: TextStyle(color: secondaryColor),
      ),
    );
    final unselectItems = TextButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      child: const Text(
        'Hủy bỏ',
        style: TextStyle(color: primaryColor),
      ),
    );

    return AlertDialog(
      title: const Text(
        'Hủy thay đổi?',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      content: const Text(
        'Bạn chắc chắn muốn hủy bỏ các thay đổi?',
        style: TextStyle(fontSize: 13),
      ),
      actions: [cancel, unselectItems],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
    );
  }
}
