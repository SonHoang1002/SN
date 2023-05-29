import 'package:flutter/material.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/image_cache.dart';

Widget buildVoucherWidget() {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        border: Border.all(color: greyColor, width: 0.4),
        borderRadius: BorderRadius.circular(4)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Row(
          children: [
            const ImageCacheRender(
              path:
                  "https://snapi.emso.asia/system/media_attachments/files/110/055/464/740/764/326/original/503d539ce0be36c0.jpg",
              width: 100.0,
              height: 100.0,
            ),
            buildSpacer(width: 10),
            Flexible(
              child: SizedBox(
                height: 100.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTextContent(
                        "Gói miễn phí vận chuyển Xtra Plus(Freeshipp Xtra Plus)",
                        false,
                        fontSize: 13),
                    buildTextContent("₫${formatCurrency(10000000)}", true, fontSize: 14,colorWord: red),
                  ],
                ),
              ),
            )
          ],
        )),
        Container(
          width: 1,
          height: 100,
          color: greyColor,
        ),
        buildSpacer(width: 10),
        SizedBox(
          width: 70,
          child: Column(
            children: [
              buildTextContent("Giảm ₫1B", true,
                  fontSize: 14, isCenterLeft: false),
              buildSpacer(height: 5),
              Wrap(
                children: [
                  buildTextContent("Đơn hàng tối thiểu ₫0", false,
                      fontSize: 10, isCenterLeft: false),
                ],
              ), 
              buildMarketButton(width: 50, height: 30, contents: [
                buildTextContent("Lưu", false,
                    fontSize: 13, isCenterLeft: false),
              ])
            ],
          ),
        )
      ],
    ),
  );
}
