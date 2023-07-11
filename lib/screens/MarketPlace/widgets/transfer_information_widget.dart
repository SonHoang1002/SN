import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/screen/transfer_order_page.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

//
buildTransferInfomationWidget(
    {required BuildContext context,
    required dynamic orderData,
    Widget? prefixWidget,
    CrossAxisAlignment? preffixCrossAxisAlignment}) {
  return GeneralComponent(
    [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextContent("Thông tin vận chuyển", true, fontSize: 17),
          buildTextContentButton("Xem", true,
              fontSize: 17, colorWord: greyColor, function: () {
            pushToNextScreen(
                context,
                TransferOrderPage(
                  orderData: orderData,
                ));
          }),
        ],
      ),
      const SizedBox(
        height: 7,
      ),
      buildTextContent("Hỏa tốc", false, fontSize: 13),
      buildSpacer(height: 5),
      buildTextContent("Express Viet Nam", false, fontSize: 13),
    ],
    prefixWidget: prefixWidget ??
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Image.asset(
                "assets/icons/transfer_car_icon.png",
                height: 14,
                color: red,
              ),
            ),
            const SizedBox()
          ],
        ),
    changeBackground: transparent,
    isHaveBorder: false,
    preffixCrossAxisAlignment: CrossAxisAlignment.start,
    padding: EdgeInsets.zero,
  );
}
