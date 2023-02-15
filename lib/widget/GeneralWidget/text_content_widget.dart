import 'package:flutter/material.dart';

Widget buildTextContent(String title, bool isBold,
    {Color? colorWord,
    double? fontSize,
    bool? isCenterLeft = true,
    Function? function}) {
  return GestureDetector(
    onTap: () {
      function != null ? function() : null;
    },
    child: Container(
      alignment: isCenterLeft! ? Alignment.centerLeft : Alignment.center,
      child: Wrap(
        children: [
          Text(
            title,
            textAlign: isCenterLeft ? TextAlign.start : TextAlign.center,
            // overflow: TextOverflow.clip,
            style: TextStyle(
                color: colorWord ?? Colors.black,
                fontSize: fontSize ?? 17,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    ),
  );
}
