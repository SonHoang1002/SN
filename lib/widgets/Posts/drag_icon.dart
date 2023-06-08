import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

Widget buildDragIcon() {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    height: 5,
    width: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: greyColor,
    ),
  );
}
