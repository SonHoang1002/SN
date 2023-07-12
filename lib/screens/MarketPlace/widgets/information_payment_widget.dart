import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

buildPaymentInformationWidget(dynamic orderData) {
  return GeneralComponent(
    [
      buildTextContent("Thông tin thanh toán", true, fontSize: 16),
      const SizedBox(
        height: 7,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextContent("Tổng tiền sản phẩm", false, fontSize: 13),
          buildTextContent("đ${orderData["subtotal"] ?? 0}", false,
              fontSize: 13, colorWord: greyColor),
        ],
      ),
      buildSpacer(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextContent("Phí vận chuyển (không tính trợ giá)", false,
              fontSize: 13),
          buildTextContent("đ${orderData["delivery_fee"] ?? 0}", false,
              fontSize: 13, colorWord: greyColor),
        ],
      ),
      buildSpacer(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextContent("Phí giao dịch", false, fontSize: 13),
          buildTextContent("đ15.000", false,
              fontSize: 13, colorWord: greyColor),
        ],
      ),
      buildSpacer(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextContent("Tổng tiền thanh toán", false, fontSize: 13),
          buildTextContent("đ ${orderData["order_total"] ?? 0}", false,
              fontSize: 13, colorWord: greyColor),
        ],
      ),
    ],
    prefixWidget: const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          FontAwesomeIcons.cartPlus,
          size: 18,
        ),
        SizedBox()
      ],
    ),
    changeBackground: transparent,
    isHaveBorder: false,
    padding: EdgeInsets.zero,
  );
}
