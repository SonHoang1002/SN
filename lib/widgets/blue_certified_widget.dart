import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

Widget buildBlueCertifiedWidget({double? iconSize, EdgeInsets? margin}) {
  return Container(
    height: iconSize ?? 15,
    width: iconSize ?? 15,
    margin: margin ?? const EdgeInsets.only(left: 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
    child: Image.asset(
      "assets/icons/blue_certified.png",
      color: blueColor,
    ),
  );
}
