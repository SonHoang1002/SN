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
import 'package:social_network_app_mobile/screen/MarketPlace/screen/preview_video_image.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/cart_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/rating_star_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/review_item_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/share_and_search_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_message_dialog_widget.dart';
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

const String link = "link";
const String share_on_story_table = "share_on_story_table";
const String share_on_group = "share_on_group";
const String share_on_personal_page_of_friend =
    "share_on_personal_page_of_friend";

// ignore: must_be_immutable
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
  dynamic _productToCart;
  List<dynamic>? mediaList = [];
  int mediaIndex = 0;
  dynamic selectedProduct;
  bool _canAddToCart = false;
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
              CartWidget(),
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
      if (_prices![0] == _prices![1]) {
        _priceTitle = "₫${_prices![0]}";
      } else {
        _priceTitle ??= "₫${_prices![0]} - ₫${_prices![1]}";
      }
    } else {
      _priceTitle ??= "₫0";
    }
    // lay các ảnh cha
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

    selectedProduct = _detailData!["product_variants"][0];
    // load xong
    _isLoading = false;
    setState(() {});
    return 0;
  }

  Future _addToCart() async {
    final response = await _getInformationForCart();
    if (response != null && response.isNotEmpty) {
      buildMessageDialog(context, "Thêm vào giỏ hàng thành công ");
    } else {
      buildMessageDialog(context, "Không thành công");
    }
  }

  Widget _buildDetailBody() {
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
                  InkWell(
                    onTap: () {
                      pushToNextScreen(
                          context,
                          PreviewVideoImage(
                            src: mediaList!,
                            index: mediaIndex,
                          ));
                    },
                    child: SizedBox(
                        height: 350,
                        width: width,
                        child: mediaList![mediaIndex]?.endsWith('.mp4')
                            ? SizedBox(
                                height: 300,
                                width: width,
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
                  ),
                  Container(
                    height: 350,
                    width: width,
                    // color: ,
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
                    buildSpacer(height: 10),
                    // example color or size product
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(mediaList!.length, (index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                mediaIndex = index;
                              });
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
                      _priceTitle ?? "₫0.0",
                      true,
                      fontSize: 18,
                      colorWord: red,
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
                                color: red,
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
                                //concern
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
                        buildDivider(height: 10, color: red),
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
                                              ),
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
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: buildButtonForMarketWidget(
                    width: width * 0.25,
                    bgColor: Colors.orange[300],
                    title: "Chat ngay",
                    fontSize: 9,
                    radiusValue: 0,
                    iconData: FontAwesomeIcons.message,
                    isHaveBoder: false,
                    isVertical: true,
                    function: () async {}),
              ),
              Container(
                child: buildButtonForMarketWidget(
                    width: width * 0.25,
                    bgColor: Colors.orange[300],
                    title: "Thêm vào giỏ",
                    iconData: FontAwesomeIcons.cartArrowDown,
                    isVertical: true,
                    radiusValue: 0,
                    fontSize: 9,
                    isHaveBoder: false,
                    function: () async {
                      if (_detailData!["product_options"].isNotEmpty) {
                        showBottomColorSelections("Thêm vào giỏ hàng");
                      } else {
                        _addToCart();
                      }
                    }),
              ),
              Container(
                child: buildButtonForMarketWidget(
                    width: width * 0.5,
                    bgColor: red,
                    title: "Mua ngay",
                    function: () {
                      if (_detailData!["product_options"].isNotEmpty) {
                        showBottomColorSelections("Mua ngay");
                      } else {
                        _addToCart();
                      }
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateInformationCategorySelection() {
    // update price, repository, img
    if (_detailData!["product_options"] != null &&
        _detailData!["product_options"].isNotEmpty) {
      if (_detailData!["product_options"].length == 2) {
        if (_sizeValue != null && _colorValue != null) {
          _detailData?["product_variants"].forEach((element) {
            if (element["option1"] == _colorValue &&
                element["option2"] == _sizeValue) {
              _priceTitle = "₫${element["price"].toString()}";
              selectedProduct = element;
              _canAddToCart = true;
              setState(() {});
            }
          });
        } else {
          return;
        }
      } else {
        if (_colorValue != null) {
          _detailData?["product_variants"].forEach((element) {
            if (element["option1"] == _colorValue) {
              _priceTitle = "₫${element["price"].toString()}";
              selectedProduct = element;
              _canAddToCart = true;
              setState(() {});
            }
          });
        } else {
          return;
        }
      }
    }
  }

  showBottomColorSelections(String title) {
    showCustomBottomSheet(context, 520, "Chọn kiểu dáng",
        widget: StatefulBuilder(builder: (context, setStateFull) {
      return SizedBox(
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              // child img
              buildSpacer(height: 10),
              Row(
                children: [
                  selectedProduct["image"] != null
                      ? ImageCacheRender(
                          path: selectedProduct["image"]["url"] ??
                              "https://cea-saigon.edu.vn/img_data/images/error.jpg",
                          height: 120.0,
                          width: 120.0,
                        )
                      : Container(
                          color: greyColor,
                          height: 120.0,
                          width: 120.0,
                          child: buildTextContent("Không có ảnh", false,
                              isCenterLeft: false),
                        ),
                  buildSpacer(width: 10),
                  Column(
                    children: [
                      buildTextContent(
                        _priceTitle.toString(),
                        true,
                      ),
                      buildTextContent(
                          "Kho: ${selectedProduct["inventory_quantity"]}", true,
                          fontSize: 17, colorWord: red)
                    ],
                  ),
                ],
              ),
              buildSpacer(height: 10),
              // color and size
              SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _detailData?["product_options"] != null &&
                              _detailData?["product_options"].isNotEmpty
                          ? Column(
                              children: [
                                //color
                                _buildColorOrSizeWidget(
                                    "Màu sắc",
                                    _detailData?["product_options"][0]
                                        ["values"], additionalFunction: () {
                                  setStateFull(() {});
                                }),
                                // size
                                _detailData?["product_options"].length == 2
                                    ? _buildColorOrSizeWidget(
                                        "Kích cỡ",
                                        _detailData?["product_options"][1]
                                            ["values"], additionalFunction: () {
                                        setStateFull(() {});
                                      })
                                    : const SizedBox()
                              ],
                            )
                          : const SizedBox(),
                      // choose number of product
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: buildTextContent(
                              "Số lượng:",
                              true,
                              fontSize: 14,
                            ),
                          ),
                          buildSpacer(width: 10),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (productNumber > 0) {
                                    setState(() {
                                      productNumber--;
                                    });
                                    setStateFull(() {});
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
                                  setStateFull(() {});
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
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: buildButtonForMarketWidget(
                            width: width * 0.8,
                            bgColor:
                                _canAddToCart ? Colors.orange[500] : greyColor,
                            title: title,
                            function: () async {
                              _canAddToCart ? _addToCart() : null;
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }));
  }

  Widget _buildColorOrSizeWidget(String title, List<dynamic> data,
      {Function? additionalFunction}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(
                top: 7,
              ),
              width: 80,
              child: buildTextContent(title, true, fontSize: 18)),
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
                  _updateInformationCategorySelection();
                  additionalFunction != null ? additionalFunction() : null;
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
    showCustomBottomSheet(context, 250, "Chia sẻ",
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
                        case link:
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Sao chép sản phẩm")));
                          popToPreviousScreen(context);
                          return;
                        case share_on_story_table:
                        //
                        case share_on_group:
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
                      showCustomBottomSheet(context, 600, title,
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

  Future<dynamic> _getInformationForCart() async {
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
    final cart = await CartProductApi().getCartProductApi();
    return response;
  }
}
