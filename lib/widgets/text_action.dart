import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextAction extends StatelessWidget {
  final dynamic icon;
  final dynamic title;
  final Function? action;
  final double? fontSize;
  const TextAction({
    super.key,
    this.icon,
    this.action,
    this.title,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: icon ??
          Text(
            title,
            style: TextStyle(
                color: primaryColor,
                fontSize: fontSize ?? 13,
                fontWeight: FontWeight.w500),
          ),
      onTap: () {
        if (action != null) {
          action!();
        }
      },
    );
  }
}
