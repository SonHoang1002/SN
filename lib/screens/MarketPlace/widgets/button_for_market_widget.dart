import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';

Widget buildButtonForMarketWidget(
    {String? title,
    Function? function,
    Color? bgColor = secondaryColor,
    Color? colorText = white,
    double? height = 40,
    double? marginTop = 10,
    double? marginBottom = 0,
    double? marginLeft = 0,
    double? marginRight = 0,
    double? width = 300,
    double? fontSize,
    IconData? iconData,
    bool? isVertical = false,
    double? radiusValue,
    bool? isHaveBoder = false}) {
  return InkWell(
    onTap: () {
      function != null ? function() : null;
    },
    child: Container(
      height: 40,
      decoration: isHaveBoder!
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(radiusValue ?? 5),
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
          child: isVertical!
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconData != null
                        ? Icon(
                            iconData,
                            size: 14,
                            color: Colors.white,
                          )
                        : const SizedBox(),
                    title != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: buildTextContent(title, true,
                                fontSize: fontSize ?? 17,
                                colorWord: colorText,
                                isCenterLeft: false),
                          )
                        : const SizedBox(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconData != null
                        ? Icon(
                            iconData,
                            size: 14,
                            color: Colors.white,
                          )
                        : const SizedBox(),
                    title != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: buildTextContent(title, true,
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
