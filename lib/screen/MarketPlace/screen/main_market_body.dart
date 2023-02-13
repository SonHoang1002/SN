import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/see_more_market_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../../widget/button_primary.dart';
import '../../../../widget/image_cache.dart';
import '../widgets/product_item_widget.dart';
import 'detail_product_market_page.dart';

class MainMarketBody extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Stack(
      children: [
        Column(children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // color: Colors.grey[900],
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // buy and category
                    // tim lai o test.dart
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                MainMarketBodyConstants
                                    .MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS[
                                        "data"]
                                    .length, (index) {
                              final data = MainMarketBodyConstants
                                      .MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS[
                                  "data"];
                              return Container(
                                height: 120,
                                width: 100,
                                margin: const EdgeInsets.only(right: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: greyColor, width: 0.4)),
                                child: Column(
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 60,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.asset(
                                                data[index]["icon"]))),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: buildTextContent(
                                          data[index]["title"], true,
                                          fontSize: 15,
                                          maxLines: 2,
                                          isCenterLeft: false),
                                    )
                                  ],
                                ),
                              );
                            }),
                          )),
                    ),
                    // suggest product
                    _buildTitleAndSeeAll(
                      "Gợi ý cho bạn",
                      suffixWidget: buildTextContent("Xem tất cả", false,
                          fontSize: 14, colorWord: greyColor, function: () {
                        pushToNextScreen(context, SeeMoreMarketPage());
                      }),
                      iconData: FontAwesomeIcons.angleRight,
                    ),
                    SingleChildScrollView(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  crossAxisCount: 2,
                                  // childAspectRatio: 0.79),
                                  childAspectRatio: 0.8),
                          itemCount: MainMarketBodyConstants
                              .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                  "data"]
                              .length,
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = MainMarketBodyConstants
                                    .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                "data"];
                            return buildProductItem(
                                context,
                                data[index]["id"],
                                data[index]["img"],
                                width,
                                data[index]["title"],
                                [
                                  data[index]["min_price"],
                                  data[index]["max_price"] != null
                                      ? data[index]["max_price"]
                                      : null
                                ],
                                data[index]["rate"],
                                data[index]["selled"]);
                          }),
                    ),
                    buildSpacer(height: 10),
                    _buildTitleAndSeeAll("Khám phá sản phẩm",
                        suffixWidget:
                            buildTextContent("Lọc", false, function: () {
                          showBottomSheetCheckImportantSettings(
                              context, 400, "Sắp xếp theo",
                              bgColor: greyColor[400],
                              widget: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: MainMarketBodyConstants
                                      .MAIN_MARKETPLACE_BODY_SORT_SELECTIONS[
                                          "data"]
                                      .length,
                                  itemBuilder: (context, index) {
                                    final data = MainMarketBodyConstants
                                            .MAIN_MARKETPLACE_BODY_SORT_SELECTIONS[
                                        "data"];
                                    return Column(
                                      children: [
                                        GeneralComponent(
                                          [
                                            buildTextContent(
                                                data[index]["title"], true,
                                                fontSize: 17),
                                          ],
                                          changeBackground: transparent,
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        buildDivider(color: red),
                                        data[index]["sub_selections"] != null
                                            ? Column(
                                                children: [
                                                  GeneralComponent(
                                                    [
                                                      buildTextContent(
                                                          data[index][
                                                              "sub_selections"][0],
                                                          true,
                                                          fontSize: 17),
                                                    ],
                                                    changeBackground:
                                                        transparent,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                  ),
                                                  buildDivider(color: red),
                                                  GeneralComponent(
                                                    [
                                                      buildTextContent(
                                                          data[index][
                                                              "sub_selections"][1],
                                                          true,
                                                          fontSize: 17),
                                                    ],
                                                    changeBackground:
                                                        transparent,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                  ),
                                                  buildDivider(color: red),
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    );
                                  }));
                        }),
                        iconData: FontAwesomeIcons.filter),

                    SingleChildScrollView(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8),
                          itemCount: MainMarketBodyConstants
                              .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                  "data"]
                              .length,
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = MainMarketBodyConstants
                                    .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                "data"];
                            return buildProductItem(
                                context,
                                data[index]["id"],
                                data[index]["img"],
                                width,
                                data[index]["title"],
                                [
                                  data[index]["min_price"],
                                  data[index]["max_price"] != null
                                      ? data[index]["max_price"]
                                      : null
                                ],
                                data[index]["rate"],
                                data[index]["selled"]);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}


_buildTitleAndSeeAll(String title, {Widget? suffixWidget, IconData? iconData}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTextContent(
          title,
          true,
          fontSize: 22,
          // colorWord: blackColor,
        ),
        Row(
          children: [
            suffixWidget ?? const SizedBox(),
            buildSpacer(width: 5),
            iconData != null
                ? Icon(
                    iconData,
                    color: greyColor,
                    size: 14,
                  )
                : const SizedBox()
          ],
        ),
      ],
    ),
  );
}
