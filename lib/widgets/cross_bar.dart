import 'package:flutter/material.dart';

class CrossBar extends StatelessWidget {
  final double? height;
  final double? margin;
  const CrossBar({Key? key, this.height, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 2,
      margin: EdgeInsets.only(top: margin ?? 10, bottom: margin ?? 10),
      color: Colors.grey.withOpacity(0.5),
    );
  }
}
