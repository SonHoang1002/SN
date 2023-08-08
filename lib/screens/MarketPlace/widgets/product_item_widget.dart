import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/rating_star_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import '../../../theme/colors.dart';

Widget buildProductItem(
    {required BuildContext context,
    required dynamic data,
    bool? isHaveFlagship = false,
    dynamic saleBanner,
    bool? isVertical = true}) {
  final List<dynamic> prices =
      getMinAndMaxPrice(data?["product_variants"] ?? []);
      final size =  MediaQuery.sizeOf(context);
  double childWidth = size.width * 0.45;
  return InkWell(
    onTap: () {
      pushToNextScreen(
          context,
          DetailProductMarketPage(
            simpleData: data,
            id: data["id"],
          ));
    },
    child: isVertical!
        ? Stack(
            children: [
              Container(
                height: 250,
                width: childWidth,
                margin:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.4, color: greyColor)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //img
                          Container(
                            height: 120.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  child: ExtendedImage.network(
                                    !(data?["product_image_attachments"])
                                                .isEmpty &&
                                            (data?["product_image_attachments"]) !=
                                                null
                                        ?(data?["product_image_attachments"]?[0]?["attachment"]?["url"]).toString()
                                        : "https://i.pinimg.com/474x/14/c6/d3/14c6d321c7f16a73be476cd9dcb475af.jpg",
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                    width: childWidth,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    saleBanner != null
                                        ? ExtendedImage.network(
                                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQ0Ie-XbqxW-xgO-6Z5GHrhUDUbAkDu-TWDQp5XmOa&s",
                                            height: 20,
                                            fit: BoxFit.fill,
                                            width: 130,
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // title
                          buildSpacer(height: 5),
                          Container(
                            height: 40,
                            width: childWidth,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: buildTextContent(data?["title"], false,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2),
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
                            buildRatingStarWidget(data?["rating"]),
                            Container(
                              child: buildTextContent(
                                  "đã bán ${data?["sold"]}", false,
                                  fontSize: 13),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
              isHaveFlagship!
                  ? Container(
                      // color: red,
                      // height: 20,
                      // width: 20,
                      margin: const EdgeInsets.only(left: 3, top: 3),
                      child: ExtendedImage.asset(
                        "assets/icons/flagship.png",
                        height: 40,
                      ),
                    )
                  : const SizedBox()
            ],
          )
        : Stack(
            children: [
              Container(
                height: 110,
                width: size.width,
                margin:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.4, color: greyColor)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 110.0,
                        width: 110.0,
                        child: Stack(
                          children: [
                            //image
                            ExtendedImage.network(
                              !(data?["product_image_attachments"]).isEmpty &&
                                      (data?["product_image_attachments"]) !=
                                          null
                                  ? (data?["product_image_attachments"]?[0]
                                      ?["attachment"]?["url"])
                                  : "https://i.pinimg.com/474x/14/c6/d3/14c6d321c7f16a73be476cd9dcb475af.jpg",
                              height: 110.0,
                              fit: BoxFit.cover,
                              width: childWidth,
                            ),
                            // sale banner
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                saleBanner != null
                                    ? ExtendedImage.network(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQ0Ie-XbqxW-xgO-6Z5GHrhUDUbAkDu-TWDQp5XmOa&s",
                                        height: 20,
                                        fit: BoxFit.fill,
                                        width: 130,
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          ],
                        ),
                      ),
                      buildSpacer(width: 10),
                      Flexible(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: buildTextContent(
                                  (data?["title"]) ?? "",
                                  false,
                                  fontSize: 15,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              buildSpacer(height: 10),
                              Container(
                                child: buildTextContent(
                                    "Bán mỗi tháng ${Random().nextInt(12)}",
                                    false,
                                    fontSize: 13,
                                    colorWord: secondaryColor),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
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
                      )),
                    ]),
              ),
              isHaveFlagship!
                  ? Container(
                      margin: const EdgeInsets.only(left: 3, top: 3),
                      child: ExtendedImage.asset(
                        "assets/icons/flagship.png",
                        height: 40,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
  );
}

Widget buildSeeAllProductItem({required BuildContext context}) {
  final size = MediaQuery.sizeOf(context);
  double childWidth = size.width * 0.45;
  return InkWell(
    onTap: () {
      // pushToNextScreen(
      //     context,
      //     DetailProductMarketPage(
      //       simpleData: data,
      //       id: data["id"],
      //     ));
    },
    child: Stack(
      children: [
        Container(
            height: 250,
            width: childWidth,
            margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.chevronRight,
                  color: red,
                  size: 20,
                ),
                buildSpacer(height: 10),
                buildTextContent("Xem tất cả", false,
                    colorWord: red, fontSize: 12, isCenterLeft: false)
              ],
            )),
      ],
    ),
  );
}
