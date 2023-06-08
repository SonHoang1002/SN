import 'package:flutter/material.dart';

Widget buildCircularProgressIndicator() {
  return const Center(
    child: SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        strokeWidth: 3,
      ),
    ),
  );
}
