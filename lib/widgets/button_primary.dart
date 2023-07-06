import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

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
  final Color? colorBorder;
  final MainAxisSize? min;
  final MaterialStateProperty<Size?>? minimumSize;
  final MaterialStateProperty<EdgeInsetsGeometry?>? paddingButton;
  const ButtonPrimary(
      {Key? key,
      this.label,
      this.handlePress,
      this.icon,
      this.isPrimary,
      this.padding,
      this.colorButton,
      this.colorText,
      this.colorBorder,
      this.min,
      this.paddingButton,
      this.isGrey,
      this.minimumSize,
      this.fontSize = 14})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return ElevatedButton(
      onPressed: handlePress != null
          ? () {
              handlePress!();
            }
          : null,
      style: ButtonStyle(
        minimumSize: minimumSize,
        padding: paddingButton,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              width: 1.0,
              color: colorBorder != null ? colorBorder! : Colors.transparent,
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          colorButton ??
              (isGrey == true
                  ? theme.isDarkMode
                      ? const Color(0xFF525252)
                      : greyColorOutlined
                  : ![null, false].contains(isPrimary)
                      ? primaryColor
                      : secondaryColor),
        ),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: min ?? MainAxisSize.max,
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
