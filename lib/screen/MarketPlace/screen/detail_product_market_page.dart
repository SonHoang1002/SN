import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/cart_apis.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/review_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/detail_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/interest_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/payment_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/rating_star_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/review_item_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/share_and_search_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../widget/GeneralWidget/circular_progress_indicator.dart';
import 'cart_market_page.dart';

const String LINK = "link";
const String SHARE_ON_STORY_TABLE = "share_on_story_table";
const String SHARE_ON_GROUP = "share_on_group";
const String SHARE_ON_PERSONAL_PAGE_OF_FRIEND =
    "share_on_personal_page_of_friend";
class DetailProductMarketPage extends ConsumerStatefulWidget {
  final dynamic id;
  const DetailProductMarketPage({
    super.key,
    required this.id,
  });
  @override
  ConsumerState<DetailProductMarketPage> createState() =>
      _DetailProductMarketPageComsumerState();
}
class _DetailProductMarketPageComsumerState
    extends ConsumerState<DetailProductMarketPage> {
  late double width = 0;
  late double height = 0;
  int productNumber = 1;
  int _onMorePart = 0;
  bool? _isConcern;
  Map<String, dynamic>? _detailData;
  List<dynamic>? _commentData;
  List<dynamic>? _prices;
  bool _isLoading = true;
  final List<bool> _colorCheckList = [];
  final List<bool> _sizeCheckList = [];
  dynamic _colorValue;
  dynamic _sizeValue;
  String? _priceTitle;
  dynamic _imgChildLink;
  dynamic _productToCart;
  List<dynamic>? mediaList = [];
  int mediaIndex = 0;
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
          .read(reviewProductProvider.notifier)
          .getReviewProduct(widget.id);
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
            : buildCircularProgressIndicator());
  }

  Future<int> _initData() async {
    // khoi tao general data
    if (_detailData == null && _commentData == null) {
      final detailData = await ref
          .read(detailProductProvider.notifier)
          .getDetailProduct(widget.id);
      final comment = await ref
          .read(reviewProductProvider.notifier)
          .getReviewProduct(widget.id);
    }
    _detailData = await ref.watch(detailProductProvider).detail;
    _commentData = await ref.watch(reviewProductProvider).commentList;
    _prices = getMinAndMaxPrice(_detailData?["product_variants"]);

    // khoi tao color and size neu co
    if (_colorCheckList.isEmpty && _sizeCheckList.isEmpty) {
      if (_detailData?["product_options"] != null &&
          _detailData?["product_options"].isNotEmpty) {
        for (int i = 0;
            i < _detailData?["product_options"][0]["values"].length;
            i++) {
          _colorCheckList.add(false);
        }
        if (_detailData?["product_options"].length == 2) {
          for (int i = 0;
              i < _detailData?["product_options"][1]["values"].length;
              i++) {
            _sizeCheckList.add(false);
          }
        }
      }
    }
    if (_detailData?["product_variants"] != null ||
        _detailData?["product_variants"].isNotEmpty) {
      _priceTitle ??=
          "₫${_detailData?["product_variants"][0]["price"].toString()}";
    } else {
      _priceTitle ??= "₫0";
    }

    if (mediaList == null || mediaList!.isEmpty) {
      if (_detailData!["product_video"] != null) {
        mediaList?.add(_detailData!["product_video"]["url"]);
      }
      if (_detailData!["product_image_attachments"] != null &&
          _detailData!["product_image_attachments"].isNotEmpty) {
        _detailData!["product_image_attachments"].forEach((element) {
          mediaList?.add(element["attachment"]["url"]);
        });
      }
    }
    // khoi tao concern
    _isConcern = false;
    final primaryInterestList =
        ref.watch(interestProductsProvider).listInterest;
    if (primaryInterestList.isNotEmpty) {
      for (var element in primaryInterestList) {
        if (element["id"] == widget.id) {
          _isConcern = true;
          continue;
        }
      }
    }
    _productToCart = _detailData!["product_variants"][0];
    // load xong
    _isLoading = false;
    setState(() {});
    return 0;
  }

  Widget _buildDetailBody() {
    if (_detailData != null && _commentData != null) {}
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              // img
              Stack(
                children: [
                  SizedBox(
                      height: 350,
                      width: width,
                      child: _imgChildLink != null
                          ? ImageCacheRender(
                              path: _imgChildLink,
                            )
                          : mediaList![mediaIndex]?.endsWith('.mp4')
                              ? Container(
                                  height: 300,
                                  width: width,
                                  // color: red,
                                  child: SizedBox(
                                    height: 300,
                                    child: VideoPlayerRender(
                                      path: mediaList![mediaIndex],
                                      autoPlay: true,
                                    ),
                                  ))
                              : ImageCacheRender(
                                  path: mediaList![mediaIndex],
                                )),
                  SizedBox(
                    height: 350,
                    width: width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mediaIndex != 0 && mediaIndex != -1
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      mediaIndex--;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        color: red.withOpacity(0.5),
                                        child: const Icon(
                                          FontAwesomeIcons.chevronLeft,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          mediaIndex != mediaList!.length - 1 &&
                                  mediaIndex != -1
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        mediaIndex++;
                                      });
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        color: red.withOpacity(0.5),
                                        child: const Icon(
                                          FontAwesomeIcons.chevronRight,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ]),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // selections title
                    buildSpacer(height: 10),
                    _detailData?["product_image_attachments"] != null
                        ? buildTextContent(
                            "Có ${(_detailData!["product_video"] != null ? mediaList!.length - 1 : mediaList!.length)} lựa chọn khác",
                            false,
                            fontSize: 15)
                        : const SizedBox(),
                    buildSpacer(height: 10),
                    // example color or size product
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(mediaList!.length, (index) {
                          return InkWell(
                            onTap: () {
                              if (_colorValue == null || _colorValue == "") {
                                setState(() {
                                  mediaIndex = index;
                                });
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: mediaIndex == index
                                        ? Border.all(color: red, width: 0.6)
                                        : null),
                                margin: const EdgeInsets.only(right: 10),
                                child: mediaList![index].endsWith(".mp4")
                                    ? SizedBox(
                                        height: 120,
                                        width: 180,
                                        child: VideoPlayerRender(
                                            path: mediaList![index]))
                                    : ImageCacheRender(
                                        path: mediaList![index],
                                        height: 120.0,
                                        width: 120.0,
                                      )),
                          );
                        }).toList(),
                      ),
                    ),
                    buildSpacer(height: 10),
                    buildDivider(
                      color: secondaryColor,
                    ),
                    // title
                    buildSpacer(height: 10),
                    buildTextContent(_detailData?["title"], true, fontSize: 17),
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
                                  _detailData?["rating_count"]),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 5),
                                child: buildTextContent(
                                    "${_detailData?["rating_count"].toString()}",
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //heart
                                InkWell(
                                  onTap: () {
                                    _isConcern = !_isConcern!;
                                    setState(() {});
                                    if (_isConcern == true) {
                                      ref
                                          .read(
                                              interestProductsProvider.notifier)
                                          .addInterestProductItem(_detailData);
                                    } else {
                                      ref
                                          .read(
                                              interestProductsProvider.notifier)
                                          .deleleInterestProductItem(widget.id);
                                    }
                                  },
                                  child: SizedBox(
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
                                const SizedBox(
                                  // color: Colors.green,
                                  height: 20,
                                  width: 20,
                                  child: Icon(
                                    FontAwesomeIcons.envelope,
                                    size: 20,
                                  ),
                                ),
                                //heart
                                InkWell(
                                  onTap: () {
                                    _showShareDetailBottomSheet(context);
                                  },
                                  child: const SizedBox(
                                    // color: Colors.red,
                                    height: 20,
                                    width: 20,
                                    child: Icon(
                                      FontAwesomeIcons.share,
                                      size: 20,
                                    ),
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
                              _buildColorOrSizeWidget("Màu sắc",
                                  _detailData?["product_options"][0]["values"]),
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
                                  SizedBox(
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
                        // tabbar
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
                                    width: width / 4.25,
                                    color: _onMorePart == index
                                        ? Colors.blue
                                        : transparent,
                                    child: buildTextContentButton(
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
                                    children: _commentData != null &&
                                            _commentData!.isNotEmpty
                                        ? List.generate(_commentData!.length,
                                            (index) {
                                            final data = _commentData![index];
                                            return buildReviewItemWidget(
                                                context, _commentData![index]);
                                          }).toList()
                                        : [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: buildTextContent(
                                                  "Không có bài đánh giá nào",
                                                  true,
                                                  fontSize: 17,
                                                  isCenterLeft: false),
                                            )
                                          ],
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
        ),
        // add to cart and buy now
        Container(
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
                    function: () async {
                      await _getInformationForCart();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        "Thêm vào giỏ hàng thành công",
                        style: TextStyle(color: Colors.green),
                      )));
                      pushToNextScreen(context, const CartMarketPage());
                    }),
              ),
              Container(
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

  void _updatePriceTitle() {
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

  void _updateImgLink() {
    if (_colorValue != null) {
      _detailData?["product_variants"].forEach((element) {
        if (element["option1"] == _colorValue) {
          setState(() {
            if (element["image"] != null) {
              _imgChildLink = element["image"]["url"];
              mediaIndex = -1;
            }
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
          SizedBox(
              width: 80, child: buildTextContent(title, true, fontSize: 18)),
          Expanded(
              child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(data.length, (index) {
              return InkWell(
                onTap: () {
                  if (title == "Màu sắc") {
                    if (_colorCheckList.isNotEmpty) {
                      for (int i = 0; i < _colorCheckList.length; i++) {
                        _colorCheckList[i] = false;
                      }
                      _colorCheckList[index] = true;
                      _colorValue = data[index];
                    }
                  } else {
                    if (_sizeCheckList.isNotEmpty) {
                      for (int i = 0; i < _sizeCheckList.length; i++) {
                        _sizeCheckList[i] = false;
                      }
                      _sizeCheckList[index] = true;
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
                          ? _colorCheckList.isNotEmpty && _colorCheckList[index]
                              ? blueColor
                              : white
                          : _sizeCheckList.isNotEmpty && _sizeCheckList[index]
                              ? blueColor
                              : white,
                      border: Border.all(color: greyColor, width: 0.6),
                      borderRadius: BorderRadius.circular(5)),
                  child: buildTextContent(data[index], false, fontSize: 14),
                ),
              );
            }),
          ))
        ],
      ),
    );
  }

  void _showShareDetailBottomSheet(BuildContext context) {
    showBottomSheetCheckImportantSettings(context, 250, "Chia sẻ",
        widget: ListView.builder(
            shrinkWrap: true,
            itemCount: DetailProductMarketConstants
                .DETAIL_PRODUCT_MARKET_SHARE_SELECTIONS["data"].length,
            itemBuilder: (context, index) {
              final data = DetailProductMarketConstants
                  .DETAIL_PRODUCT_MARKET_SHARE_SELECTIONS["data"];
              return Column(
                children: [
                  GeneralComponent(
                    [
                      buildTextContent(data[index]["title"], true, fontSize: 16)
                    ],
                    prefixWidget: Container(
                      height: 25,
                      width: 25,
                      margin: const EdgeInsets.only(right: 10),
                      child: Icon(data[index]["icon"]),
                    ),
                    changeBackground: transparent,
                    padding: const EdgeInsets.all(5),
                    function: () {
                      String title = DetailProductMarketConstants
                              .DETAIL_PRODUCT_MARKET_SHARE_SELECTIONS["data"]
                          [index]["title"];
                      Widget body = const SizedBox();
                      switch (data[index]["key"]) {
                        // link
                        case LINK:
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Sao chép sản phẩm")));
                          popToPreviousScreen(context);
                          return;
                        case SHARE_ON_STORY_TABLE:
                        //
                        case SHARE_ON_GROUP:
                          body = ShareAndSearchWidget(
                              data: DetailProductMarketConstants
                                  .DETAIL_PRODUCT_MARKET_GROUP_SHARE_SELECTIONS,
                              placeholder: title);
                          break;
                        default:
                          body = ShareAndSearchWidget(
                              data: DetailProductMarketConstants
                                  .DETAIL_PRODUCT_MARKET_FRIEND_SHARE_SELECTIONS,
                              placeholder: title);
                          break;
                      }
                      showBottomSheetCheckImportantSettings(context, 600, title,
                          iconData: FontAwesomeIcons.chevronLeft,
                          isBarrierTransparent: true,
                          widget: body);
                    },
                  ),
                  buildDivider(color: greyColor)
                ],
              );
            }));
  }

  Future<void> _getInformationForCart() async {
    if (_colorValue == null) {
      // khong co  sp con nen chon sp duy nhat
      _productToCart = _detailData?["product_variants"][0];
    } else {
      if (_sizeValue != null) {
        _detailData?["product_variants"].forEach((element) {
          if (element["option1"] == _colorValue &&
              element["option2"] == _sizeValue) {
            _productToCart = element;
            return;
          }
        });
      } else {
        _detailData?["product_variants"].forEach((element) {
          if (element["option1"] == _colorValue) {
            _productToCart = element;
            return;
          }
        });
      }
    }
    final data = {
      "product_variant_id": _productToCart["id"].toString(),
      "quantity": productNumber
    };
    final response = await CartProductApi().postCartProductApi(data);
  }
}
