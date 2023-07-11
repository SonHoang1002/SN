import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

Widget buildTranferFee(BuildContext context) {
  return GeneralComponent(
    [
      GeneralComponent(
        [
          buildTextContent("Miễn phí vận chuyển", false, fontSize: 14),
          buildSpacer(height: 5),
          buildTextContent(
              "Miễn phí vận chuyển cho đơn hàng trên ₫250.000", false,
              fontSize: 14, colorWord: greyColor)
        ],
        preffixCrossAxisAlignment: CrossAxisAlignment.start,
        prefixWidget: Image.asset(
          "assets/icons/transfer_car_icon.png",
          height: 14,
          color: Colors.green,
        ),
        changeBackground: transparent,
        padding: EdgeInsets.only(bottom: 10),
      ),
      GeneralComponent(
        [
          buildTextContent("Phí vận chuyển từ ₫1.500-₫22.000", false,
              fontSize: 14),
        ],
        preffixCrossAxisAlignment: CrossAxisAlignment.start,
        prefixWidget: Image.asset(
          "assets/icons/transfer_car_icon.png",
          height: 14,
          color: blackColor,
        ),
        changeBackground: transparent,
        padding: EdgeInsets.zero,
      ),
    ],
    changeBackground: transparent,
    padding: EdgeInsets.zero,
    suffixWidget: const Icon(
      FontAwesomeIcons.chevronRight,
      size: 17,
    ),
  );
}
