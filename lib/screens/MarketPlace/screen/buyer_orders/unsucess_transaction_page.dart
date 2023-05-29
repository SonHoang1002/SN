import 'package:flutter/material.dart';
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
// import 'package:timelines/timelines.dart';
// import 'package:timelines/timelines.dart';

import '../../../../theme/colors.dart';

class UnSuccessTransactionPage extends ConsumerStatefulWidget {
  const UnSuccessTransactionPage({super.key});

  @override
  ConsumerState<UnSuccessTransactionPage> createState() =>
      _UnSuccessTransactionPageState();
}

class _UnSuccessTransactionPageState
    extends ConsumerState<UnSuccessTransactionPage> {
  late double width = 0;
  late double height = 0;

  Future _initData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Future.wait([_initData()]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GeneralComponent(
                      [
                        buildTextContent("Giao hàng không thành công", true,
                            fontSize: 18, colorWord: red)
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
                            color: red,
                          ),
                        ),
                      ),
                      suffixFlexValue: 8,
                      suffixWidget: Wrap(
                        children: [
                          const Icon(
                            FontAwesomeIcons.message,
                            size: 20,
                            color: red,
                          ),
                          buildSpacer(width: 10),
                          const Icon(
                            FontAwesomeIcons.infoCircle,
                            size: 20,
                            color: red,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      changeBackground:
                          Theme.of(context).colorScheme.background,
                    ),
                  ),
                  const CrossBar(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GeneralComponent(
                      [
                        buildTextContent(
                          "Ngày nhận hàng dự kiện",
                          true,
                          fontSize: 17,
                        ),
                        buildSpacer(height: 5),
                        buildTextContent("CN, 19 Tháng 3 2023", true,
                            fontSize: 15, colorWord: red),
                        buildSpacer(height: 5),
                        buildTextContent(
                            "Vận chuyển bởi Nhanh - Shoppee Xpress", false,
                            fontSize: 13, colorWord: greyColor),
                      ],
                      preffixFlexValue: 5,
                      prefixWidget: Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 80.0,
                          width: 80.0,
                          child: const ImageCacheRender(
                            path:
                                "https://snapi.emso.asia/system/media_attachments/files/110/020/795/265/163/473/original/30bc954008024edc.jpeg",
                          )),
                      padding: const EdgeInsets.all(10),
                      changeBackground:
                          Theme.of(context).colorScheme.background,
                    ),
                  ),
                  const CrossBar(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextContent("Mã vận đơn", false,
                            fontSize: 15, colorWord: greyColor),
                        Row(
                          children: [
                            buildTextContent("SKJHFKJHFKFKF", true,
                                fontSize: 15),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 7),
                              height: 30,
                              width: 1,
                              color: greyColor,
                            ),
                            buildTextContentButton("SAO CHÉP", false,
                                fontSize: 15,
                                colorWord: Colors.green,
                                function: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                  buildSpacer(height: 7),
                  buildDivider(height: 5, color: greyColor),
                  buildSpacer(height: 10),
                  Timeline(
                      indicators: List.generate(demoDelvered.length, (index) {
                        if (index == 0) {
                          return const Icon(Icons.access_alarm, size: 24);
                        }
                        return const Icon(
                          FontAwesomeIcons.dotCircle,
                          color: greyColor,
                          size: 12,
                        );
                      }).toList(),
                      children: List.generate(demoDelvered.length, (index) {
                        return _buildContent(
                            demoDelvered[index]["day"],
                            demoDelvered[index]["time"],
                            demoDelvered[index]["title"],
                            demoDelvered[index]["content"],
                            titleColor: index == 0 ? red : greyColor);
                      }).toList()),
                ],
              )),
        ));
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
        buildTextContent(day, true, fontSize: 14, colorWord: greyColor),
        buildSpacer(height: 5),
        buildTextContent(time, false, fontSize: 14, colorWord: greyColor),
        buildSpacer(height: 15),
        buildTextContent(title, true, fontSize: 17, colorWord: titleColor),
        buildSpacer(height: 5),
        buildTextContent(content, false, fontSize: 16, colorWord: titleColor),
      ]),
    );
  }
}

List<Map<String, dynamic>> demoDelvered = [
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Giao hàng không thành công",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Giao hàng không thành công",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Giao hàng không thành công",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Giao hàng không thành công",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Giao hàng không thành công",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Giao hàng không thành công",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
  {
    "day": "18 tháng 3",
    "time": "15:34",
    "title": "Giao hàng không thành công",
    "content":
        "ĐƠn hngf hoàn trả về cho người dùng do gaio hàng không thành công"
  },
];
