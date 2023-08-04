// ignore_for_file: iterable_contains_unrelated_type

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/screens/MarketPlace/widgets/timeline.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/cross_bar.dart';

import 'package:market_place/helpers/routes.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/image_cache.dart';

import '../../../theme/colors.dart';

class TransferOrderPage extends ConsumerStatefulWidget {
  final dynamic orderData;
  const TransferOrderPage({super.key, this.orderData});

  @override
  ConsumerState<TransferOrderPage> createState() => _TransferOrderPageState();
}

class _TransferOrderPageState extends ConsumerState<TransferOrderPage> {
  late double width = 0;
  late double height = 0;

  Future _initData() async {
    // setState(() {});
  }

  _buildStatusTitle(dynamic status, dynamic paymentStatus) {
    Color? color = Theme.of(context).textTheme.bodyLarge!.color;
    String statusMessage = "Đơn đã đặt";
    // Giao hnagf không thành công: hủy đơn
    if ((["pending"].contains(status) && paymentStatus == "paid")) {
      statusMessage = "Đơn đã đặt";
    } else if (["cancelled"].contains(status)) {
      statusMessage = "Đã hủy";
      color = red;
    } else if (["shipping"].contains(status)) {
      statusMessage = "Thông tin vận chuyển";
    }
    return buildTextContent(statusMessage, true,
        fontSize: 18, colorWord: color);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    Future.wait([_initData()]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GeneralComponent(
                  [
                    _buildStatusTitle(widget.orderData?['status'],
                        widget.orderData?['payment_status'])
                  ],
                  prefixWidget: GestureDetector(
                    onTap: () {
                      popToPreviousScreen(context);
                    },
                    child: const SizedBox(
                      height: 30,
                      width: 30,
                      child: Icon(
                        FontAwesomeIcons.chevronLeft,
                        size: 20,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  suffixFlexValue: 8,
                  suffixWidget: Wrap(
                    children: [
                      Image.asset(
                        "assets/icons/customer_care_icon.png",
                        height: 20,
                        color: secondaryColor,
                      ),
                      buildSpacer(width: 10),
                      Image.asset(
                        "assets/icons/question_circle_icon.png",
                        height: 20,
                        color: secondaryColor,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  changeBackground: Theme.of(context).colorScheme.background,
                ),
              ),
              buildSpacer(height: 10),
              Flexible(
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CrossBar(
                      height: 5,
                      margin: 0,
                    ),
                    _buildTimeMessage(),
                    const CrossBar(
                      height: 5,
                      margin: 0,
                    ),
                    buildSpacer(height: 10),
                    widget.orderData['status'] != "cancelled"
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: widget.orderData['status'] ==
                                          "shipping"
                                      ? [
                                          buildTextContent(
                                              "Thông tin vận chuyển", false,
                                              fontSize: 16),
                                          const SizedBox()
                                        ]
                                      : [
                                          buildTextContent("Mã vận đơn", false,
                                              fontSize: 15,
                                              colorWord: greyColor),
                                          Row(
                                            children: [
                                              buildTextContent(
                                                  "SKJHFKJHFKFKF", true,
                                                  fontSize: 15),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7),
                                                height: 30,
                                                width: 1,
                                                color: greyColor,
                                              ),
                                              buildTextContentButton(
                                                  "SAO CHÉP", false,
                                                  fontSize: 15,
                                                  colorWord: Colors.green,
                                                  function: () async {
                                                await Clipboard.setData(
                                                    const ClipboardData(
                                                        text: "SKJHFKJHFKFKF"));
                                              }),
                                            ],
                                          ),
                                        ],
                                ),
                              ),
                              buildSpacer(height: 7),
                              buildDivider(height: 5, color: greyColor),
                              buildSpacer(height: 10),
                            ],
                          )
                        : const SizedBox(),
                    Timeline(
                        indicators:
                            List.generate(demoDelivered.length, (index) {
                          if (index == 0) {
                            return Icon(
                              Icons.access_alarm,
                              size: 24,
                              color: widget.orderData['status'] == "cancelled"
                                  ? red
                                  : Colors.green,
                            );
                          }
                          return const Icon(
                            FontAwesomeIcons.dotCircle,
                            color: greyColor,
                            size: 12,
                          );
                        }).toList(),
                        children: List.generate(demoDelivered.length, (index) {
                          return _buildContent(
                              demoDelivered[index]["day"],
                              demoDelivered[index]["time"],
                              demoDelivered[index]["title"],
                              demoDelivered[index]["content"],
                              titleColor: index == 0
                                  ? widget.orderData['status'] == "cancelled"
                                      ? red
                                      : Colors.green
                                  : greyColor);
                        }).toList()),
                  ],
                )),
              ),
            ],
          ),
        ));
  }

  Widget _buildTimeMessage() {
    if (widget.orderData['status'] == "shipping") {
      return Container(
        color: primaryColor,
        child: GeneralComponent(
          [
            buildTextContent(
              "Giao hàng tiết kiệm",
              false,
              fontSize: 15,
            ),
            buildSpacer(height: 10),
            buildTextContent("Mã vận đơn: 00000000", false,
                fontSize: 15, colorWord: greyColor),
          ],
          borderRadiusValue: 0,
          margin: const EdgeInsets.symmetric(vertical: 10),
          changeBackground: transparent,
          prefixWidget: Image.asset(
            "assets/icons/chat_product_icon.png",
            height: 24,
            color: white,
          ),
        ),
      );
    } else if (widget.orderData['status'] == "cancelled") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GeneralComponent(
          [
            buildTextContent(
              "Đã hủy vào",
              true,
              fontSize: 15,
            ),
            buildSpacer(height: 5),
            buildTextContent("CN, 19 Tháng 3 2023", true,
                fontSize: 15, colorWord: red),
            buildSpacer(height: 5),
            buildTextContent("Vận chuyển bởi Nhanh - Shoppee Xpress", false,
                fontSize: 13, colorWord: greyColor),
          ],
          prefixWidget: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 40.0,
              width: 40.0,
              child: ImageCacheRender(
                path: (widget.orderData['order_items'][0]["product_variant"]
                        ?['image']?['url']) ??
                    "https://snapi.emso.asia/system/media_attachments/files/110/020/795/265/163/473/original/30bc954008024edc.jpeg",
              )),
          padding: const EdgeInsets.all(10),
          changeBackground: Theme.of(context).colorScheme.background,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GeneralComponent(
          [
            buildTextContent(
              "Ngày nhận hàng dự kiến",
              true,
              fontSize: 17,
            ),
            buildSpacer(height: 5),
            buildTextContent("CN, 19 Tháng 3 2023", true,
                fontSize: 15, colorWord: red),
            buildSpacer(height: 5),
            buildTextContent("Vận chuyển bởi Nhanh - Shoppee Xpress", false,
                fontSize: 13, colorWord: greyColor),
          ],
          preffixFlexValue: 5,
          prefixWidget: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 80.0,
              width: 80.0,
              child: ImageCacheRender(
                path: (widget.orderData['order_items'][0]["product_variant"]
                        ?['image']?['url']) ??
                    "https://snapi.emso.asia/system/media_attachments/files/110/020/795/265/163/473/original/30bc954008024edc.jpeg",
              )),
          padding: const EdgeInsets.all(10),
          changeBackground: Theme.of(context).colorScheme.background,
        ),
      );
    }
  }

  Widget _buildContent(String day, String time, String title, String content,
      {Color titleColor = greyColor}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).colorScheme.background,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        buildTextContent(day, true, fontSize: 14, colorWord: titleColor),
        buildSpacer(height: 5),
        buildTextContent(time, false, fontSize: 14, colorWord: titleColor),
        buildSpacer(height: 15),
        buildTextContent(title, true, fontSize: 17, colorWord: titleColor),
        buildSpacer(height: 5),
        buildTextContent(content, false, fontSize: 16, colorWord: titleColor),
      ]),
    );
  }
}

List<Map<String, dynamic>> demoDelivered = [
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Demo Timeline",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Demo Timeline",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Demo Timeline",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Demo Timeline",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Demo Timeline",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Demo Timeline",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
];
