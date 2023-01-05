import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ButtonPrimary extends StatelessWidget {
  final String label;
  final Icon? icon;
  final Function? handlePress;

  const ButtonPrimary(
      {Key? key, required this.label, this.handlePress, this.icon})
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon ?? const SizedBox(),
          SizedBox(
            width: icon != null ? 8 : 0,
          ),
          Text(label),
        ],
      ),
    );
  }
}
