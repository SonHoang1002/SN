import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ChipMenu extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Widget? icon;
  final Widget? endIcon;
  final double? width;
  final double? height;
  final AlignmentGeometry? Alignment;

  const ChipMenu(
      {Key? key,
      this.icon,
      required this.isSelected,
      required this.label,
      this.width,
      this.height,
      this.Alignment,
      this.endIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment,
      margin: endIcon != null
          ? const EdgeInsets.only(left: 3, right: 3)
          : const EdgeInsets.only(left: 6, right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? primaryColor
              : Theme.of(context).colorScheme.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const SizedBox(),
          const SizedBox(width: 6.0),
          Text(
            label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? white : null),
          ),
          const SizedBox(width: 6.0),
          endIcon ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
