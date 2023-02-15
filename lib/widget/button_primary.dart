import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ButtonPrimary extends StatelessWidget {
  final String label;
  final Icon? icon;
  final Function? handlePress;
  final bool? isPrimary;

  const ButtonPrimary(
      {Key? key,
      required this.label,
      this.handlePress,
      this.icon,
      this.isPrimary})
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
