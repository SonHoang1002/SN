import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

buildOrderCodeWidget(
    {required BuildContext context,
    required String orderCode,
    DateTime? orderedTime,DateTime? cancelledTime }) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextContent(
              "Mã đơn hàng",
              true,
              fontSize: 14,
            ),
            Row(
              children: [
                buildTextContent(
                  orderCode,
                  true,
                  fontSize: 14,
                ),
                buildSpacer(width: 10),
                buildTextContentButton("SAO CHÉP", true,
                    fontSize: 14, colorWord: primaryColor, function: () async {
                  await Clipboard.setData(ClipboardData(text: orderCode));
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Sao chép mã đơn hàng thành công")));
                }),
              ],
            ),
          ],
        ),
        orderedTime != null
            ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTextContent("Thời gian đặt hàng", false,
                        fontSize: 14, colorWord: greyColor),
                    buildTextContent(
                      DateFormat("dd-MM-yyyy HH:mm").format(orderedTime),
                      false,
                      fontSize: 14,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        cancelledTime != null
            ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTextContent("Thời gian hủy đơn", false,
                        fontSize: 14, colorWord: greyColor),
                    buildTextContent(
                      DateFormat("dd-MM-yyyy HH:mm").format(cancelledTime),
                      false,
                      fontSize: 14,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    ),
  );
}
