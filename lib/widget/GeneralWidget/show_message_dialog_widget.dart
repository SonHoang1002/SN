import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../screen/MarketPlace/widgets/button_for_market_widget.dart';

buildMessageDialog(BuildContext context, String title, {Function? oKFunction}) {
  final width = MediaQuery.of(context).size.width;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            buildButtonForMarketWidget(
                title: "Hủy",
                bgColor: red,
                width: width * 0.3,
                function: () {
                  popToPreviousScreen(context);
                }),
            buildButtonForMarketWidget(
                title: "OK",
                width: 0.3 * width,
                function: () async {
                  oKFunction != null ? oKFunction() : null;
                }),
          ],
        );
      });
}
