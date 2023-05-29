import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:market_place/theme/theme_manager.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

Widget buildCategoryProductItem(
    BuildContext context, String title, String imgPath,
    {double? titleSize = 13,
    double height = 100,
    double? width,
    Function? function}) {
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
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Column(
        children: [
          Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(imgPath))),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
                child: buildTextContent(title, true,
                    fontSize: titleSize, isCenterLeft: false)),
          )
        ],
      ),
    ),
  );
}
