import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

class CrossBar extends StatelessWidget {
  final double? height;
  final double? margin;
  const CrossBar({Key? key, this.height, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeManager>(context).isDarkMode;
    return Container(
      height: height ?? 2,
      margin: EdgeInsets.only(top: margin ?? 10, bottom: margin ?? 10),
      color: isDarkMode
          ? MyThemes.darkTheme.canvasColor
          : Colors.grey.withOpacity(0.5),
    );
  }
}
