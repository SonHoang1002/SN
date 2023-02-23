import 'package:flutter/cupertino.dart';

buildSpacer({double? height, double? width}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
  );
}