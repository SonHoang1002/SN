import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ButtonPrimary extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final Function? handlePress;
  final bool? isPrimary;
  final bool? isGrey;
  final EdgeInsetsGeometry? padding;
  final Color? colorButton;
  final Color? colorText;
  final double? fontSize;

  const ButtonPrimary(
      {Key? key,
      this.label,
      this.handlePress,
      this.icon,
      this.isPrimary,
      this.padding,
      this.colorButton,
      this.colorText,
      this.isGrey,
      this.fontSize = 14})
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
          backgroundColor: colorButton ??
              (isGrey == true
                  ? greyColorOutlined
                  : ![null, false].contains(isPrimary)
                      ? primaryColor
                      : secondaryColor),
          elevation: 0),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            SizedBox(
              width: icon != null && label != null ? 6 : 0,
            ),
            label != null
                ? Text(
                    label!,
                    style: TextStyle(
                        color: colorText ??
                            (isGrey == true
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : handlePress != null
                                    ? white
                                    : null),
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
