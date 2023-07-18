import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

class CrossBar extends StatelessWidget {
  final double? height;
  final double? margin;
  final double? onlyBottom;
  final double? onlyTop;
  final double? onlyRight;
  final double? onlyLeft;
  final double? opacity;
  const CrossBar(
      {Key? key,
      this.height,
      this.margin,
      this.onlyBottom,
      this.onlyTop,
      this.onlyLeft,
      this.onlyRight,this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeManager>(context).isDarkMode;
    return Container(
      height: height ?? 2,
      margin: EdgeInsets.only(
          top: margin ?? (onlyTop ?? 10),
          bottom: margin ?? (onlyBottom ?? 10),
          right: onlyRight ?? 0,
          left: onlyLeft ?? 0),
      color: isDarkMode
          ? MyThemes.darkTheme.canvasColor
          : Colors.grey.withOpacity(opacity??0.5),
    );
  }
}
