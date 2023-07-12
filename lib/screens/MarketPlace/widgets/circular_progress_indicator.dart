import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_place/theme/colors.dart';

Widget buildCircularProgressIndicator() {
  return const Center(
    child: SizedBox(
      width: 30,
      height: 30,
      child: CupertinoActivityIndicator(
        color: secondaryColor,
        radius: 10,
      ),
    ),
  );
}
