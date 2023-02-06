import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../../widget/button_primary.dart';
import '../../../../widget/image_cache.dart';

class MainMarketBody extends StatelessWidget {
  late double width = 0;

  late double height = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus!.unfocus();
      }),
      child: Stack(
        children: [
          Column(children: [
            // main content
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // color: Colors.grey[900],
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    // buy and category
                    Container(
                        height: 40,
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonPrimary(
                                width: width / 2 - 30,
                                label: "Bán",
                                icon: Icon(
                                  Icons.usb_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                radius: 25,
                              ),
                              ButtonPrimary(
                                width: width / 2 - 30,
                                label: "Hạng mục",
                                icon: Icon(
                                  Icons.usb_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                radius: 25,
                              ),
                            ])),
                    buildDivider(color: Colors.black),

                    buildSpacer(height: 10),

                    // suggest product
                    _buildTitleAndSeeAll("Gợi ý cho bạn",
                        suffixWidget: buildTextContent(
                          "Xem tất cả",
                          false,
                          fontSize: 14,
                          colorWord: greyColor,
                        ),
                        iconData: FontAwesomeIcons.angleRight),
                    Container(
                      height: 420,
                      margin: const EdgeInsets.only(top: 10),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9),
                          itemCount: MainMarketBodyConstants
                              .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                  "data"]
                              .length,
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = MainMarketBodyConstants
                                    .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                "data"];
                            return _buildProductItem(
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
                    _buildTitleAndSeeAll(
                      "Khám phá Sản phẩm",
                    ),
                    Container(
                      height: 420,
                      margin: const EdgeInsets.only(top: 10),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9),
                          itemCount: MainMarketBodyConstants
                              .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                  "data"]
                              .length,
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = MainMarketBodyConstants
                                    .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                "data"];
                            return _buildProductItem(
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
          ]),
        ],
      ),
    );
  }
}

_buildTextMarketPlace(String title,
    {Color? color = secondaryColor,
    double? fontSize = 14,
    TextAlign? textAlign = TextAlign.center}) {
  return Text(
    title,
    maxLines: 2,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(color: color!, fontSize: fontSize),
  );
}

_buildProductItem(String imgPath, double width, String title,
    List<dynamic> price, int rate, int selled) {
  return Container(
    // width:300,
    margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3),
    height: 200,
    decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.2, color: greyColor.shade200)),
    child: Container(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //img
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: ImageCacheRender(
                path: imgPath,
                height: 120.0,
                width: width,
              ),
            ),
            // title
            _buildTextMarketPlace(title, fontSize: 14, color: Colors.black),
            // price
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: _buildTextMarketPlace(
                      "₫${price[0].toString()} ${price[1] != null ? "- ₫${price[1].toString()}" : ""}",
                      fontSize: 15,
                      color: Colors.red,
                      textAlign: TextAlign.left),
                ),
              ],
            )
          ],
        )),
        // rate and selled
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  children: List.generate(5, (indexList) {
                return Container(
                    height: 10,
                    margin: const EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.star,
                      color: rate >= indexList ? Colors.yellow : white,
                      size: 12,
                    ));
              }).toList()),
              Container(
                child: _buildTextMarketPlace("đã bán ${selled}",
                    color: blackColor, fontSize: 13),
              )
            ],
          ),
        )
      ]),
    ),
  );
}

_buildTitleAndSeeAll(String title, {Widget? suffixWidget, IconData? iconData}) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTextContent(
          title,
          true,
          fontSize: 22,
          colorWord: secondaryColor,
        ),
        Row(
          children: [
            suffixWidget ?? SizedBox(),
            iconData != null
                ? Icon(
                    iconData,
                    color: greyColor,
                    size: 14,
                  )
                : SizedBox()
          ],
        ),
      ],
    ),
  );
}

demoFunction() {}
