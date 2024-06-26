import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_network_app_mobile/apis/market_place_apis/cart_apis.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/cart_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/main_market_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/payment_modules/payment_market_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/divider_widget.dart';

class CartMarketPage extends ConsumerStatefulWidget {
  const CartMarketPage({super.key});

  @override
  ConsumerState<CartMarketPage> createState() => _CartMarketPageState();
}

BoxDecoration boxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(7),
  color: greyColor,
);
OutlinedBorder checkBoxBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(4),
);

class _CartMarketPageState extends ConsumerState<CartMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _cartData;
  double _allMoney = 0;
  bool _isLoading = true;
  final TextEditingController _searchController =
      TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (double.parse((_scrollController.offset).toStringAsFixed(0)) ==
          (double.parse((_scrollController.position.maxScrollExtent)
              .toStringAsFixed(0)))) {
        EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 300),
            () async {
          dynamic params = {
            "offset": ref.watch(productsProvider).list.length,
            ...paramConfigProductSearch,
          };
          ref.read(productsProvider.notifier).getProductsSearch(params);
        });
      }
    });
  }

  Future _initData() async {
    Future.delayed(Duration.zero, () async {
      if (ref.watch(cartProductsProvider).listCart.isEmpty) {
        await ref.read(cartProductsProvider.notifier).initCartProductList();
      }
    });
    _cartData = ref.watch(cartProductsProvider).listCart;
    _updateTotalPrice();
    setState(() {
      _isLoading = false;
    });
  }

  _checkBoxAll() {
    for (int i = 0; i < _cartData!.length; i++) {
      for (int j = 0; j < _cartData![i]["items"].length; j++) {
        if (_cartData![i]["items"][j]["check"] == false) {
          return false;
        }
      }
    }
    return true;
  }

  _updateTotalPrice() {
    _allMoney = 0;
    for (int i = 0; i < _cartData!.length; i++) {
      for (int j = 0; j < _cartData![i]["items"].length; j++) {
        if (_cartData![i]["items"][j]["check"] == true) {
          _allMoney += _cartData![i]["items"][j]["product_variant"]["price"] *
              _cartData![i]["items"][j]["quantity"];
        }
      }
    }
    setState(() {});
  }

  _deleteProduct(dynamic indexCategory, dynamic indexProduct) async {
    // call api

    final productId = _cartData![indexCategory]["items"][indexProduct]
        ["product_variant"]["product_id"];
    final payload = {
      "product_variant_id": _cartData![indexCategory]["items"][indexProduct]
          ["product_variant"]["id"]
    };
    setState(() {
      _cartData![indexCategory]["items"].removeAt(indexProduct);
      if (_cartData![indexCategory]["items"].isEmpty) {
        _cartData!.removeAt(indexCategory);
      }
    });
    await _callDeleteProductApi(productId, payload);
  }

  _updateQuantity(
      bool isPlus, dynamic indexCategory, dynamic indexProduct) async {
    // call api
    final productId = _cartData![indexCategory]["items"][indexProduct]
        ["product_variant"]["product_id"];
    final payload = {
      "product_variant_id": _cartData![indexCategory]["items"][indexProduct]
          ["product_variant"]["id"],
      "quantity": _cartData![indexCategory]["items"][indexProduct]["quantity"]
    };
    if (isPlus) {
      _cartData![indexCategory]["items"][indexProduct]["quantity"] += 1;
    } else {
      if (_cartData![indexCategory]["items"][indexProduct]["quantity"] != 0) {
        _cartData![indexCategory]["items"][indexProduct]["quantity"] -= 1;
      } else {
        await _deleteProduct(indexCategory, indexProduct);
      }
    }
    setState(() {});
    await _callUpdateQuantityApi(productId, payload);
  }

  Future _callDeleteProductApi(dynamic id, dynamic data) async {
    await CartProductApi().deleteCartProductApi(id, data);
  }

  _callUpdateQuantityApi(dynamic id, dynamic data) async {
    await ref.read(cartProductsProvider.notifier).updateCartQuantity(id, data);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    Future.wait([_initData()]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  await ref
                      .read(cartProductsProvider.notifier)
                      .updateCartProductList(_cartData!);
                  popToPreviousScreen(context);
                },
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              const AppBarTitle(
                  title: CartMarketConstants.CART_MARKET_CART_TITLE),
              GestureDetector(
                onTap: () async {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: const Icon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _cartData = await CartProductApi().getCartProductApi();
              setState(() {
                _isLoading = true;
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            buildDivider(color: greyColor),
                            _isLoading
                                ? buildCircularProgressIndicator()
                                : _cartData!.isNotEmpty
                                    ? Column(
                                        children: List.generate(
                                            _cartData!.length, (index) {
                                        final data = _cartData![index];
                                        return _buildCartProductItem(
                                            data, index);
                                      }))
                                    : Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/empty_cart.png",
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                          buildSpacer(height: 20),
                                          buildTextContent(
                                              "Giỏ hàng trống !!", false,
                                              fontSize: 16,
                                              isCenterLeft: false),
                                          // buildSpacer(height: 20),
                                          // buildTextContent(
                                          //     "Giỏ hàng trống !!", false,
                                          //     fontSize: 16,
                                          //     isCenterLeft: false),
                                        ],
                                      ),
                          ],
                        ),
                        buildSpacer(height: 10),
                        SuggestListComponent(
                          context: context,
                          title: Flex(direction: Axis.horizontal, children: [
                            Flexible(
                                flex: 5,
                                child: Container(
                                  color: greyColor,
                                  height: 2,
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: buildTextContent(
                                  "Có thể bạn cũng thích", false,
                                  fontSize: 13, isCenterLeft: false),
                            ),
                            Flexible(
                                flex: 5,
                                child: Container(
                                  color: greyColor,
                                  height: 2,
                                )),
                          ]),
                          controller: _scrollController,
                          contentList: ref.watch(productsProvider).list,
                          isLoading: true,
                          isLoadingMore: ref.watch(productsProvider).isMore,
                        )
                      ],
                    ),
                  ),
                ),
                _cartData != null && _cartData!.isNotEmpty
                    ? _voucherAndBuyComponent()
                    : const SizedBox(),
              ],
            ),
          ),
        ));
  }

  Widget _buildCartProductItem(dynamic data, dynamic indexComponent,
      {bool isNotExist = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !isNotExist
                  ? Row(
                      children: [
                        // checkbox
                        Container(
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            width: 30,
                            child: Checkbox(
                                value: _cartData![indexComponent]?["items"]
                                    .every((element) {
                                  return element?["check"] == true;
                                }),
                                onChanged: (value) {
                                  for (int i = 0;
                                      i <
                                          _cartData?[indexComponent]?["items"]
                                              .length;
                                      i++) {
                                    _cartData![indexComponent]?["items"]?[i]
                                        ?["check"] = value as bool;
                                  }
                                  setState(() {});
                                },
                                shape: checkBoxBorder)),
                        // icon and title
                        Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            FontAwesomeIcons.store,
                            size: 19,
                          ),
                        ),
                        SizedBox(
                            width: 180,
                            child: buildTextContent(
                                (data?["title"]) ?? "--", true,
                                fontSize: 16, overflow: TextOverflow.ellipsis)),
                        const SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(
                            FontAwesomeIcons.angleRight,
                            size: 19,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            FontAwesomeIcons.memory,
                            size: 19,
                          ),
                        ),
                        SizedBox(
                            width: 180,
                            child: buildTextContent(
                                "Sản phẩm không tồn tại", true,
                                fontSize: 17, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
              // fix
              buildTextContent("Sửa", false,
                  fontSize: 15, colorWord: greyColor),
            ],
          ),
        ),
        Column(
          children: [
            buildDivider(
              color: greyColor,
            ),
            buildSpacer(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                children: List.generate(data?["items"].length, (index) {
                  final itemData = data?["items"]?[index];
                  bool isOutOfStock = itemData['quantity'] >
                      itemData?['product_variant']?['inventory_quantity'];
                  return Stack(
                    children: [
                      Column(
                        children: [
                          index != 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: buildDivider(color: greyColor),
                                )
                              : const SizedBox(),
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    await _deleteProduct(indexComponent, index);
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 110,
                                  width: width,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    height: 80,
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            isNotExist || isOutOfStock
                                                ? const SizedBox(
                                                    width: 30,
                                                  )
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      right: 7,
                                                      bottom: 25.0,
                                                    ),
                                                    height: 30,
                                                    width: 30,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Checkbox(
                                                        value: _cartData![
                                                                    indexComponent]
                                                                ["items"][index]
                                                            ["check"] as bool,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _cartData![indexComponent]
                                                                            [
                                                                            "items"]
                                                                        [index]
                                                                    ["check"] =
                                                                value as bool;
                                                          });
                                                        },
                                                        shape: checkBoxBorder),
                                                  ),
                                            // : const SizedBox(),
                                            InkWell(
                                              onTap: () {
                                                pushToNextScreen(
                                                    context,
                                                    DetailProductMarketPage(
                                                      id: itemData?[
                                                                  "product_variant"]
                                                              ?["product_id"]
                                                          .toString(),
                                                    ));
                                              },
                                              child: Container(
                                                alignment: Alignment.topCenter,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: ImageCacheRender(
                                                  height: 80.0,
                                                  width: 80.0,
                                                  path: itemData?["product_variant"]
                                                                  ?["image"] !=
                                                              null &&
                                                          itemData?["product_variant"]
                                                                  ?["image"]
                                                              .isNotEmpty
                                                      ? (itemData?["product_variant"]
                                                                  ?["image"]
                                                              ?["url"]) ??
                                                          (itemData?["product_variant"]
                                                                  ?["image"]
                                                              ?["preview_url"])
                                                      : "https://www.w3schools.com/w3css/img_lights.jpg",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  pushToNextScreen(
                                                      context,
                                                      DetailProductMarketPage(
                                                        id: itemData[
                                                                    "product_variant"]
                                                                ["product_id"]
                                                            .toString(),
                                                      ));
                                                },
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 190,
                                                            child: Text(
                                                              itemData[
                                                                      "product_variant"]
                                                                  ["title"],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          isNotExist
                                                              ? GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    await _deleteProduct(
                                                                        indexComponent,
                                                                        index);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        boxDecoration,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    child:
                                                                        buildTextContent(
                                                                      "Xóa",
                                                                      false,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox()
                                                        ],
                                                      ),
                                                      buildSpacer(height: 8),
                                                      buildTextContent(
                                                          itemData["product_variant"]
                                                                          [
                                                                          "option1"] ==
                                                                      null &&
                                                                  itemData["product_variant"]
                                                                          [
                                                                          "option2"] ==
                                                                      null
                                                              ? "Phân loại: Không có"
                                                              : "Phân loại  ${itemData["product_variant"]["option1"] ?? ""} ${itemData["product_variant"]["option2"] ?? ""}",
                                                          false,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          fontSize: 11,
                                                          colorWord: greyColor),
                                                      buildSpacer(height: 8),
                                                      buildTextContent(
                                                          "₫ ${formatCurrency(itemData["product_variant"]["price"]).toString()}",
                                                          true,
                                                          fontSize: 15,
                                                          colorWord: red),
                                                      buildSpacer(height: 8),
                                                    ]),
                                              ),
                                              buildSpacer(height: 5),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _updateQuantity(
                                                          false,
                                                          indexComponent,
                                                          index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: greyColor,
                                                              width: 0.4)),
                                                      height: 25,
                                                      width: 25,
                                                      child: const Icon(
                                                        FontAwesomeIcons.minus,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: greyColor,
                                                            width: 0.2)),
                                                    height: 25,
                                                    width: 30,
                                                    child: Center(
                                                        child: Text(
                                                            itemData["quantity"]
                                                                .toString())),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _updateQuantity(
                                                          true,
                                                          indexComponent,
                                                          index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: greyColor,
                                                              width: 0.2)),
                                                      height: 25,
                                                      width: 25,
                                                      child: const Icon(
                                                          FontAwesomeIcons.plus,
                                                          size: 16),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                isNotExist
                                    ? Container(
                                        alignment: Alignment.bottomRight,
                                        height: 110,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: 90,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: red, width: 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: buildTextContent(
                                              "Tương tự", false,
                                              fontSize: 14,
                                              colorWord: red,
                                              isCenterLeft: false),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                      isOutOfStock
                          ? Positioned.fill(
                              child: Container(
                                  color: greyColor.withOpacity(0.5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Container(
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 7, vertical: 5),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(7),
                                      //       color: greyColor,
                                      //     ),
                                      //     child: Text(
                                      //       "Xóa",
                                      //       style: TextStyle(fontSize: 13),
                                      //     )),
                                      const SizedBox(),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              shadowColor: transparent,
                                              fixedSize: const Size(120, 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: const BorderSide(
                                                      color: greyColor)),
                                              backgroundColor: transparent),
                                          onPressed: () {},
                                          child: Text(
                                            "Tương tự",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color),
                                          ),
                                        ),
                                      ),
                                      // buildMarketButton(
                                      //     contents: [
                                      //       Text(
                                      //         "Tương tự",
                                      //         style: TextStyle(
                                      //             color: Theme.of(context)
                                      //                 .textTheme
                                      //                 .bodyLarge!
                                      //                 .color),
                                      //       ),
                                      //     ],
                                      //     width: 150,
                                      //     height: 10,
                                      //     bgColor: transparent,
                                      //     isHaveBoder: true),
                                    ],
                                  )),
                            )
                          : const SizedBox()
                    ],
                  );
                }),
              ),
            ),
            const CrossBar(
              height: 7,
              opacity: 0.2,
              margin: 4,
            )
          ],
        )
      ],
    );
  }

  Widget _voucherAndBuyComponent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.virusCovid,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        buildTextContent(
                          "Voucher",
                          false,
                          fontSize: 16,
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showCustomBottomSheet(context, height - 50,
                            title: "Chọn voucher của bạn",
                            suffixWidget: const Icon(
                              FontAwesomeIcons.circleInfo,
                              size: 17,
                            ), widget: StatefulBuilder(
                                builder: (context, setStatefull) {
                          return Column(
                            children: [
                              buildDivider(color: greyColor),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildCustomMarketInput(_searchController,
                                      width * 0.7, "Nhập mã giảm giá",
                                      onChangeFunction: (value) {
                                    if (value.length > 10) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      setStatefull(() {});
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      setStatefull(() {});
                                    }
                                  }),
                                  _isLoading
                                      ? buildCircularProgressIndicator()
                                      : const SizedBox(),
                                  buildMarketButton(contents: [
                                    buildTextContent("Áp dụng", false,
                                        fontSize: 13)
                                  ], width: width * 0.2, marginTop: 0),
                                ],
                              )
                            ],
                          );
                        }));
                      },
                      child: Row(
                        children: [
                          buildTextContent("Chọn hoặc nhập mã", false,
                              fontSize: 16, colorWord: greyColor),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            FontAwesomeIcons.arrowRight,
                            size: 17,
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          buildDivider(
            color: greyColor,
          ),
          //ecoin
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.virusCovid,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        buildTextContent(
                          "Sử dụng Ecoin",
                          false,
                          fontSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                        height: 20,
                        child: Switch(value: false, onChanged: (value) {})),
                  ]),
            ),
          ),
          buildDivider(
            color: greyColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    height: 30,
                    width: 30,
                    child: Checkbox(
                        value: _checkBoxAll(),
                        onChanged: (value) {
                          for (int i = 0; i < _cartData!.length; i++) {
                            for (int j = 0;
                                j < _cartData![i]["items"].length;
                                j++) {
                              _cartData![i]["items"][j]["check"] = value;
                            }
                          }
                          setState(() {});
                        },
                        shape: checkBoxBorder),
                  ),
                  buildTextContent("Tất cả", false,
                      colorWord: greyColor, fontSize: 15),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextContent("Tổng thanh toán: ", false,
                        colorWord: greyColor, fontSize: 12),
                    const SizedBox(
                      height: 5,
                    ),
                    buildTextContent("₫${formatCurrency(_allMoney)}", true,
                        colorWord: red, fontSize: 16),
                  ],
                ),
              ),
              Container(
                child: buildMarketButton(
                    marginTop: 0,
                    width: width * 0.3,
                    bgColor: Colors.red,
                    contents: [buildTextContent("Mua", false, fontSize: 13)],
                    function: () async {
                      if (_allMoney == 0) {
                        buildMessageDialog(
                            context, "Bạn chưa chọn sản phẩm nào để mua.",
                            oneButton: true, oKFunction: () {
                          popToPreviousScreen(context);
                        });
                        return;
                      }
                      await ref
                          .read(cartProductsProvider.notifier)
                          .updateCartProductList(_cartData!);
                      // ignore: use_build_context_synchronously
                      pushToNextScreen(
                          context,
                          PaymentMarketPage(
                            productDataList: _cartData!,
                          ));
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCustomMarketInput(
      TextEditingController controller, double width, String hintText,
      {double? height,
      IconData? iconData,
      TextInputType? keyboardType,
      void Function(String)? onChangeFunction}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      height: height ?? 40,
      width: width,
      child: TextFormField(
        controller: controller,
        maxLines: null,
        keyboardType: keyboardType ?? TextInputType.text,
        onChanged: (value) {},
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: red),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          hintText: hintText,
        ),
      ),
    );
  }
}
