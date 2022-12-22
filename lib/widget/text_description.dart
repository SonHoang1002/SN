import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextDescription extends StatelessWidget {
  final String description;
  const TextDescription({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(color: greyColor, fontWeight: FontWeight.normal),
    );
  }
}
