import 'package:flutter/material.dart';

class CrossBar extends StatelessWidget {
  final double? height;
  final double? margin;
  final double? opacity;
  const CrossBar({Key? key, this.height, this.margin, this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 2,
      margin: EdgeInsets.only(top: margin ?? 10, bottom: margin ?? 10),
      color: Colors.grey.withOpacity(opacity ?? 0.5),
    );
  }
}
