import 'package:flutter/material.dart';
import 'package:market_place/theme/colors.dart';

Widget buildRatingStarWidget(dynamic rating, {double? size}) {
  return Row(
      children: List.generate(5, (indexList) {
    return Container(
        padding: EdgeInsets.zero,
        child: Icon(
          Icons.star,
          color: rating != null && rating - 1 >= indexList
              ? Colors.yellow[700]
              : greyColor,
          size: size ?? 16,
        ));
  }).toList());
}
