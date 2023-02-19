import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/comment_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/detail_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/interest_product_provider.dart';
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
  final dynamic id;
  DetailProductMarketPage({required this.id});
  @override
  ConsumerState<DetailProductMarketPage> createState() =>
      _DetailProductMarketPageComsumerState();
}

class _DetailProductMarketPageComsumerState
    extends ConsumerState<DetailProductMarketPage> {
  late double width = 0;
  late double height = 0;
  // Map<String, dynamic>? _product;
  int productNumber = 1;
  int _onMorePart = 0;
  bool? _isConcern;
  Map<String, dynamic>? _detailData;
  List<dynamic>? _commentData;
  List<double>? _prices;
  bool _isLoading = true;
  List<bool>? _colorCheckList = [];
  List<bool>? _sizeCheckList = [];
  dynamic? _colorValue;
  dynamic? _sizeValue;
  String? _priceTitle;
  dynamic? _imgLink;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
    Future.delayed(Duration.zero, () async {
      final detailData = await ref
          .read(detailProductProvider.notifier)
          .getDetailProduct(widget.id);
      final comment = await ref
          .read(commentProductProvider.notifier)
          .getCommentProduct(widget.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _detailData = null;
    _commentData = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Future<int> a = _initData();
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
        body: !_isLoading
            ? _buildDetailBody()
            : Center(
                child: Container(
                  width: 70,
                  height: 70,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    strokeWidth: 3,
                  ),
                ),
              ));
  }

  Future<int> _initData() async {
    if (_detailData == null && _commentData == null) {
      final detailData = await ref
          .read(detailProductProvider.notifier)
          .getDetailProduct(widget.id);
      final comment = await ref
          .read(commentProductProvider.notifier)
          .getCommentProduct(widget.id);
    }
    _detailData = await ref.watch(detailProductProvider).detail;
    _commentData = await ref.watch(commentProductProvider).commentList;
    _prices = getMinAndMaxPrice(_detailData?["product_variants"]);
    if (_colorCheckList!.isEmpty && _sizeCheckList!.isEmpty) {
      if (_detailData?["product_options"] != null &&
          _detailData?["product_options"].isNotEmpty) {
        for (int i = 0;
            i < _detailData?["product_options"][0]["values"].length;
            i++) {
          _colorCheckList?.add(false);
        }
        if (_detailData?["product_options"].length == 2) {
          for (int i = 0;
              i < _detailData?["product_options"][1]["values"].length;
              i++) {
            _sizeCheckList?.add(false);
          }
        }
      }
    }
    _priceTitle ??= _prices?[0] == _prices?[1]
        ? "₫${_prices?[0].toString()}"
        : "₫${_prices?[0].toString()} - ₫${_prices?[1].toString()}";
    _imgLink ??= !_detailData?["product_image_attachments"].isEmpty
        ? _detailData!["product_image_attachments"][0]["attachment"]["url"]
        : "https://cdn.pixabay.com/photo/2015/11/16/14/43/cat-1045782__340.jpg";
    _isLoading = false;
    _isConcern = false;

    final primaryInterestList =
        ref.watch(interestProductsProvider).listInterest;
    if (primaryInterestList.isNotEmpty) {
      primaryInterestList.forEach(
        (element) {
          if (element["id"] == widget.id) {
            _isConcern = true;
            return;
          }
        },
      );
    }

    print("interest:${ref.watch(interestProductsProvider).listInterest}");
    setState(() {});
    return 0;
  }

  Widget _buildDetailBody() {
    if (_detailData != null && _commentData != null) {}
    return Column(
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
                      path: _imgLink,
                      height: 120.0,
                      width: width,
                    )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // selections
                      buildSpacer(height: 10),
                      _detailData?["product_variants"] != null
                          ? buildTextContent(
                              "Có ${(_detailData?["product_variants"].length)} lựa chọn khác",
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
                              _detailData?["product_variants"].length, (index) {
                            final childProducts =
                                _detailData?["product_variants"];
                            if (childProducts?[index]["image"] != null &&
                                childProducts?[index]["image"] != {}) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _imgLink =
                                        childProducts?[index]["image"]["url"];
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: ImageCacheRender(
                                      path: childProducts?[index]["image"]
                                          ["preview_url"],
                                      height: 80.0,
                                      width: 80.0,
                                    )),
                              );
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
                      buildTextContent(_detailData?["title"], true,
                          fontSize: 17),
                      // price
                      buildSpacer(height: 10),
                      buildTextContent(
                        _priceTitle ?? "₫ 0.0",
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
                                    _detailData?["rating"].round()),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: buildTextContent(
                                      "${_detailData?["rating"].round().toString()}",
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
                                      "đã bán ${_detailData?["sold"].round()}",
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
                                      _isConcern = !_isConcern!;
                                      setState(() {});
                                      if (_isConcern == true) {
                                        ref
                                            .read(interestProductsProvider
                                                .notifier)
                                            .addInterestProductItem(
                                                _detailData);
                                      } else {
                                        ref
                                            .read(interestProductsProvider
                                                .notifier)
                                            .deleleInterestProductItem(
                                                widget.id);
                                      }
                                    },
                                    child: Container(
                                      // color: Colors.red,
                                      height: 20,
                                      width: 20,
                                      child: (_isConcern!)
                                          ? const Icon(
                                              Icons.star_purple500_outlined,
                                              color: Colors.yellow,
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.star_border,
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

                      // color and size (neu co)
                      _detailData?["product_options"] != null &&
                              _detailData?["product_options"].isNotEmpty
                          ? Column(
                              children: [
                                //color
                                _buildColorOrSizeWidget(
                                    "Màu sắc",
                                    _detailData?["product_options"][0]
                                        ["values"]),
                                // size
                                _detailData?["product_options"].length == 2
                                    ? _buildColorOrSizeWidget(
                                        "Kích cỡ",
                                        _detailData?["product_options"][1]
                                            ["values"])
                                    : const SizedBox()
                              ],
                            )
                          : const SizedBox(),
                      // choose number of product
                      Container(
                        margin: const EdgeInsets.only(top: 10),
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
                                        if (productNumber > 0) {
                                          setState(() {
                                            productNumber--;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        color: primaryColor,
                                        child: const Center(
                                            child: Icon(
                                          FontAwesomeIcons.minus,
                                          size: 18,
                                        )),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      child: buildTextContent(
                                          "${productNumber}", true,
                                          isCenterLeft: false),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          productNumber++;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        color: primaryColor,
                                        child: const Center(
                                            child: Icon(
                                          FontAwesomeIcons.add,
                                          size: 18,
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " ${_detailData?["product_variants"][0]["inventory_quantity"].round()} sản phẩm có sẵn",
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
                          _onMorePart == 0
                              ? Column(children: [
                                  buildSpacer(height: 10),
                                  buildTextContent("Mô tả sản phẩm", true),
                                  buildSpacer(height: 10),
                                  buildTextContent(
                                      "${_detailData?["description"]}", false)
                                ])
                              : const SizedBox(),
                          _onMorePart == 1
                              ? Column(
                                  children: [
                                    Column(
                                      children: List.generate(10, (index) {
                                        return _buildReviewAndComment(
                                            "imgPath",
                                            "Nguyen Van A",
                                            4,
                                            "Sản phẩm này rất tuyệt vời vì nó đáp ứng được tất cả các tiêu chí mà tôi đặt ra. Thiết kế rất đẹp, chất liệu vải tốt và đường may cẩn thận. Điểm đặc biệt là sản phẩm rất tiện lợi khi sử dụng, dễ dàng để mang đi du lịch hay đi làm. Chất lượng âm thanh và độ nhạy cảm của microphone cũng rất tốt.",
                                            commentImgPath: [
                                              "https://baokhanhhoa.vn/dataimages/202010/original/images5426900_1.jpg",
                                              "https://images2.thanhnien.vn/Uploaded/chicuong/2022_11_28/hy-connected-img-1-4608.jpg"
                                            ]);
                                      }).toList(),
                                    ),
                                  ],
                                )
                              : const SizedBox()
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
    );
  }

  _updatePriceTitle() {
    if (_colorValue == null) {
      return;
    } else {
      if (_sizeValue != null) {
        _detailData?["product_variants"].forEach((element) {
          if (element["option1"] == _colorValue &&
              element["option2"] == _sizeValue) {
            _priceTitle = "₫ ${element["price"].toString()}";
          }
        });
      } else {
        _detailData?["product_variants"].forEach((element) {
          if (element["option1"] == _colorValue) {
            _priceTitle = "₫ ${element["price"].toString()}";
          }
        });
      }
    }
    setState(() {});
  }

  _updateImgLink() {
    if (_colorValue != null) {
      _detailData?["product_variants"].forEach((element) {
        if (element["option1"] == _colorValue) {
          setState(() {
            _imgLink = element["image"]["url"];
          });

          return;
        }
      });
    }
  }

  Widget _buildColorOrSizeWidget(String title, List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          Container(
              width: 80, child: buildTextContent(title, true, fontSize: 18)),
          Expanded(
              child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(data.length, (index) {
              return InkWell(
                onTap: () {
                  if (title == "Màu sắc") {
                    if (_colorCheckList!.isNotEmpty) {
                      for (int i = 0; i < _colorCheckList!.length; i++) {
                        _colorCheckList![i] = false;
                      }
                      _colorCheckList![index] = true;
                      _colorValue = data[index];
                    }
                  } else {
                    if (_sizeCheckList!.isNotEmpty) {
                      for (int i = 0; i < _sizeCheckList!.length; i++) {
                        _sizeCheckList![i] = false;
                      }
                      _sizeCheckList?[index] = true;
                      _sizeValue = data[index];
                    }
                  }

                  setState(() {});
                  _updatePriceTitle();
                  _updateImgLink();
                },
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                      color: title == "Màu sắc"
                          ? _colorCheckList!.isNotEmpty &&
                                  _colorCheckList![index]
                              ? blueColor
                              : white
                          : _sizeCheckList!.isNotEmpty && _sizeCheckList![index]
                              ? blueColor
                              : white,
                      border: Border.all(color: greyColor, width: 0.6),
                      borderRadius: BorderRadius.circular(5)),
                  // margin: EdgeInsets.only(right: 10),
                  child: buildTextContent(data[index], false, fontSize: 14),
                ),
              );
            }),
          ))
        ],
      ),
    );
  }
}

Widget _buildReviewAndComment(
    String userImgPath, String nameOfUser, int rating, String contents,
    {List<String>? commentImgPath}) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Column(children: [
      GeneralComponent(
        [
          buildTextContent(nameOfUser, false,
              colorWord: Colors.grey, fontSize: 14),
          buildSpacer(height: 5),
          buildRatingStarWidget(rating, size: 10),
        ],
        prefixWidget: Container(
          // color: red,
          height: 30,
          // width: 60,
          // padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        suffixFlexValue: 5,
        suffixWidget: Row(children: [
          const Icon(
            FontAwesomeIcons.thumbsUp,
            size: 15,
          ),
          buildSpacer(width: 5),
          buildTextContent("2", false, colorWord: greyColor, fontSize: 12),
          buildSpacer(width: 10),
          const Icon(
            FontAwesomeIcons.ellipsis,
            size: 15,
          ),
        ]),
        changeBackground: transparent,
        padding: EdgeInsets.zero,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            buildSpacer(height: 5),
            buildTextContent("Phân loại: Quần áo đen s", false,
                fontSize: 12, colorWord: greyColor),
            buildSpacer(height: 10),
            buildTextContent(contents, false, fontSize: 16),
            commentImgPath != null && commentImgPath.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  List.generate(commentImgPath.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: ImageCacheRender(
                                    path: commentImgPath[index],
                                    height: 100.0,
                                    width: 100.0,
                                  ),
                                );
                              }).toList(),
                            )),
                      ),
                      buildTextContent("17-02-2023 13:09", false,
                          fontSize: 11, colorWord: greyColor)
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
      buildSpacer(height: 10),
      buildDivider(height: 10, color: red)
    ]),
  );
}
