import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/timeline.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/cross_bar.dart';

import 'package:market_place/helpers/routes.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widgets/messenger_app_bar/app_bar_title.dart';

class SuccessOrderPage extends ConsumerStatefulWidget {
  const SuccessOrderPage({super.key});

  @override
  ConsumerState<SuccessOrderPage> createState() => _SuccessOrderPageState();
}

class _SuccessOrderPageState extends ConsumerState<SuccessOrderPage> {
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
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(text: "Thông tin đơn hàng"),
              SizedBox()
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GeneralComponent(
                    [
                      buildTextContent(
                        "Đơn hàng thành công",
                        true,
                        fontSize: 15,
                      ),
                      buildSpacer(height: 10),
                      buildTextContent(
                        "Cảm ơn bạn đã mua sắm tại Emso !",
                        false,
                        fontSize: 13,
                      ),
                    ],
                    suffixFlexValue: 8,
                    suffixWidget: const ImageCacheRender(
                      path:
                          "https://snapi.emso.asia/system/media_attachments/files/109/311/682/380/490/462/original/e692f50e243bd484.png",
                      height: 80.0,
                      width: 80.0,
                    ),
                    changeBackground: Theme.of(context).colorScheme.background,
                  ),
                  const CrossBar(
                    height: 5,
                  ),
                  _buildTransferWidget(),
                  buildDivider(height: 10, color: greyColor),
                  _buildAddressWidget(),
                  buildSpacer(height: 7),
                  buildDivider(height: 5, color: greyColor),
                  buildSpacer(height: 10),
                ],
              )),
        ));
  }

  Widget _buildAddressWidget() {
    return InkWell(
      onTap: () async {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            GeneralComponent(
              [
                buildTextContent(
                  "Địa chỉ nhận hàng",
                  false,
                  fontSize: 13,
                )
              ],
              prefixWidget: const Icon(
                FontAwesomeIcons.locationCrosshairs,
                size: 15,
                color: red,
              ),
              suffixFlexValue: 8,
              suffixWidget: buildTextContent(
                "SAO CHÉP",
                true,
                fontSize: 16,
              ),
              isHaveBorder: false,
              borderRadiusValue: 0,
              changeBackground: transparent,
              padding: const EdgeInsets.only(left: 10, bottom: 7),
              function: () async {},
            ),
            GeneralComponent(
              [
                buildTextContent("${"mdhfgjkjdfhgd"}", false, fontSize: 15),
                buildTextContent("${"mdhfgjkjdfhgd"}", false, fontSize: 15),
              ],
              prefixWidget: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: SizedBox(),
              ),
              isHaveBorder: false,
              borderRadiusValue: 0,
              changeBackground: transparent,
              padding: const EdgeInsets.only(left: 10),
              function: () async {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferWidget() {
    return InkWell(
      onTap: () async {},
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(
                "Thông tin vận chuyển",
                false,
                fontSize: 13,
              )
            ],
            prefixWidget: const Icon(
              FontAwesomeIcons.locationCrosshairs,
              size: 15,
              color: red,
            ),
            suffixWidget: buildTextContent(
              "XEM",
              true,
              fontSize: 16,
            ),
            isHaveBorder: false,
            borderRadiusValue: 0,
            changeBackground: transparent,
            padding: const EdgeInsets.only(left: 10, bottom: 7),
            function: () async {},
          ),
          GeneralComponent(
            [
              buildTextContent("${"Nhanh"}", false, fontSize: 15),
              buildTextContent("${"Emso Xpress - JSGJSJHFDKSKSDFH"}", false,
                  fontSize: 15),
            ],
            prefixWidget: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: SizedBox(),
            ),
            isHaveBorder: false,
            borderRadiusValue: 0,
            changeBackground: transparent,
            padding: const EdgeInsets.only(left: 10),
            function: () async {},
          ),
          buildSpacer(height: 7),
          GeneralComponent(
            [
              buildTextContent("${"Đơn hàng đã giao thành công"}", false,
                  fontSize: 15, colorWord: Colors.green),
            ],
            prefixWidget: const Icon(
              FontAwesomeIcons.dotCircle,
              size: 15,
              color: Colors.green,
            ),
            isHaveBorder: false,
            borderRadiusValue: 0,
            changeBackground: transparent,
            padding: const EdgeInsets.only(left: 10),
            function: () async {},
          ),
          buildSpacer(height: 7),
          GeneralComponent(
            [
              buildTextContent("${"3 - 3 - 2023 10:25"}", false, fontSize: 12),
            ],
            prefixWidget: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: SizedBox(),
            ),
            isHaveBorder: false,
            borderRadiusValue: 0,
            changeBackground: transparent,
            padding: const EdgeInsets.only(left: 10),
            function: () async {},
          ),
          buildSpacer(height: 7),
        ],
      ),
    );
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
