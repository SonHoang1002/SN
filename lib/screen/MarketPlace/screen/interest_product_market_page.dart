import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevateButton_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/payment_market_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../constant/group_constants.dart';
import '../../../helper/push_to_new_screen.dart';

class InterestProductMarketPage extends StatefulWidget {
  @override
  State<InterestProductMarketPage> createState() =>
      _InterestProductMarketPageState();
}

class _InterestProductMarketPageState extends State<InterestProductMarketPage> {
  late double width = 0;
  late double height = 0;
  final bgColor = greyColor;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(title: "Quan tâm"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
                // color: Colors.black,
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(10, (index) {
                      return _buildInterestComponent();
                    }),
                  ),
                ),
              ),
            ),
            //
          ],
        ));
  }

  _buildInterestComponent() {
    return InkWell(
      onTap: () {
        pushToNextScreen(context, DetailProductMarketPage(id: 1));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 0.4, color: greyColor),
            color: greyColor[100],
            borderRadius: BorderRadius.circular(7)),
        child: Column(
          children: [
            GeneralComponent(
              [
                const Text(
                  "ÁO ĐẤU SÂN NHÀ REAL MADRID 21/22 - trắng hgfh hgfh hjhjh jhjh jh",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                buildSpacer(height: 7),
                buildTextContent("Chi Phat - nguoi quan tam", false,
                    fontSize: 15),
                buildSpacer(height: 7),
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: red, borderRadius: BorderRadius.circular(20)),
                    child: const Text("120000 VND"))
              ],
              preffixFlexValue: 5,
              prefixWidget: Container(
                // width: 150,
                margin: const EdgeInsets.only(right: 10),
                child: const ImageCacheRender(
                  height: 100.0,
                  width: 150.0,
                  path:
                      "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
                ),
              ),
              changeBackground: transparent,
              function: () {
                pushToNextScreen(context, DetailProductMarketPage(id: 1));
              },
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: buildElevateButtonWidget(
                    title: "Quan tâm",
                    iconData: FontAwesomeIcons.star,
                    width: width * 0.6,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: buildElevateButtonWidget(
                      iconData: FontAwesomeIcons.ellipsisVertical,
                      title: "",
                      width: 30,
                      function: () {
                        showBottomSheetCheckImportantSettings(
                            context, 210, "Quan tâm",
                            bgColor: bgColor,
                            widget: ListView.builder(
                                shrinkWrap: true,
                                itemCount: InterestProductMarketConstants
                                    .INTEREST_PRODUCT_BOTTOM_SELECTIONS["data"]
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = InterestProductMarketConstants
                                          .INTEREST_PRODUCT_BOTTOM_SELECTIONS[
                                      "data"];
                                  return Column(
                                    children: [
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                              data[index]["title"], true,
                                              fontSize: 16)
                                        ],
                                        prefixWidget: Container(
                                          height: 25,
                                          width: 25,
                                          margin: const EdgeInsets.only(right: 10),
                                          child: data[index]["icon"],
                                        ),
                                        suffixFlexValue: 1,
                                        suffixWidget:
                                            data[index]["title"] == "Chia sẻ"
                                                ? Container(
                                                    height: 25,
                                                    // width: 25,
                                                    child: const Icon(FontAwesomeIcons
                                                        .chevronRight),
                                                  )
                                                : null,
                                        changeBackground: transparent,
                                        padding: const EdgeInsets.all(5),
                                        function: () {
                                          data[index]["title"] == "Chia sẻ"
                                              ? showBottomSheetCheckImportantSettings(
                                                  context,
                                                  300,
                                                  "Chia sẻ sản phẩm",
                                                  iconData: FontAwesomeIcons
                                                      .chevronLeft,
                                                  bgColor: bgColor,
                                                  widget: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          InterestProductMarketConstants
                                                              .INTEREST_PRODUCT_BOTTOM_SHARE_SELECTIONS[
                                                                  "data"]
                                                              .length,
                                                      itemBuilder: (context,
                                                          indexShare) {
                                                        final data =
                                                            InterestProductMarketConstants
                                                                    .INTEREST_PRODUCT_BOTTOM_SHARE_SELECTIONS[
                                                                "data"];
                                                        return Column(
                                                          children: [
                                                            GeneralComponent(
                                                              [
                                                                buildTextContent(
                                                                    data[indexShare]
                                                                        [
                                                                        "title"],
                                                                    true,
                                                                    fontSize:
                                                                        16)
                                                              ],
                                                              prefixWidget:
                                                                  Container(
                                                                height: 25,
                                                                width: 25,
                                                                margin: const EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10),
                                                                child: data[
                                                                        indexShare]
                                                                    ["icon"],
                                                              ),
                                                              suffixFlexValue:
                                                                  1,
                                                              suffixWidget: data[
                                                                              indexShare]
                                                                          [
                                                                          "title"] ==
                                                                      "Chia sẻ"
                                                                  ? Container(
                                                                      height:
                                                                          25,
                                                                      // width: 25,
                                                                      child: const Icon(
                                                                          FontAwesomeIcons
                                                                              .chevronRight),
                                                                    )
                                                                  : null,
                                                              changeBackground:
                                                                  transparent,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              function: () {
                                                                String title =
                                                                    "";
                                                                Widget body =
                                                                    const SizedBox();
                                                                switch (data[
                                                                        indexShare]
                                                                    ["title"]) {
                                                                  case 'Chia sẻ ngay':
                                                                    break;
                                                                  case 'Chia sẻ lên bảng tin':
                                                                    break;
                                                                  case 'Chia sẻ lên nhóm':
                                                                    title =
                                                                        "Chia sẻ lên nhóm";
                                                                    body = _buildContentsForShareOnGroup(
                                                                        InterestProductMarketConstants
                                                                            .INTEREST_PRODUCT_BOTTOM_GROUP_SHARE_SELECTIONS,
                                                                        InterestProductMarketConstants
                                                                            .INTEREST_PRODUCT_SEARCH_GROUP_PLACEHOLDER);
                                                                    break;
                                                                  case 'Chia sẻ lên trang cá nhân':
                                                                    title =
                                                                        "Chia sẻ lên trang cá nhân của bạn bè";
                                                                    body = _buildContentsForShareOnGroup(
                                                                        InterestProductMarketConstants
                                                                            .INTEREST_PRODUCT_BOTTOM_PERSONAL_PAGE_SELECTIONS,
                                                                        InterestProductMarketConstants
                                                                            .INTEREST_PRODUCT_SEARCH_FRIEND_PLACEHOLDER);

                                                                    break;
                                                                  case 'Sao chép liên kết':
                                                                    break;
                                                                  default:
                                                                    break;
                                                                }
                                                                showBottomSheetCheckImportantSettings(
                                                                    context,
                                                                    height *
                                                                        0.7,
                                                                    title,
                                                                    bgColor:
                                                                        greyColor[
                                                                            400],
                                                                    widget:
                                                                        body);
                                                              },
                                                            ),
                                                            buildDivider(
                                                                color:
                                                                    greyColor)
                                                          ],
                                                        );
                                                      }))
                                              : null;
                                        },
                                      ),
                                      buildDivider(color: greyColor)
                                    ],
                                  );
                                }));
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildContentsForShareOnGroup(dynamic data, String placeholder) {
    return Column(
      children: [
        // user
        GeneralComponent(
          [
            buildTextContent(
              "Chia sẻ với tư cách",
              false,
              fontSize: 15,
            ),
            buildSpacer(height: 5),
            buildTextContent(
              "Nguyen Van A",
              true,
              fontSize: 15,
            ),
          ],
          prefixWidget: Container(
            height: 40.0,
            width: 40.0,
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const ImageCacheRender(
                height: 40.0,
                width: 40.0,
                path:
                    "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
              ),
            ),
          ),
          changeBackground: transparent,
          isHaveBorder: true,
        ),

        // search
        Container(
          height: 35,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: TextFormField(
            onChanged: ((value) {}),
            textAlign: TextAlign.left,
            style: const TextStyle(),
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  FontAwesomeIcons.search,
                  color: Colors.grey,
                  size: 13,
                ),
                contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(17)))),
          ),
        ),
        // list
        Container(
            height: 376,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: data.length,
                itemBuilder: (context, index) => Column(
                      children: [
                        GeneralComponent(
                          [
                            Text(
                              data[index][1],
                              style: const TextStyle(
                                  // color: white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            data[index][2] == ""
                                ? const SizedBox()
                                : Text(
                                    data[index][2],
                                    style: const TextStyle(
                                      color: greyColor,
                                      fontSize: 14,
                                    ),
                                  ),
                          ],
                          prefixWidget: Container(
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: transparent,
                            ),
                            child: Image.asset(
                              data[index][0],
                            ),
                          ),
                          suffixWidget: Container(
                              height: 30,
                              width: 30,
                              child: const Icon(
                                FontAwesomeIcons.chevronRight,
                                size: 17,
                              )),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          changeBackground: transparent,
                        ),
                        buildDivider(color: greyColor)
                      ],
                    ))),
      ],
    );
  }
}
