import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/get_min_max_price.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/rating_star_widget.dart';

import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../widget/image_cache.dart';
Widget buildProductItem(
    {required BuildContext context,
    required double width,
    required dynamic data}) {
  final List<dynamic> prices = getMinAndMaxPrice(data["product_variants"]);
  double childWidth = width * 0.45;
  return InkWell(
    onTap: () {
      pushToNextScreen(
          context,
          DetailProductMarketPage(
            id: data["id"],
          ));
    },
    child: Container(
      height: 230,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
      decoration: BoxDecoration(
          // color: greyColor.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.4, color: greyColor)),
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
                path: !data["product_image_attachments"].isEmpty &&
                        data["product_image_attachments"] != null
                    ? data["product_image_attachments"][0]["attachment"]["url"]
                    : "https://i.pinimg.com/474x/14/c6/d3/14c6d321c7f16a73be476cd9dcb475af.jpg",
                height: 120.0,
                width: childWidth,
              ),
            ),
            // title
            buildSpacer(height: 5),
            Container(
              height: 40,
              width: childWidth,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: buildTextContent(data?["title"], false,
                  fontSize: 15, overflow: TextOverflow.ellipsis, maxLines: 2),
            ),
            // price
            buildSpacer(height: 5),
            Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: buildTextContent(
                    prices[0] == prices[1]
                        ? "₫${prices[0].toString()}"
                        : "₫${prices[0].toString()} - ₫${prices[1].toString()} ",
                    false,
                    fontSize: 13,
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
          height: 20,
          width: childWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRatingStarWidget(data?["rating_count"]),
              Container(
                child: buildTextContent("đã bán ${data?["sold"]}", false,
                    fontSize: 13),
              )
            ],
          ),
        )
      ]),
    ),
  );
}