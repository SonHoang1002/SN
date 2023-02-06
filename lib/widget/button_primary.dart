import 'package:flutter/material.dart';

import '../theme/colors.dart';

class ButtonPrimary extends StatelessWidget {
  final String label;
  final Icon? icon;
  final Function? handlePress;
  final bool? isPrimary;
  final double? width;
  double? radius;

  ButtonPrimary(
      {Key? key,
      required this.label,
      this.handlePress,
      this.icon,
      this.isPrimary,
      this.width,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handlePress != null
          ? () {
              handlePress!();
            }
          : null,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ??6)),
          fixedSize: width != null ? Size(width!,50) : null,
          backgroundColor: ![null, false].contains(isPrimary)
              ? primaryColor
              : secondaryColor,
          elevation: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon ?? const SizedBox(),
          SizedBox(
            width: icon != null ? 6 : 0,
          ),
          Text(
            label,
            style: TextStyle(
                color: handlePress != null ? white : null, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
