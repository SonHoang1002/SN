import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

Widget buildOrderItem(dynamic productData) {
  return Column(children: [
    // cac san pham
    buildDivider(color: greyColor[700], right: 40, left: 40),
    Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                ExtendedImage.network(
                  productData?["product_variant"] != null &&
                          productData?["product_variant"].isNotEmpty
                      ? productData?["product_variant"]?["image"] != null
                          ? (productData?["product_variant"]?["image"]
                                  ?["url"]) ??
                              (productData?["product_variant"]?["image"]
                                  ?["preview_url"])
                          : "https://kynguyenlamdep.com/wp-content/uploads/2022/01/hinh-anh-meo-con-sieu-cute-700x467.jpg"
                      : "https://kynguyenlamdep.com/wp-content/uploads/2022/01/hinh-anh-meo-con-sieu-cute-700x467.jpg",
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
                buildSpacer(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent(
                          (productData?["product_variant"]?["title"])??"--", false,
                          fontSize: 15,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      buildSpacer(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextContent(
                            productData?["product_variant"]?["option1"] == null &&
                                    productData?["product_variant"]?["option2"] ==
                                        null
                                ? "Không phân loại"
                                : productData["product_variant"]
                                        // ignore: prefer_interpolation_to_compose_strings
                                        ["option1"] ??
                                    // ignore: prefer_interpolation_to_compose_strings
                                    ("" +
                                                (productData?["product_variant"]
                                                    ?["option2"]) !=
                                            null
                                        ? (productData?["product_variant"]
                                            ?["option2"])
                                        : ""),
                            false,
                            colorWord: greyColor[700],
                            fontSize: 13,
                          ),
                          buildTextContent(
                            "x${productData["quantity"].toString()}",
                            false,
                            colorWord: greyColor[700],
                            fontSize: 13,
                          ),
                        ],
                      ),
                      buildSpacer(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          buildTextContent(
                            "₫${formatCurrency(productData?["product_variant"]?["price"])}",
                            false,
                            colorWord: greyColor[700],
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    )
  ]);
}
