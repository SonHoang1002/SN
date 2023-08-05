import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

Widget buildPaymentMethodWidget({required dynamic shippingMethodId}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextContent(
              "Phương thức thanh toán",
              true,
              fontSize: 14,
            ),
            shippingMethodId == null
                ? buildTextContentButton("CẬP NHẬT", true,
                    fontSize: 16, colorWord: primaryColor, function: () {})
                : const SizedBox()
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextContent(_buildPaymentMessage(shippingMethodId), false,
                  fontSize: 14, colorWord: greyColor),
            ],
          ),
        )
      ],
    ),
  );
}

String _buildPaymentMessage(dynamic shippingMethodId) {
  String message = "Tài khoản ngân hàng đã liên kết với ví @@@@";
  switch (shippingMethodId) {
    case cod:
      message = "Thanh toán khi nhận hàng";
      break;
    case vnpay:
      message = "Thanh toán qua VNPAY";
      break;
    case vtcpay:
      message = "Thanh toán qua VTCPAY";
      break;
    case momo:
      message = "Thanh toán qua MOMO";
      break;
    default:
      break;
  }
  return message;
}
