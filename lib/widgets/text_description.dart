import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextDescription extends StatelessWidget {
  final String description;
  final double? size;
  final int? maxLinesDescription;
  const TextDescription(
      {Key? key,
      required this.description,
      this.size,
      this.maxLinesDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      maxLines: 1,
      style: TextStyle(
          color: greyColor,
          fontWeight: FontWeight.normal,
          fontSize: size ?? 12),
    );
  }
}
