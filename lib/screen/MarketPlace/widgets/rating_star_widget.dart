import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

Widget buildRatingStarWidget(dynamic rating, {double? size}) {
  return Row(
      children: List.generate(5, (indexList) {
    return Container(
        // margin: const EdgeInsets.only(right: 1),
        padding: EdgeInsets.zero,
        child: Icon(
          Icons.star,
          color: rating - 1 >= indexList ? Colors.yellow[700] : greyColor,
          size: size ?? 16,
        ));
  }).toList());
}
