import 'package:flutter/material.dart';

Widget buildCircularProgressIndicator({EdgeInsets? margin = EdgeInsets.zero}) {
  return Center(
    child: Container(
      margin: margin,
      width: 30,
      height: 30,
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        strokeWidth: 3,
      ),
    ),
  );
}
