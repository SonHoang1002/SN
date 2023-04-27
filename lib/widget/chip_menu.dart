import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ChipMenu extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Widget? icon;
  final Widget? endIcon;

  const ChipMenu(
      {Key? key,
      this.icon,
      required this.isSelected,
      required this.label,
      this.endIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? primaryColor
              : Theme.of(context).colorScheme.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon ?? const SizedBox(),
          const SizedBox(
            width: 6.0,
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? white : null),
          ),
          const SizedBox(
            width: 6.0,
          ),
          endIcon ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
