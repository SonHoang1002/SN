import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart'; 
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import '../../../../theme/colors.dart'; 

class SuccessOrderPage extends ConsumerStatefulWidget {
  final dynamic orderData;
  const SuccessOrderPage({super.key, required this.orderData});

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
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackIconAppbar(),
              AppBarTitle(title: "Thông tin đơn hàng"),
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
                  widget.orderData?['delivery_address'] != null
                      ? Column(
                          children: [
                            _buildAddressWidget(),
                            buildSpacer(height: 7),
                            buildDivider(height: 5, color: greyColor),
                            buildSpacer(height: 10),
                          ],
                        )
                      : const SizedBox(),
                ],
              )),
        ));
  }

  Widget _buildAddressWidget() {
    List address = [
      widget.orderData?['delivery_address']?['detail_addresses'] ?? "",
      widget.orderData?['delivery_address']?['ward_name'] ?? "",
      widget.orderData?['delivery_address']?['district_name'] ?? "",
      widget.orderData?['delivery_address']?['province_name'] ?? "",
    ];

    final message =
        address.any((element) => element != "") ? address.join(",") : "";
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
              suffixWidget: buildTextContentButton("SAO CHÉP", true,
                  fontSize: 16, function: () {
                Clipboard.setData(ClipboardData(text: message));
              }),
              isHaveBorder: false,
              borderRadiusValue: 0,
              changeBackground: transparent,
              padding: const EdgeInsets.only(left: 10, bottom: 7),
              function: () async {},
            ),
            GeneralComponent(
              [
                buildTextContent(
                    "${widget.orderData?['delivery_address']?['detail_addresses'] ?? ""}",
                    false,
                    fontSize: 15),
                buildTextContent(
                    "${widget.orderData?['delivery_address']?['ward_name'] ?? ""}",
                    false,
                    fontSize: 15),
                buildTextContent(
                    "${widget.orderData?['delivery_address']?['district_name'] ?? ""}",
                    false,
                    fontSize: 15),
                buildTextContent(
                    "${widget.orderData?['delivery_address']?['ward_nprovince_nameame'] ?? ""}",
                    false,
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
              buildTextContent("Nhanh", false, fontSize: 15),
              buildSpacer(height: 5),
              buildTextContent("Emso Xpress - JSGJSJHFDKSKSDFH", false,
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
              buildTextContent("Đơn hàng đã giao thành công", false,
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
              buildTextContent(
                  DateFormat("dd-MM-yyyy hh-mm").format(DateTime.now()), false,
                  fontSize: 12),
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
