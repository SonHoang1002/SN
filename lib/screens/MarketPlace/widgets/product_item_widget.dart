import 'package:flutter/material.dart';
import 'package:market_place/constant/get_min_max_price.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/rating_star_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/image_cache.dart';
import '../../../theme/colors.dart';

Widget buildProductItem(
    {required BuildContext context, required dynamic data}) {
  final List<dynamic> prices = getMinAndMaxPrice(data["product_variants"]);
  double childWidth = MediaQuery.of(context).size.width * 0.45;
  return InkWell(
    onTap: () {
      pushToNextScreen(
          context,
          DetailProductMarketPage(
            simpleData: data,
            id: data["id"],
          ));
    },
    child: Container(
      height: 230,
      width: childWidth,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
      decoration: BoxDecoration(
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
                        ? "₫${formatCurrency(prices[0])}"
                        : "₫${formatCurrency(prices[0])} - ₫${formatCurrency(prices[1])} ",
                    true,
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
