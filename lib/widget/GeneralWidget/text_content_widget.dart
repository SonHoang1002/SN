import 'package:flutter/material.dart';

Widget buildTextContent(String title, bool isBold,
    {Color? colorWord,
    double? fontSize,
    bool? isCenterLeft = true,
    int? maxLines,
    bool? isItalic = false,
    TextOverflow? overflow,
    IconData? iconData,
    FontWeight? fontWeight}) {
  return Container(
    alignment: isCenterLeft! ? Alignment.centerLeft : Alignment.center,
    child: Wrap(
      children: [
        iconData != null
            ? Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Icon(
                  iconData,
                  size: 13,
                ),
              )
            : const SizedBox(),
        Text(
          title,
          maxLines: maxLines,
          textAlign: isCenterLeft ? TextAlign.start : TextAlign.center,
          overflow: overflow ?? TextOverflow.visible,
          style: TextStyle(
              color: colorWord,
              fontStyle: isItalic! ? FontStyle.italic : FontStyle.normal,
              fontSize: fontSize ?? 17,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,),
        ),
      ],
    ),
    // ),
  );
}
