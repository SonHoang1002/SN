import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/follwer_product_api.dart';
import 'package:market_place/constant/get_min_max_price.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/cart_product_provider.dart';
import 'package:market_place/providers/market_place_providers/detail_product_provider.dart';
import 'package:market_place/providers/market_place_providers/interest_product_provider.dart';
import 'package:market_place/providers/market_place_providers/review_product_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/unsucess_transaction_page.dart';
import 'package:market_place/screens/MarketPlace/screen/preview_video_image.dart';
import 'package:market_place/screens/MarketPlace/widgets/cart_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/rating_star_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/review_item_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/share_and_search.dart';
import 'package:market_place/apis/market_place_apis/cart_apis.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/video_render_player.dart';

import '../../../../theme/colors.dart';

const String link = "link";
const String share_on_story_table = "share_on_story_table";
const String share_on_group = "share_on_group";
const String share_on_personal_page_of_friend =
    "share_on_personal_page_of_friend";
String imageUrl =
    "https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1200,h_630/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/ype8x0zkqbv239asgx9p/V%C3%A9%20V%C3%A0o%20C%E1%BB%95ng%20IMG%20Worlds%20of%20Adventure,%20Dubai%20.jpg";

class DetailProductMarketPage extends ConsumerStatefulWidget {
  dynamic simpleData;
  final dynamic id;
  DetailProductMarketPage({
    super.key,
    required this.id,
    this.simpleData,
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
  List<bool> _colorCheckList = [];
  List<bool> _sizeCheckList = [];
  dynamic _colorValue;
  dynamic _sizeValue;
  String? _priceTitle;
  dynamic _productToCart;
  List<dynamic>? mediaList = [];
  int mediaIndex = 0;
  dynamic selectedProduct;
  bool _canAddToCart = false;
  bool _isScrolled = false;
  bool _addProductStatus = false;
  bool _showSelectedProduct = false;
  Offset? offset;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _animationKey = GlobalKey();
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
    _scrollController.addListener(() {
      if (_scrollController.offset > 40 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 40 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mediaList = [];
    _detailData = {};
    _commentData = [];
    int productNumber = 1;
    _onMorePart = 0;
    _prices = [];
    _isLoading = true;
    _colorValue = null;
    _sizeValue = null;
    _priceTitle = null;
    _productToCart = null;
    mediaIndex = 0;
    selectedProduct = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Future<int> a = _initData();
    final box = _animationKey.currentContext?.findRenderObject() as RenderBox?;
    offset = box?.localToGlobal(Offset.zero);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            !_isLoading ? _buildDetailBody() : buildCircularProgressIndicator(),
            Column(
              children: [
                Container(
                  height: 30,
                  width: width,
                  color: _isScrolled
                      ? Theme.of(context).scaffoldBackgroundColor
                      : transparent,
                ),
                _customAppBar()
              ],
            ),
            _showSelectedProduct
                ? animationWidget(
                    imgLink: mediaList != null
                        ? mediaList![0].endsWith(".mp4")
                            ? mediaList![1]
                            : mediaList![0]
                        : null)
                : const SizedBox()
          ],
        ));
  }

  Future<int> _initData() async {
    // khoi tao general data
    if (widget.simpleData == null) {
      if (_detailData == null && _commentData == null) {
        final detailData = await ref
            .read(detailProductProvider.notifier)
            .getDetailProduct(widget.id);
        final comment = await ref
            .read(reviewProductProvider.notifier)
            .getReviewProduct(widget.id);
      }
      _detailData = ref.watch(detailProductProvider).detail;
    } else {
      _detailData = widget.simpleData;
    }
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
    if (_isConcern == null) {
      final follower =
          await ref.read(interestProductsProvider.notifier).getFollwerProduct();
      _isConcern = false;
      final primaryInterestList =
          ref.watch(interestProductsProvider).listInterest;
      if (primaryInterestList.isNotEmpty) {
        for (var element in primaryInterestList) {
          if (element["id"] == widget.id) {
            _isConcern = true;
          }
        }
      }
    }
    _productToCart = _detailData!["product_variants"][0];
    selectedProduct = _detailData!["product_variants"][0];
    // load xong
    setState(() {
      _isLoading = false;
    });
    return 0;
  }

  Future _addToCart() async {
    final response = await _getInformationForCart();
    if (response != null && response.isNotEmpty) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                backgroundColor: transparent,
                content: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: blackColor.withOpacity(0.4)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.ticket,
                          size: 18,
                          color: white,
                        ),
                        buildSpacer(height: 10),
                        buildTextContent("Đã thêm vào giỏ", false,
                            colorWord: white, fontSize: 16, isCenterLeft: false)
                      ]),
                ));
          });
      Timer(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pop();
      });
    } else {
      buildMessageDialog(context, "Không thành công");
    }
  }

  Widget _customAppBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          color: _isScrolled
              ? Theme.of(context).scaffoldBackgroundColor
              : transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  popToPreviousScreen(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        _isScrolled ? transparent : blackColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      FontAwesomeIcons.chevronLeft,
                      size: 18,
                      color: _isScrolled
                          ? Theme.of(context).textTheme.displayLarge!.color
                          : white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _showShareDetailBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isScrolled
                              ? transparent
                              : blackColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(
                            FontAwesomeIcons.share,
                            size: 18,
                            color: _isScrolled
                                ? Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color
                                : white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _isScrolled
                            ? transparent
                            : blackColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: CartWidget(
                            iconColor: _isScrolled
                                ? Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color
                                : white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        pushToNextScreen(
                            context, const UnSuccessTransactionPage());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isScrolled
                              ? transparent
                              : blackColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 18,
                            color: _isScrolled
                                ? Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color
                                : white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox()
      ],
    );
  }

  Widget _buildDetailBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            // img
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  width: width,
                  child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          mediaIndex = value;
                        });
                      },
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: mediaList!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
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
                              child: mediaList!.isEmpty
                                  ? Image.network(
                                      "https://haycafe.vn/wp-content/uploads/2022/03/anh-ma-cute-de-thuong.jpg")
                                  : mediaList![mediaIndex]?.endsWith('.mp4')
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
                        );
                      }),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      mediaList!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: mediaIndex == index
                              ? secondaryColor
                              : secondaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
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
                            buildRatingStarWidget(_detailData?["rating_count"]),
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
                                onTap: () async {
                                  setState(() {
                                    _isConcern = !_isConcern!;
                                  });
                                  if (_isConcern!) {
                                    await FollwerProductsApi()
                                        .postFollwerProductsApi(widget.id);
                                  } else {
                                    await FollwerProductsApi()
                                        .deleteFollwerProductsApi(widget.id);
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
                                        .DETAIL_PRODUCT_MARKET_CONTENTS[index],
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
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: buildMarketButton(
                          width: width * 0.25,
                          bgColor: Colors.orange[300],
                          contents: [
                            const Icon(
                              FontAwesomeIcons.message,
                              size: 13,
                            ),
                            buildSpacer(height: 3),
                            buildTextContent("Chat ngay", false, fontSize: 9)
                          ],
                          radiusValue: 0,
                          isHaveBoder: false,
                          isVertical: true,
                          function: () async {}),
                    ),
                    Container(
                      child: buildMarketButton(
                          width: width * 0.25,
                          bgColor: Colors.orange[300],
                          contents: [
                            const Icon(
                              FontAwesomeIcons.cartArrowDown,
                              size: 13,
                            ),
                            buildSpacer(height: 3),
                            buildTextContent("Thêm vào giỏ", false, fontSize: 9)
                          ],
                          isVertical: true,
                          radiusValue: 0,
                          fontSize: 9,
                          isHaveBoder: false,
                          function: () async {
                            if (_detailData!["product_options"].isNotEmpty) {
                              showBottomColorSelections("Thêm vào giỏ hàng");
                            } else {
                              _updateAnimation();

                              _addToCart();
                            }
                          }),
                    ),
                    Container(
                      child: buildMarketButton(
                          width: width * 0.5,
                          bgColor: red,
                          contents: [
                            buildTextContent("Mua ngay", false, fontSize: 13)
                          ],
                          function: () async {
                            if (_detailData!["product_options"].isNotEmpty) {
                              showBottomColorSelections("Mua ngay");
                            } else {
                              _updateAnimation();
                              _addToCart();
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
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
    showCustomBottomSheet(context, 550, title: "Chọn kiểu dáng",
        widget: StatefulBuilder(builder: (context, setStateFull) {
      return Container(
        padding: const EdgeInsets.only(left: 10),
        height: 470,
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
              buildDivider(
                height: 10,
                color: greyColor,
                top: 10,
              ),
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
                                    ? Column(
                                        children: [
                                          buildDivider(
                                            height: 10,
                                            color: greyColor,
                                            top: 10,
                                          ),
                                          _buildColorOrSizeWidget(
                                              "Kích cỡ",
                                              _detailData?["product_options"][1]
                                                  ["values"],
                                              additionalFunction: () {
                                            setStateFull(() {});
                                          }),
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            )
                          : const SizedBox(),
                      buildDivider(
                          height: 10, color: greyColor, top: 10, bottom: 10),
                      // choose number of product
                      Row(children: [
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
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: greyColor, width: 0.2)),
                                height: 30,
                                width: 30,
                                child: const Center(
                                    child: Icon(
                                  FontAwesomeIcons.minus,
                                  size: 18,
                                )),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: greyColor, width: 0.2)),
                              height: 30,
                              width: 30,
                              child: buildTextContent("${productNumber}", true,
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
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: greyColor, width: 0.2)),
                                height: 30,
                                width: 30,
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
                    ],
                  ),
                ),
              ),
            ]),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: buildMarketButton(
                  width: width,
                  bgColor: _canAddToCart ? Colors.orange[500] : greyColor,
                  contents: [buildTextContent(title, false, fontSize: 13)],
                  function: () async {
                    _updateAnimation();
                    popToPreviousScreen(context);
                    _canAddToCart ? _addToCart() : null;
                  }),
            ),
          ],
        ),
      );
    }));
  }

  Widget _buildColorOrSizeWidget(String title, List<dynamic> data,
      {Function? additionalFunction}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(
                    top: 7,
                  ),
                  width: 80,
                  child: buildTextContent(title, true, fontSize: 18)),
              Wrap(
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
                      padding: const EdgeInsets.all(10),
                      width: 80,
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: title == "Màu sắc"
                                  ? _colorCheckList.isNotEmpty &&
                                          _colorCheckList[index]
                                      ? blueColor
                                      : greyColor
                                  : _sizeCheckList.isNotEmpty &&
                                          _sizeCheckList[index]
                                      ? blueColor
                                      : greyColor,
                              width: 0.6),
                          borderRadius: BorderRadius.circular(5)),
                      child: buildTextContent(data[index], false,
                          colorWord: title == "Màu sắc"
                              ? _colorCheckList.isNotEmpty &&
                                      _colorCheckList[index]
                                  ? blueColor
                                  : null
                              : _sizeCheckList.isNotEmpty &&
                                      _sizeCheckList[index]
                                  ? blueColor
                                  : null,
                          fontSize: 14,
                          isCenterLeft: false),
                    ),
                  );
                }),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showShareDetailBottomSheet(BuildContext context) {
    showCustomBottomSheet(context, 250,
        title: "Chia sẻ",
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
                      showCustomBottomSheet(context, 600,
                          title: title,
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
    final cart =
        await ref.read(cartProductsProvider.notifier).initCartProductList();
    return response;
  }

  void _updateAnimation() {
    setState(() {
      _showSelectedProduct = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _addProductStatus = true;
      });
    });
  }

  Widget animationWidget(
      {double? distanceLeft, double? distanceTop, String? imgLink}) {
    return AnimatedPositioned(
        key: _animationKey,
        onEnd: () {
          setState(() {
            _showSelectedProduct = false;
            _addProductStatus = false;
          });
        },
        duration: const Duration(milliseconds: 1000),
        left: _addProductStatus ? 290 : distanceLeft ?? 10,
        top: _addProductStatus ? 40 : distanceTop ?? height * 0.8 - 260,
        child: _showSelectedProduct
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                height: _addProductStatus ? 30 : 100,
                width: _addProductStatus ? 30 : 100,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: offset != null
                      ? offset!.dy / 400 > 1.0
                          ? 1.0
                          : offset!.dy / 400 == 0.1
                              ? 0.0
                              : offset!.dy / 400
                      : 1.0,
                  child: ImageCacheRender(
                    path: imgLink ?? imageUrl,
                  ),
                ))
            : const SizedBox());
  }
}
