import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

Widget buildRatingStarWidget(dynamic rating, {double? size}) {
  int roundedRating = rating?.floor() ?? 0;

  double decimalPart = (double.parse((rating ?? 0).toString())) % 1;

  if (decimalPart >= 0.5) {
    roundedRating += 1;
  }

  return Row(
    children: List.generate(5, (index) {
      return Container(
        padding: EdgeInsets.zero,
        child: Icon(
          Icons.star,
          color: roundedRating > index ? Colors.yellow[700] : greyColor,
          size: size ?? 16,
        ),
      );
    }).toList(),
  );
}
