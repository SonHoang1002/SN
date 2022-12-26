import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextAction extends StatelessWidget {
  final dynamic icon;
  final dynamic title;
  final dynamic action;
  const TextAction({
    super.key,
    this.icon,
    this.action,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: icon ??
          Text(
            title,
            style: const TextStyle(
                color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
          ),
      onTap: () {
        action();
      },
    );
  }
}
