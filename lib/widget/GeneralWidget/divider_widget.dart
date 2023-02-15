import 'package:flutter/material.dart';

buildDivider(
    {double? left,
    double? top,
    double? right,
    double? bottom,
    Color? color = Colors.white}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0),
    child: Divider(
      height: 10,
      color: color!,
    ),
  );
}
