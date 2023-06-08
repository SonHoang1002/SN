import 'package:social_network_app_mobile/widgets/PickImageVideo/icons/custom_icons.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/drishya_picker.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/camera/src/widgets/camera_builder.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/camera/src/widgets/ui_handler.dart';
import 'package:flutter/material.dart';

///
class CameraCloseButton extends StatelessWidget {
  ///
  const CameraCloseButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  ///
  final CamController controller;

  @override
  Widget build(BuildContext context) {
    return CameraBuilder(
      controller: controller,
      builder: (value, child) {
        if (value.hideCameraCloseButton) {
          return const SizedBox();
        }
        return child!;
      },
      child: InkWell(
        onTap: UIHandler.of(context).pop,
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
    );
  }
}
