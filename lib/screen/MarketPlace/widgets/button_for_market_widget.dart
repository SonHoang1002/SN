import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';

Widget  buildButtonForMarketWidget(
    {String? title = 'Tiếp tục',
    Function? function,
    Color? bgColor = secondaryColor,
    Color? colorText = white,
    double? height = 40,
    double? marginTop = 10,
    double? marginBottom = 0,
    double? marginLeft = 0,
    double? marginRight = 0,
    double? width = 300,
    IconData? iconData,
    bool? isHaveBoder = false}) {
  return InkWell(
    onTap: () {
      function != null ? function() : null;
    },
    child: Container(
      height: 40,
      decoration: isHaveBoder!
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 0.6, color: Colors.grey))
          : null,
      margin: EdgeInsets.only(
          top: marginTop!,
          bottom: marginBottom!,
          left: marginLeft!,
          right: marginRight!),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              shadowColor: transparent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              fixedSize: width != null ? Size(width, 40) : null,
              backgroundColor: bgColor),
          onPressed: () {
            function != null ? function() : null;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconData != null
                  ? Icon(
                      iconData,
                      size: 16,
                      color: Colors.white,
                    )
                  : const SizedBox(),
              title != null || title != "Tiếp tục"
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: buildTextContent(title!, true,
                          fontSize: 17,
                          colorWord: colorText,
                          isCenterLeft: false),
                    )
                  : const SizedBox(),
            ],
          )),
    ),
  );
}
