import 'package:flutter/material.dart';
import 'package:market_place/theme/colors.dart';

class OnlineIcon extends StatelessWidget {
  final double left;
  final double bottom;
  final double width;
  final double height;

  const OnlineIcon(
      {Key? key,
      required this.left,
      required this.bottom,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: bottom,
        left: left,
        child: Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
              color: online,
              shape: BoxShape.circle,
              border: Border.all(width: 3, color: white)),
        ));
  }
}
