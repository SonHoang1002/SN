import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/market_button_widget.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

buildMessageDialog(BuildContext context, String title,
    {bool? oneButton = false, Function? oKFunction}) {
  final width = MediaQuery.of(context).size.width;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            !oneButton!
                ? buildMarketButton(
                    contents: [buildTextContent("Hủy", false, fontSize: 13)],
                    bgColor: red,
                    width: width * 0.3,
                    function: () {
                      popToPreviousScreen(context);
                    })
                : const SizedBox(),
            buildMarketButton(
                contents: [buildTextContent("OK", false, fontSize: 13)],
                width: 0.3 * width,
                function: () async {
                  oKFunction != null
                      ? oKFunction()
                      : popToPreviousScreen(context);
                }),
          ],
        );
      });
}
