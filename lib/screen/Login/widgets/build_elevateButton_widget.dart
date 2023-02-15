import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';

Widget buildElevateButtonWidget(
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
    bool? isHaveBoder = false}) {
  return Container(
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
            shadowColor: Colors.transparent,
            fixedSize: Size(width!, 40),
            backgroundColor: bgColor),
        onPressed: () {
          function != null ? function() : null;
        },
        child: buildTextContent(title!, true,
            fontSize: 17, colorWord: colorText, isCenterLeft: false)),
  );
}
