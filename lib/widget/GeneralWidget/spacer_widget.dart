import 'package:flutter/cupertino.dart';

buildSpacer({double? height, double? width, Color? color}) {
  return Container(
    color: color,
    height: height ?? 0,
    width: width ?? 0,
  );
}
