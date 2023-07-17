import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/screen/address_module/create_update_address.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/cancelled_return_page.dart';
import 'package:market_place/screens/MarketPlace/screen/seller_modules/prepare_product_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/order_code_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/order_item_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/payment_method_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/prepare_product_info.dart';
import 'package:market_place/screens/MarketPlace/widgets/see_shop_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/transfer_information_widget.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

class OrderInformationPage extends StatelessWidget {
  final dynamic orderData;
  const OrderInformationPage({super.key, this.orderData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackIconAppbar(),
              AppBarTitle(
                title: "Thông tin đơn hàng",
              ),
              SizedBox()
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  (orderData["status"] == "pending" &&
                              orderData['payment_status'] == "paid") ||
                          orderData['shipping_method_id'] == "COD" ||
                          orderData['status'] == "cancelled"
                      ? Column(
                          children: [
                            orderData['status'] != "cancelled"
                                ? buildPrepareProductWidget()
                                : buildDivider(color: greyColor, bottom: 10),
                            buildTransferInfomationWidget(
                              context: context,
                              orderData: orderData,
                              preffixCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const CrossBar(
                    height: 7,
                    opacity: 0.2,
                  ),
                  GeneralComponent(
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextContent("Địa chỉ nhận hàng", true,
                              fontSize: 15),
                          buildTextContentButton(
                              orderData['status'] != "cancelled"
                                  ? "CẬP NHẬT"
                                  : "XEM",
                              true,
                              colorWord: primaryColor,
                              fontSize: 15, function: () {
                            pushToNextScreen(
                                context,
                                AddressMarketPage(
                                  oldData: orderData['delivery_address'],
                                ));
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      buildTextContent(
                          orderData["delivery_address"]["name"], false,
                          colorWord: greyColor, fontSize: 13),
                      buildSpacer(height: 5),
                      buildTextContent(
                          orderData["delivery_address"]["phone_number"],
                          colorWord: greyColor,
                          false,
                          fontSize: 13),
                      buildSpacer(height: 5),
                      buildTextContent(
                          orderData["delivery_address"]["detail_addresses"],
                          colorWord: greyColor,
                          false,
                          fontSize: 13),
                    ],
                    prefixWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Image.asset(
                            "assets/icons/location_icon.png",
                            height: 14,
                            color: red,
                          ),
                        ),
                        const SizedBox()
                      ],
                    ),
                    preffixCrossAxisAlignment: CrossAxisAlignment.start,
                    changeBackground: transparent,
                    isHaveBorder: false,
                    padding: EdgeInsets.zero,
                  ),
                  const CrossBar(
                    height: 7,
                    opacity: 0.2,
                  ),
                  buildSeeShopWidget(context, orderData),
                  Column(
                    children: List.generate(
                      orderData["order_items"].length,
                      (index) {
                        return buildOrderItem(orderData["order_items"][index]);
                      },
                    ),
                  ),
                  buildDivider(color: greyColor, top: 5, bottom: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextContent(
                              "Thành tiền",
                              true,
                              fontSize: 15,
                            ),
                            buildTextContent(
                              "₫${formatCurrency(orderData["order_total"]).toString()}",
                              true,
                              fontSize: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const CrossBar(
                    height: 7,
                    opacity: 0.2,
                  ),
                  buildPaymentMethodWidget(
                      shippingMethodId: orderData['shipping_method_id']),
                  const CrossBar(
                    height: 7,
                    opacity: 0.2,
                  ),
                  buildOrderCodeWidget(
                      context: context,
                      orderCode: "76346364863",
                      orderedTime: DateTime.now(),
                      cancelledTime: DateTime.now()),
                  buildDivider(color: greyColor, top: 5),
                  buildMarketButton(
                      width: width * 0.9,
                      isHaveBoder: true,
                      contents: [
                        Image.asset(
                          "assets/icons/chat_product_icon.png",
                          height: 15,
                        ),
                        buildSpacer(width: 10),
                        buildTextContent("Liên hệ", true,
                            fontSize: 17,
                            colorWord:
                                Theme.of(context).textTheme.bodyLarge!.color)
                      ],
                      bgColor: transparent,
                      function: () {}),
                  orderData['status'] != "cancelled"
                      ? buildMarketButton(
                          width: width * 0.9,
                          contents: [
                            buildTextContent("Hủy đơn hàng", true,
                                fontSize: 17,
                                colorWord: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color)
                          ],
                          isHaveBoder: true,
                          bgColor: transparent,
                          function: () {})
                      : const SizedBox(),
                  orderData['status'] != "cancelled"
                      ? buildMarketButton(
                          width: width * 0.9,
                          contents: [
                            buildTextContent("Đổi phương thức thanh toán", true,
                                fontSize: 17,
                                colorWord: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color)
                          ],
                          isHaveBoder: true,
                          bgColor: transparent,
                          function: () {})
                      : const SizedBox(),
                ]),
              ),
            ),
            orderData['status'] != "cancelled"
                ? Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    child: buildMarketButton(
                        width: width * 0.9,
                        contents: [
                          buildTextContent("Hủy đơn hàng", false, fontSize: 17)
                        ],
                        bgColor: blueColor,
                        function: () {
                          pushToNextScreen(
                              context, const PrepareProductMarketPage());
                        }),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                        right: 15,
                        left: 15),
                    child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: buildMarketButton(
                                // width: width * 0.38,
                                contents: [
                                  buildTextContent("Chi tiết đơn hủy", false,
                                      fontSize: 14)
                                ],
                                bgColor: blueColor,
                                function: () {
                                  pushToNextScreen(
                                      context,
                                      CancelledReturnOrderPage(
                                        orderData: orderData,
                                      ));
                                }),
                          ),
                          buildSpacer(width: 20),
                          Flexible(
                            child: buildMarketButton(
                                // width: width * 0.38,
                                contents: [
                                  buildTextContent("Mua lại", false,
                                      fontSize: 14)
                                ],
                                bgColor: blueColor,
                                function: () {
                                  // pushToNextScreen(context,
                                  //     const PrepareProductMarketPage());
                                }),
                          )
                        ]),
                  ),
          ],
        ));
  }
}
