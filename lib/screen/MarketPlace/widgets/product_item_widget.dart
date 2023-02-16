import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page_old.dart';

import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../widget/image_cache.dart';
import 'package:loader_skeleton/loader_skeleton.dart';

buildOldProductItem(
    {required BuildContext context,
    required String id,
    required String imgPath,
    required double width,
    required String title,
    required List<dynamic> price,
    required int rate,
    required int selled}) {
  return InkWell(
    onTap: () {
      pushToNextScreen(context, OldDetailProductMarketPage(id: id));
    },
    // child: CardSkeleton(
    //   isCircularImage: true,
    //   isBottomLinesActive: true,
    child: Container(
      height: 250,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3),
      decoration: BoxDecoration(
          // color: greyColor.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.4, color: greyColor)),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //img
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: ImageCacheRender(
                      path: imgPath,
                      height: 120.0,
                      width: width,
                    ),
                  ),
                  // title
                  buildSpacer(height: 5),
                  buildTextContent(title, false,
                      fontSize: 15, overflow: TextOverflow.ellipsis, maxLines: 2
                      //  color: Colors.black
                      ),
                  // price
                  buildSpacer(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: buildTextContent(
                          "₫${price[0].toString()} ${price[1] != null ? "- ₫${price[1].toString()}" : ""}",
                          false,
                          fontSize: 15,
                          colorWord: red,
                        ),
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
                            color: rate - 1 >= indexList
                                ? Colors.yellow[700]
                                : greyColor,
                            size: 12,
                          ));
                    }).toList()),
                    Container(
                      child: buildTextContent("đã bán ${selled}", false,
                          // color: blackColor,
                          fontSize: 13),
                    )
                  ],
                ),
              )
            ]),
      ),
    ),
    // ),
  );
}

buildProductItem(
    {required BuildContext context,
    required double width,
    required dynamic data}) {
  return InkWell(
    onTap: () {
      pushToNextScreen(
          context,
          DetailProductMarketPage(
            data: data,
          ));
    },
    // child: CardSkeleton(
    //   isCircularImage: true,
    //   isBottomLinesActive: true,
    child: Container(
      height: 250,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3),
      decoration: BoxDecoration(
          // color: greyColor.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.4, color: greyColor)),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //img

                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: ImageCacheRender(
                      path: !data["product_image_attachments"].isEmpty
                          ? data["product_image_attachments"][0]["attachment"]
                              ["url"]
                          : "https://i.pinimg.com/474x/14/c6/d3/14c6d321c7f16a73be476cd9dcb475af.jpg",
                      height: 120.0,
                      width: width,
                    ),
                  ),
                  // title
                  buildSpacer(height: 5),
                  Container(
                    child: buildTextContent(data?["title"], false,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  // price
                  buildSpacer(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: buildTextContent(
                          "₫${data?["product_variants"][0]["price"].toString()}",
                          false,
                          fontSize: 15,
                          colorWord: red,
                        ),
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
                            color: data?["rating"] - 1 >= indexList
                                ? Colors.yellow[700]
                                : greyColor,
                            size: 12,
                          ));
                    }).toList()),
                    Container(
                      child: buildTextContent("đã bán ${data?["sold"]}", false,
                          // color: blackColor,
                          fontSize: 13),
                    )
                  ],
                ),
              )
            ]),
      ),
    ),
    // ),
  );
}
