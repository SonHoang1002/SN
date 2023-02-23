import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/comment_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/payment_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/rating_star_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/back_icon_appbar.dart';

class DetailProductMarketPage extends ConsumerStatefulWidget {
  final dynamic data;
  DetailProductMarketPage({required this.data});
  @override
  ConsumerState<DetailProductMarketPage> createState() =>
      _DetailProductMarketPageComsumerState();
}

class _DetailProductMarketPageComsumerState
    extends ConsumerState<DetailProductMarketPage> {
  late double width = 0;
  late double height = 0;
  // Map<String, dynamic>? _product;
  int product_number = 20;
  int _onMorePart = 0;
  bool _isConcern = false;
  // bool _isRequest = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final comment = ref
          .read(commentProductProvider.notifier)
          .getCommentProduct(widget.data["id"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    final comment = ref.watch(commentProductProvider).commentList;
    print("data comments: ${comment}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(title: "Chi tiết sản phẩm"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
                color: Colors.black,
              )
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(children: [
                Container(
                  child: Column(children: [
                    // img
                    Container(
                        height: 350,
                        width: width,
                        child: ImageCacheRender(
                          path: !widget
                                  .data["product_image_attachments"].isEmpty
                              ? widget.data["product_image_attachments"][0]
                                  ["attachment"]["url"]
                              : "https://cdn.pixabay.com/photo/2015/11/16/14/43/cat-1045782__340.jpg",
                          height: 120.0,
                          width: width,
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // color or size, ...
                          buildSpacer(height: 10),
                          widget.data?["product_variants"] != null
                              ? buildTextContent(
                                  "Có ${(widget.data?["product_variants"].length)} lựa chọn khác",
                                  false,
                                  fontSize: 15)
                              : const SizedBox(),
                          buildSpacer(height: 10),
                          // example color or size product

                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  widget.data?["product_variants"].length,
                                  (index) {
                                final childProducts =
                                    widget.data?["product_variants"];
                                if (childProducts?[index]["image"] != null &&
                                    childProducts?[index]["image"] != {}) {
                                  return Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: ImageCacheRender(
                                        path: childProducts?[index]["image"]
                                            ["url"],
                                        height: 80.0,
                                        width: 80.0,
                                      ));
                                } else {
                                  return Container(
                                    height: 80,
                                    width: 80,
                                    color: greyColor,
                                  );
                                }
                              }).toList(),
                            ),
                          ),

                          buildSpacer(height: 10),
                          buildDivider(
                            color: secondaryColor,
                          ),
                          // title
                          buildSpacer(height: 10),
                          buildTextContent(widget.data?["title"], true,
                              fontSize: 17),
                          // price
                          buildSpacer(height: 10),
                          buildTextContent(
                            "₫${widget.data?["product_variants"][0]["price"].toString()} ",
                            true,
                            fontSize: 18,
                            colorWord: Colors.red,
                          ),
                          //rate, selled and heart, share,
                          buildSpacer(height: 20),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    buildRatingStarWidget(
                                        widget.data?["rating"].round()),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 5),
                                      child: buildTextContent(
                                          "${widget.data?["rating"].round().toString()}",
                                          false,
                                          fontSize: 18),
                                    ),
                                    Container(
                                      width: 2,
                                      color: Colors.red,
                                      height: 15,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: buildTextContent(
                                          "đã bán ${widget.data?["sold"].round()}",
                                          false,
                                          fontSize: 15),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      padding: const EdgeInsets.only(left: 5),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //heart
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isConcern = !_isConcern;
                                          });
                                        },
                                        child: Container(
                                          // color: Colors.red,
                                          height: 20,
                                          width: 20,
                                          child: Icon(
                                            !_isConcern
                                                ? Icons.star_purple500_outlined
                                                : Icons.star_border,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      //share
                                      Container(
                                        // color: Colors.green,
                                        height: 20,
                                        width: 20,
                                        child: const Icon(
                                          FontAwesomeIcons.envelope,
                                          size: 20,
                                        ),
                                      ),
                                      //heart
                                      Container(
                                        // color: Colors.red,
                                        height: 20,
                                        width: 20,
                                        child: const Icon(
                                          FontAwesomeIcons.share,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // choose number of product
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: buildTextContent(
                                      "Số lượng:",
                                      true,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.4)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (product_number > 0) {
                                              setState(() {
                                                product_number--;
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            color: primaryColor,
                                            child: const Center(
                                                child: Icon(
                                                    FontAwesomeIcons.minus)),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          child: buildTextContent(
                                              "${product_number}", true,
                                              isCenterLeft: false),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              product_number++;
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            color: primaryColor,
                                            child: const Center(
                                                child:
                                                    Icon(FontAwesomeIcons.add)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${widget.data?["product_variants"][0]["inventory_quantity"].round()} sản phẩm có sẵn",
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          // tab bar
                          buildSpacer(height: 10),
                          Column(
                            children: [
                              Container(
                                color: Colors.blue,
                                height: 2,
                              ),
                              Row(
                                children: List.generate(
                                    DetailProductMarketConstants
                                        .DETAIL_PRODUCT_MARKET_CONTENTS.length,
                                    (index) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _onMorePart = index;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          // margin: EdgeInsets.only(right:),
                                          width: width / 4.25,
                                          color: _onMorePart == index
                                              ? Colors.blue
                                              : transparent,
                                          child: buildTextContent(
                                            DetailProductMarketConstants
                                                    .DETAIL_PRODUCT_MARKET_CONTENTS[
                                                index],
                                            false,
                                            isCenterLeft: false,
                                            fontSize: 13,
                                            function: () {
                                              setState(() {
                                                _onMorePart = index;
                                              });
                                            },
                                          ),
                                        ))),
                              ),
                              buildDivider(height: 10, color: Colors.red),
                              // _onMorePart == 0
                              //     ? Column(
                              //         children: [
                              //           buildSpacer(height: 10),
                              //           buildTextContent(
                              //               "Mô tả sản phẩm", true),
                              //           buildSpacer(height: 10),
                              //           Column(
                              //             children: List.generate(
                              //                 _product?["description"].length,
                              //                 (index) {
                              //               return Container(
                              //                 margin:
                              //                     EdgeInsets.only(bottom: 5),
                              //                 child: buildTextContent(
                              //                     "${_product?["description"][index]}",
                              //                     false),
                              //               );
                              //             }),
                              //           )
                              //         ],
                              //       )
                              //     : SizedBox(),
                              // _onMorePart == 1
                              //     ? Column(
                              //         children: List.generate(
                              //             _product?["reviews"].length, (index) {
                              //           return _buildReviewAndComment(
                              //               _product?["reviews"][index]
                              //                   ["username"],
                              //               _product?["reviews"][index]
                              //                   ["username"],
                              //               _product?["reviews"][index]
                              //                   ["rating"],
                              //               _product?["reviews"][index]
                              //                   ["comment"]);
                              //         }).toList(),
                              //       )
                              //     : SizedBox()
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ]),
            ),
            // add to cart and buy now
            Container(
              // height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: buildButtonForMarketWidget(
                        width: width * 0.6,
                        bgColor: Colors.orange[300],
                        title: "Thêm vào giỏ hàng",
                        iconData: FontAwesomeIcons.cartArrowDown,
                        function: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            "Thêm vào giỏ hàng thành công",
                            style: TextStyle(color: Colors.green),
                          )));
                          pushToNextScreen(context, CartMarketPage());
                        }),
                  ),
                  Container(
                    // margin: EdgeInsets.only(right: 10),
                    child: buildButtonForMarketWidget(
                        width: width * 0.3,
                        bgColor: Colors.red,
                        title: "Mua ngay",
                        function: () {
                          pushToNextScreen(context, const PaymentMarketPage());
                        }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // _findData(String id) {
  //   final datas = MainMarketBodyConstants
  //       .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS["data"];
  //   for (int i = 0; i < datas.length; i++) {
  //     if (datas[i]["id"] == id) {
  //       setState(() {
  //         _product = datas[i];
  //       });
  //       return;
  //     }
  //   }
  // }
}

Widget _buildReviewAndComment(
    String imgPath, String nameOfUser, int rating, String contents) {
  return Container(
    child: Column(children: [
      GeneralComponent(
        [
          buildTextContent(nameOfUser, false,
              colorWord: Colors.grey, fontSize: 13),
          buildSpacer(height: 5),
          buildRatingStarWidget(rating, size: 10),
        ],
        prefixWidget: Container(
          height: 40,
          // width: 60,
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 20,
                width: 20,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                        MarketPlaceConstants.PATH_IMG + "cat_1.png")),
              ),
              const SizedBox()
            ],
          ),
        ),
        suffixFlexValue: 2,
        suffixWidget: Row(children: const [
          Icon(
            FontAwesomeIcons.ellipsis,
            color: blackColor,
            size: 15,
          )
        ]),
        changeBackground: transparent,
        padding: EdgeInsets.zero,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: buildTextContent(contents, false, fontSize: 12),
      ),
      buildDivider(height: 10, color: red)
    ]),
  );
}
