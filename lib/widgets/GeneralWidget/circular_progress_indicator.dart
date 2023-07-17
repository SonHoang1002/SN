import 'package:flutter/cupertino.dart'; 
import 'package:social_network_app_mobile/theme/colors.dart';

Widget buildCircularProgressIndicator({EdgeInsets? margin = EdgeInsets.zero}) {
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
  // return Center(
  //   child: Container(
  //     margin: margin,
  //     width: 30,
  //     height: 30,
  //     child: const CircularProgressIndicator(
  //       valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
  //       strokeWidth: 3,
  //     ),
  //   ),
  // );
}
