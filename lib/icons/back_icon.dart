import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(
        FontAwesomeIcons.chevronLeft,
        color: primaryColor,
        size: 20,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
