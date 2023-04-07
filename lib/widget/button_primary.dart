import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ButtonPrimary extends StatelessWidget {
  final String label;
  final Icon? icon;
  final Function? handlePress;
  final bool? isPrimary;
  final bool? isGrey;
  final EdgeInsetsGeometry? padding;
  final Color? colorButton;
  final Color? colorText;

  const ButtonPrimary(
      {Key? key,
      required this.label,
      this.handlePress,
      this.icon,
      this.isPrimary,
      this.padding,
      this.colorButton,
      this.colorText,
      this.isGrey})
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
              width: icon != null ? 6 : 0,
            ),
            Text(
              label,
              style: TextStyle(
                  color: colorText ??
                      (isGrey == true
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : handlePress != null
                              ? white
                              : null),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
