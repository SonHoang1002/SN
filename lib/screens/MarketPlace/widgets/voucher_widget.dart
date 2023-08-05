import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart'; 
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

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
                    buildTextContent("₫${formatCurrency(10000000)}", true,
                        fontSize: 14, colorWord: red),
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

Widget buildVoucherAndSelect(
    {String? title,
    Color? titleColor,
    String? subTitle,
    Color? subTitleColor,
    Function? function,
    bool haveSuffixIcon = true,
    bool havePrefixIcon = true,
    EdgeInsets? padding,
    double? mainFontSize,
    double? subTitleFontSize,
    bool? titleBold = false,
    bool? subTitleBold = false,
    Widget? addtionalWidget}) {
  return GestureDetector(
      onTap: () {
        function != null ? function() : null;
      },
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: addtionalWidget != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    havePrefixIcon
                        ? Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.moneyBill1,
                                size: 15,
                              ),
                              buildSpacer(width: 10),
                            ],
                          )
                        : const SizedBox(),
                    buildTextContent(title ?? "Voucher của Shop", titleBold!,
                        fontSize: mainFontSize ?? 13, colorWord: titleColor),
                  ],
                ),
                addtionalWidget ?? const SizedBox()
              ],
            ),
            Row(
              children: [
                buildTextContent(subTitle ?? "Chọn hoặc nhập mã", subTitleBold!,
                    fontSize: subTitleFontSize ?? 13, colorWord: subTitleColor),
                haveSuffixIcon
                    ? Row(
                        children: [
                          buildSpacer(width: 5),
                          const Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 15,
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ));
}

Widget buildImageVoucherWidget() {
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
                    buildTextContent("₫${formatCurrency(10000000)}", true,
                        fontSize: 14, colorWord: red),
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

Widget buildNonImageVoucherWidget(
    dynamic mainTitle, dynamic condition, dynamic useTime,
    {double width = 350}) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        border: Border.all(color: greyColor, width: 0.4),
        borderRadius: BorderRadius.circular(4),
        color: red.withOpacity(0.15)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextContent(mainTitle.toString(), true,
                fontSize: 17, colorWord: red),
            buildSpacer(height: 7),
            buildTextContent(condition.toString(), false,
                fontSize: 12, maxLines: 2),
            buildSpacer(height: 7),
            buildTextContent('HSD: $useTime', false,
                fontSize: 13, colorWord: greyColor),
          ],
        )),
        Container(
          child: buildMarketButton(width: 50, height: 30, contents: [
            buildTextContent("Lưu", false, fontSize: 13, isCenterLeft: false),
          ]),
        )
      ],
    ),
  );
}
