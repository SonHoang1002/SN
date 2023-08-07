import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

Widget buildCircularProgressIndicator() {
  return const Center(
    child: SizedBox(
      width: 30,
      height: 30,
      child: CupertinoActivityIndicator(
        color: secondaryColor,
        radius: 10,
      ),
    ),
  );
}
