import 'package:flutter/material.dart';

Widget buildTextContent(String title, bool isBold,
    {Color? colorWord, double? fontSize, bool? isCenterLeft = true}) {
  return Container(
    alignment: isCenterLeft! ? Alignment.centerLeft : Alignment.center,
    child: Wrap(
      children: [
        Text(
          title,
          style: TextStyle(
              color: colorWord ?? Colors.black,
              fontSize: fontSize ?? 17,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    ),
  );
}
