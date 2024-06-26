import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

Widget buildMarketButton(
    {List<Widget>? contents,
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
    bool? isVertical = false,
    double? radiusValue,
    bool? isHaveBoder = false}) {
  return InkWell(
    onTap: () {
      function != null ? function() : null;
    },
    child: Container(
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
              fixedSize: Size(width!, height!),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              backgroundColor: bgColor),
          onPressed: () {
            function != null ? function() : null;
          },
          child: isVertical!
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: contents!,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: contents!,
                )),
    ),
  );
}
