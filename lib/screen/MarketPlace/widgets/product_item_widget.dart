import 'package:flutter/material.dart';

import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../widget/image_cache.dart';
import '../screen/detail_product_market_page.dart';
import 'package:loader_skeleton/loader_skeleton.dart';

buildProductItem(BuildContext context, int id, String imgPath, double width,
    String title, List<dynamic> price, int rate, int selled) {
  return InkWell(
    onTap: () {
      pushToNextScreen(context, DetailProductMarketPage(id: id));
    },
    // child: CardSkeleton(
    //   isCircularImage: true,
    //   isBottomLinesActive: true,
      child:
       Container(
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
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2
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



  List<Map<String, dynamic>> _categoryControllers = [
    {
      "category": TextEditingController(text: ""),
      "description_category": [
        {
          "main": TextEditingController(text: ""),
          "price": TextEditingController(text: ""),
          "repository": TextEditingController(text: ""),
          "sku": TextEditingController(text: ""),
        },
        {
          "main": TextEditingController(text: ""),
          "price": TextEditingController(text: ""),
          "repository": TextEditingController(text: ""),
          "sku": TextEditingController(text: ""),
        }
      ]
    },
   
  ];