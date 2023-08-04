import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/follwer_product_api.dart';
import 'package:market_place/apis/market_place_apis/products_api.dart';
import 'package:market_place/constant/common.dart';
import 'package:market_place/constant/get_min_max_price.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/cart_product_provider.dart';
import 'package:market_place/providers/market_place_providers/detail_product_provider.dart';
import 'package:market_place/providers/market_place_providers/interest_product_provider.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/providers/market_place_providers/review_product_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/main_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/review_all_product.dart';
import 'package:market_place/screens/MarketPlace/screen/transfer_order_page.dart';
import 'package:market_place/screens/MarketPlace/screen/preview_video_image.dart';
import 'package:market_place/screens/MarketPlace/widgets/cart_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:market_place/screens/MarketPlace/widgets/extended_image_custom.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/rating_star_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/review_item_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/review_shop_widget.dart';
import 'package:market_place/apis/market_place_apis/cart_apis.dart';
import 'package:market_place/screens/MarketPlace/widgets/tranfer_fee_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/voucher_widget.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/video_render_player.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../theme/colors.dart';

const String link = "link";
const String share_on_story_table = "share_on_story_table";
const String share_on_group = "share_on_group";
const String share_on_personal_page_of_friend =
    "share_on_personal_page_of_friend";

const configReviewParams = {"limit": 1};

class DetailProductMarketPage extends ConsumerStatefulWidget {
  final dynamic simpleData;
  final dynamic id;
  final String? heroImageLink;
  DetailProductMarketPage(
      {super.key, required this.id, this.simpleData, this.heroImageLink});
  @override
  ConsumerState<DetailProductMarketPage> createState() =>
      _DetailProductMarketPageComsumerState();
}

class _DetailProductMarketPageComsumerState
    extends ConsumerState<DetailProductMarketPage> {
  late double width = 0;
  late double height = 0;
  int productNumber = 1;
  bool? _isConcern;
  Map<String, dynamic>? _detailData;
  List<dynamic>? _listComment;
  List<dynamic>? _listPrice;
  bool _isLoading = true;
  List<dynamic> _listCheckedColor = [];
  List<dynamic> _listCheckedSize = [];
  dynamic _selectedColorValue;
  dynamic _selectedSizeValue;
  String? _priceTitle;
  dynamic _productToCart;
  List<dynamic>? _listMedia = [];
  int mediaIndex = 0;
  dynamic selectedProduct;
  bool _canAddToCart = false;
  bool _isScrolled = false;
  bool _addProductStatus = false;
  bool _showSelectedProduct = false;
  Offset? offset;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _suggestController = ScrollController();
  final GlobalKey _animationKey = GlobalKey();

  List? _listProductOfPage;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();

    Future.delayed(Duration.zero, () async {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        _detailData = widget.simpleData;
        if (_detailData != null) {
          _initData();
        } else {
          final detailData = await ref
              .read(detailProductProvider.notifier)
              .getDetailProduct(widget.id);
          final comment = await ref
              .read(reviewProductProvider.notifier)
              .getReviewProduct(widget.id, configReviewParams);
          setState(() {
            _detailData = ref.watch(detailProductProvider).detail;
          });
          _initData();
        }
      });
    });
    _scrollController
      ..addListener(() {
        if (_scrollController.offset > 40 && !_isScrolled) {
          setState(() {
            _isScrolled = true;
          });
        } else if (_scrollController.offset <= 40 && _isScrolled) {
          setState(() {
            _isScrolled = false;
          });
        }
      })
      ..addListener(() async {
        if (double.parse((_scrollController.offset).toStringAsFixed(0)) ==
            (double.parse((_scrollController.position.maxScrollExtent)
                .toStringAsFixed(0)))) {
          EasyDebounce.debounce(
              'my-debouncer', const Duration(milliseconds: 300), () async {
            dynamic params = {
              "offset": ref.watch(productsProvider).list.length,
              ...paramConfigProductSearch,
            };
            ref.read(productsProvider.notifier).getProductsSearch(params);
            setState(() {
              _isLoading = true;
            });
          });
        }
      });
    ;
  }

  @override
  void dispose() {
    super.dispose();
    _listMedia = [];
    _detailData = {};
    _listComment = [];
    _listPrice = [];
    _isLoading = true;
    _selectedColorValue = null;
    _selectedSizeValue = null;
    _priceTitle = null;
    _productToCart = null;
    mediaIndex = 0;
    selectedProduct = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    _detailData ??= widget.simpleData;
    final box = _animationKey.currentContext?.findRenderObject() as RenderBox?;
    offset = box?.localToGlobal(Offset.zero);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildDetailBody(),
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
                  imgLink: _listMedia != null
                      ? _listMedia![0].endsWith(".mp4")
                          ? _listMedia![1]
                          : _listMedia![0]
                      : null)
              : const SizedBox()
        ],
      ),
    );
  }

  Future<int> _initData() async {
    if (_listMedia == null || _listMedia!.isEmpty) {
      setState(() {
        if (_detailData!["product_video"] != null) {
          _listMedia?.add(_detailData!["product_video"]["url"]);
        }
        if (_detailData!["product_image_attachments"] != null &&
            _detailData!["product_image_attachments"].isNotEmpty) {
          _detailData!["product_image_attachments"].forEach((element) {
            _listMedia?.add(element["attachment"]["url"]);
          });
        }
      });
    }
    _productToCart = _detailData!["product_variants"][0];
    selectedProduct = _detailData!["product_variants"][0];
    _listPrice = getMinAndMaxPrice(_detailData?["product_variants"]);
    if (_detailData?["product_variants"] != null ||
        _detailData?["product_variants"].isNotEmpty) {
      if (_listPrice![0] == _listPrice![1]) {
        _priceTitle = "₫${_listPrice![0]}";
      } else {
        _priceTitle ??= "₫${_listPrice![0]} - ₫${_listPrice![1]}";
      }
    } else {
      _priceTitle ??= "₫0";
    }
    // khoi tao general data
    if (_isConcern == null) {
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
    _listComment = ref.watch(reviewProductProvider).commentList;
    _listProductOfPage = await ProductsApi()
        .getProductsApi({"limit": 10, "page_id": _detailData?['page']?['id']});
    // khoi tao color and size neu co
    _initOptions();
    setState(() {});
    return 0;
  }

  _initOptions() {
    if (_listCheckedColor.isEmpty && _listCheckedSize.isEmpty) {
      if (_detailData?["product_options"] != null &&
          _detailData?["product_options"].isNotEmpty) {
        for (int i = 0;
            i < _detailData?["product_options"][0]["values"].length;
            i++) {
          if (_detailData?["product_variants"]
              .where((ele) =>
                  ele['option1'] ==
                      _detailData?["product_options"][0]["values"][i] ||
                  ele['option2'] ==
                      _detailData?["product_options"][0]["values"][i])
              .toList()
              .any((e) => e['inventory_quantity'] != 0)) {
            _listCheckedColor.add({
              "isActive": false,
              "value": _detailData?["product_options"][0]["values"][i],
              "outOfBlock": false
            });
          } else {
            _listCheckedColor.add({
              "isActive": false,
              "value": _detailData?["product_options"][0]["values"][i],
              "outOfBlock": false
            });
          }
        }
        if (_detailData?["product_options"].length == 2) {
          for (int i = 0;
              i < _detailData?["product_options"][1]["values"].length;
              i++) {
            _listCheckedSize.add({
              "isActive": false,
              "value": _detailData?["product_options"][1]["values"][i],
              "outOfBlock": false
            });
          }
        }
      }
    }
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
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: blackColor.withOpacity(0.4)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
          padding: const EdgeInsets.only(top: 20),
          height: 70,
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
                        // _showShareDetailBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isScrolled
                              ? transparent
                              : blackColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: SizedBox(
                          // height: 30,
                          // width: 30,
                          child: Image.asset(
                            "assets/icons/share_product_icon.png",
                            height: 20,
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
                        // pushToNextScreen(context, const TransferOrderPage());
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
                      itemCount: _listMedia!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            pushToNextScreen(
                                context,
                                PreviewVideoImage(
                                  src: _listMedia!,
                                  index: mediaIndex,
                                ));
                          },
                          child: SizedBox(
                              height: 350,
                              width: width,
                              child: _listMedia!.isEmpty
                                  ? Image.network(
                                      "https://haycafe.vn/wp-content/uploads/2022/03/anh-ma-cute-de-thuong.jpg")
                                  : _listMedia![mediaIndex]?.endsWith('.mp4')
                                      ? SizedBox(
                                          height: 300,
                                          width: width,
                                          child: SizedBox(
                                            height: 300,
                                            child: VideoPlayerRender(
                                              path: _listMedia![mediaIndex],
                                              autoPlay: true,
                                            ),
                                          ))
                                      : ExtendedImageNetWorkCustom(
                                          path: _listMedia![mediaIndex],
                                          width: width,
                                          fit: BoxFit.cover,
                                          height: 300)),
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
                      _listMedia!.length,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSpacer(height: 10),
                // example color or size product
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_listMedia!.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              mediaIndex = index;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: mediaIndex == index
                                      ? Border.all(
                                          color: primaryColor, width: 0.6)
                                      : null),
                              margin: const EdgeInsets.only(right: 10),
                              child: _listMedia![index].endsWith(".mp4")
                                  ? SizedBox(
                                      height: 120,
                                      width: 180,
                                      child: VideoPlayerRender(
                                          path: _listMedia![index]))
                                  : ExtendedImageNetWorkCustom(
                                      path: _listMedia![index],
                                      height: 120.0,
                                      width: 120.0,
                                    )),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                buildSpacer(height: 10),
                buildDivider(
                  color: secondaryColor,
                ),
                // title
                buildSpacer(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: buildTextContent(_detailData?["title"] ?? "", true,
                      fontSize: 17),
                ),
                // price
                buildSpacer(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: buildTextContent(
                    _priceTitle ?? "₫0.0",
                    true,
                    fontSize: 18,
                    colorWord: red,
                  ),
                ),
                //rate, selled and heart, share,
                buildSpacer(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          buildRatingStarWidget(_detailData?["rating"]),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: buildTextContent(
                                "${_detailData?["rating"].toString()}", false,
                                fontSize: 16),
                          ),
                          Container(
                            width: 2,
                            color: red,
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: buildTextContent("đã bán ", false,
                                    fontSize: 13),
                              ),
                              buildTextContent(
                                  "${_detailData?["sold"].round()}", false,
                                  fontSize: 15),
                            ],
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
                                  child: (_isConcern != null && _isConcern!)
                                      ? Image.asset(
                                          "assets/icons/concern_fill_product_icon.png",
                                          height: 18,
                                          color: primaryColor,
                                        )
                                      : Image.asset(
                                          "assets/icons/concern_product_icon.png",
                                          height: 18,
                                          color: primaryColor,
                                        )),
                            ),
                            //share
                            InkWell(
                              onTap: () {
                                // _showShareDetailBottomSheet(context);
                              },
                              child: Image.asset(
                                "assets/icons/share_product_icon.png",
                                height: 16,
                                color: primaryColor,
                              ),
                            ),
                            //heart
                            InkWell(
                              onTap: () {},
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image.asset(
                                    "assets/icons/chat_product_icon.png",
                                    height: 18,
                                    color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const CrossBar(height: 7, opacity: 0.2),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  child: buildVoucherAndSelect(),
                ),
                const CrossBar(height: 7, opacity: 0.2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: buildTranferFee(context),
                ),
                const CrossBar(height: 7, opacity: 0.2),
                _detailData?['page'] != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: buildReviewShop(context, _detailData?['page']),
                      )
                    : const SizedBox(),
                buildSpacer(height: 10),
                _buildDescriptionAndReview(),
                buildSpacer(height: 10),
                _listProductOfPage != null && _listProductOfPage!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SuggestListComponent(
                            context: context,
                            axis: Axis.horizontal,
                            title: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  child:
                                      buildDivider(color: greyColor, right: 10),
                                ),
                                buildTextContent("Sản phẩm khác của shop", true,
                                    fontSize: 16),
                                Flexible(
                                  child:
                                      buildDivider(color: greyColor, left: 10),
                                ),
                              ],
                            ),
                            contentList: _listProductOfPage ?? []),
                      )
                    : const SizedBox(),
                buildSpacer(height: 15),
                SuggestListComponent(
                    context: context,
                    title: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          child: buildDivider(color: greyColor, right: 10),
                        ),
                        buildTextContent("Có thể bạn sẽ thích", true,
                            fontSize: 16),
                        Flexible(
                          child: buildDivider(color: greyColor, left: 10),
                        ),
                      ],
                    ),
                    isLoading: true,
                    isLoadingMore: ref.watch(productsProvider).isMore,
                    contentList: ref.watch(productsProvider).list),

                buildSpacer(height: 90),
              ],
            )
          ]),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 80,
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.9,
                          alignment: Alignment.center,
                          child: Flex(
                            direction: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 3,
                                child: buildMarketButton(
                                  // width: width * 0.25,
                                  bgColor: Colors.orange[300],
                                  contents: [
                                    Image.asset(
                                      "assets/icons/chat_product_icon.png",
                                      height: 18,
                                      color: white,
                                    ),
                                    buildSpacer(height: 3),
                                    buildTextContent("Chat ngay", false,
                                        fontSize: 9, isCenterLeft: false)
                                  ],
                                  radiusValue: 0,
                                  isHaveBoder: false,
                                  isVertical: true,
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: buildMarketButton(
                                  // width: width * 0.25,
                                  bgColor: primaryColor,
                                  contents: [
                                    Image.asset(
                                      "assets/icons/cart_product_icon.png",
                                      height: 18,
                                      color: white,
                                    ),
                                    buildSpacer(height: 3),
                                    buildTextContent("Thêm vào giỏ", false,
                                        fontSize: 9, isCenterLeft: false)
                                  ],
                                  isVertical: true,
                                  radiusValue: 0,
                                  fontSize: 9,
                                  isHaveBoder: false,
                                  function: () async {
                                    if (_detailData!["product_options"] !=
                                            null &&
                                        _detailData!["product_options"]
                                            .isNotEmpty) {
                                      showBottomColorSelections(
                                          "Thêm vào giỏ hàng");
                                    } else {
                                      _updateAnimation();
                                      _addToCart();
                                    }
                                  },
                                ),
                              ),
                              Flexible(
                                flex: 5,
                                child: buildMarketButton(
                                  // width: width * 0.5,
                                  bgColor: red,
                                  contents: [
                                    buildTextContent("Mua ngay", false,
                                        fontSize: 13)
                                  ],
                                  function: () async {
                                    if (_detailData!["product_options"]
                                        .isNotEmpty) {
                                      showBottomColorSelections("Mua ngay");
                                    } else {
                                      _updateAnimation();
                                      _addToCart();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  void _updateInformationCategorySelection() {
    // update price, repository, img
    if (_detailData!["product_options"] != null &&
        _detailData!["product_options"].isNotEmpty) {
      if (_detailData!["product_options"].length == 2) {
        if (_selectedSizeValue != null && _selectedColorValue != null) {
          _detailData?["product_variants"].forEach((element) {
            if (element["option1"] == _selectedColorValue &&
                element["option2"] == _selectedSizeValue) {
              _priceTitle = "₫${element["price"].toString()}";
              selectedProduct = element;
              if (checkOutOfStock()) {
                _canAddToCart = false;
              } else {
                _canAddToCart = true;
              }
              setState(() {});
            }
          });
        } else {
          return;
        }
      } else {
        if (_selectedColorValue != null) {
          _detailData?["product_variants"].forEach((element) {
            if (element["option1"] == _selectedColorValue) {
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

  Widget _buildDescriptionAndReview() {
    return Column(
      children: [
        const CrossBar(height: 7, opacity: 0.2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              buildVoucherAndSelect(
                  title: "Chi tiết sản phẩm",
                  subTitle: "Kho, bảo hành",
                  havePrefixIcon: false,
                  mainFontSize: 17,
                  subTitleFontSize: 14,
                  titleBold: true),
              buildSpacer(height: 10),
              buildDivider(color: greyColor, left: 20, right: 20, bottom: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ExpandableText(
                  _detailData?["description"],
                  expandText: 'Xem thêm',
                  collapseText: 'Thu gọn',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  linkStyle: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 10,
                  linkColor: blueColor,
                  animation: true,
                  collapseOnTextTap: true,
                  mentionStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  onUrlTap: (url) async {
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      return;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const CrossBar(height: 7, opacity: 0.2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: buildVoucherAndSelect(
              title: "Đánh giá sản phẩm",
              subTitle: "Xem tất cả",
              havePrefixIcon: false,
              titleBold: true,
              mainFontSize: 17,
              subTitleFontSize: 14,
              addtionalWidget: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildRatingStarWidget(4),
                    buildSpacer(width: 5),
                    buildTextContent("4/5 (1000 đánh giá)", false, fontSize: 13)
                  ],
                ),
              ),
              function: () {
                pushToNextScreen(
                    context,
                    ReviewAllProductPage(
                      listProduct: _listComment!,
                    ));
              }),
        ),
        _listComment != null && _listComment!.isNotEmpty
            ? Column(
                children: [
                  buildDivider(color: greyColor, left: 10, right: 10, top: 5),
                  Column(
                      children: List.generate(_listComment!.length, (index) {
                    return buildReviewItemWidget(context, _listComment![index]);
                  }).toList()),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: buildTextContent(
                  "Không có bài đánh giá nào",
                  false,
                  fontSize: 15,
                ),
              )
      ],
    );
  }

  void showBottomColorSelections(String title) {
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
                      ? ExtendedImageNetWorkCustom(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: buildTextContent(
                                  "Số lượng:",
                                  true,
                                  fontSize: 14,
                                ),
                              ),
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
                                        border: Border.all(
                                            color: greyColor, width: 0.2)),
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
                      ),
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
                  contents: [
                    buildTextContent(
                        checkOutOfStock() ? "Sản phẩm hết hàng" : title, false,
                        fontSize: 13)
                  ],
                  function: () async {
                    _callAddToCartFunction();
                  }),
            ),
          ],
        ),
      );
    }));
  }

// ba truong hop: có màu, cớ cỡ; không màu, có cỡ; có màu, không cỡ
  _callAddToCartFunction() {
    if (_listCheckedColor.isNotEmpty && _listCheckedSize.isNotEmpty) {
      if (_selectedColorValue != null && _selectedSizeValue != null) {
        _updateAnimation();
        popToPreviousScreen(context);
        _canAddToCart ? _addToCart() : null;
      }
    } else if (_listCheckedColor.isNotEmpty && _listCheckedSize.isEmpty) {
      if (_selectedColorValue != null) {
        _updateAnimation();
        popToPreviousScreen(context);
        _canAddToCart ? _addToCart() : null;
      }
    } else if (_listCheckedColor.isEmpty && _listCheckedSize.isNotEmpty) {
      if (_selectedSizeValue != null) {
        _updateAnimation();
        popToPreviousScreen(context);
        _canAddToCart ? _addToCart() : null;
      }
    }
  }

  Widget _buildColorOrSizeWidget(String title, List<dynamic> data,
      {Function? additionalFunction}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: const EdgeInsets.only(
                    top: 7,
                  ),
                  width: 80,
                  child: buildTextContent(title, true, fontSize: 18)),
              const SizedBox()
            ],
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(data.length, (index) {
              return InkWell(
                onTap: () {
                  if (title == "Màu sắc") {
                    if (_listCheckedColor.isNotEmpty) {
                      for (int i = 0; i < _listCheckedColor.length; i++) {
                        _listCheckedColor[i]['isActive'] = false;
                      }
                      _listCheckedColor[index]['isActive'] = true;
                      _selectedColorValue = data[index];
                    }
                  } else {
                    if (_listCheckedSize.isNotEmpty) {
                      for (int i = 0; i < _listCheckedSize.length; i++) {
                        _listCheckedSize[i]['isActive'] = false;
                      }
                      _listCheckedSize[index]['isActive'] = true;
                      _selectedSizeValue = data[index];
                    }
                  }
                  setState(() {});
                  if (_selectedSizeValue != null &&
                      _selectedColorValue != null) {
                    if (_detailData?["product_variants"].firstWhere(
                          (ele) =>
                              (ele['option1'] == _selectedColorValue &&
                                  ele['option2'] == _selectedSizeValue) ||
                              (ele['option1'] == _selectedSizeValue &&
                                  ele['option2'] == _selectedColorValue),
                          orElse: () {
                            return false;
                          },
                        )['inventory_quantity'] ==
                        0) {}
                  }
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
                              ? _listCheckedColor.isNotEmpty &&
                                      _listCheckedColor[index]['isActive']
                                  ? blueColor
                                  : greyColor
                              : _listCheckedSize.isNotEmpty &&
                                      _listCheckedSize[index]['isActive']
                                  ? blueColor
                                  : greyColor,
                          width: 0.6),
                      borderRadius: BorderRadius.circular(5)),
                  child: buildTextContent(data[index], false,
                      colorWord: title == "Màu sắc"
                          ? _listCheckedColor.isNotEmpty &&
                                  _listCheckedColor[index]['isActive']
                              ? blueColor
                              : null
                          : _listCheckedSize.isNotEmpty &&
                                  _listCheckedSize[index]['isActive']
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
    );
  }

  bool checkOutOfStock() {
    if (_selectedSizeValue != null && _selectedColorValue != null) {
      if (_detailData?["product_variants"].firstWhere(
            (ele) =>
                (ele['option1'] == _selectedColorValue &&
                    ele['option2'] == _selectedSizeValue) ||
                (ele['option1'] == _selectedSizeValue &&
                    ele['option2'] == _selectedColorValue),
            orElse: () {
              return false;
            },
          )['inventory_quantity'] ==
          0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<dynamic> _getInformationForCart() async {
    if (_selectedColorValue == null) {
      // khong co  sp con nen chon sp duy nhat
      _productToCart = _detailData?["product_variants"][0];
    } else {
      if (_selectedSizeValue != null) {
        _detailData?["product_variants"].forEach((element) {
          if (element["option1"] == _selectedColorValue &&
              element["option2"] == _selectedSizeValue) {
            _productToCart = element;
            return;
          }
        });
      } else {
        _detailData?["product_variants"].forEach((element) {
          if (element["option1"] == _selectedColorValue) {
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
                  child: ExtendedImageNetWorkCustom(
                    path: imgLink ?? linkBannerDefault,
                    height: _addProductStatus ? 30 : 100,
                    width: _addProductStatus ? 30 : 100,
                  ),
                ))
            : const SizedBox());
  }
}
