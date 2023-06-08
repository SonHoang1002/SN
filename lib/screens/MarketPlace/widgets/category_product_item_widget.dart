import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

Widget buildCategoryProductItemWidget(
    BuildContext context, String title, String imgPath,
    {double height = 100, double? width, Function? function}) {
  final theme = Provider.of<ThemeManager>(context);
  Color? colorTheme = theme.themeMode == ThemeMode.dark
      ? Theme.of(context).cardColor
      : const Color(0xfff1f2f5);
  return InkWell(
    onTap: () {
      function != null ? function() : null;
    },
    child: Container(
      height: height,
      width: width,
      // color: red,
      // color: colorTheme,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(7),
      //     border: Border.all(color: greyColor, width: 0.6)),
      child: Column(
        children: [
          Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(top: 10),
              // color: red,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(imgPath))),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
                child: buildTextContent(title, true,
                    fontSize: 13, isCenterLeft: false)),
          )
        ],
      ),
    ),
  );
}
