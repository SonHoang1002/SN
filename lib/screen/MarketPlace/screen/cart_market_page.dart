import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/cart_apis.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/cart_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/notification_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/payment_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartMarketPage extends ConsumerStatefulWidget {
  const CartMarketPage({super.key});

  @override
  ConsumerState<CartMarketPage> createState() => _CartMarketPageState();
}

class _CartMarketPageState extends ConsumerState<CartMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _cartData;
  double _allMoney = 0;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final initCartData =
          await ref.read(cartProductsProvider.notifier).initCartProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _isLoading
                      ? buildCircularProgressIndicator()
                      : Column(
                          children: List.generate(_cartData!.length, (index) {
                          final data = _cartData![index];
                          return _buildCartProductItem(data, index);
                        })),
                ],
              ),
            ),
            _voucherAndBuyComponent()
          ],
        ));
  }

  Future _initData() async {
    _cartData = null;
    if (_cartData == null || _cartData!.isEmpty) {
      Future.delayed(Duration.zero, () async {
        final initCartData =
            await ref.read(cartProductsProvider.notifier).initCartProductList();
      });
      _cartData = ref.watch(cartProductsProvider).listCart;
    }
    _updateTotalPrice();
    setState(() {
      _isLoading = false;
    });
  }

// _update
  Widget _buildCartProductItem(dynamic data, dynamic indexComponent) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // checkbox
                  Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 30,
                      width: 30,
                      child: Checkbox(
                          value: _cartData![indexComponent]["items"]
                              .every((element) {
                            return element["check"] == true;
                          }),
                          onChanged: (value) {
                            for (int i = 0;
                                i < _cartData?[indexComponent]["items"].length;
                                i++) {
                              _cartData![indexComponent]["items"][i]["check"] =
                                  value as bool;
                            }
                            setState(() {});
                          })),
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
                      child: buildTextContent(data["title"], true,
                          fontSize: 17, overflow: TextOverflow.ellipsis)),
                  const SizedBox(
                    height: 40,
                    width: 40,
                    child: Icon(
                      FontAwesomeIcons.angleRight,
                      size: 19,
                    ),
                  ),
                ],
              ),
              // fix
              buildTextContent("Sửa", false,
                  fontSize: 15, colorWord: blueColor),
            ],
          ),
        ),
        buildDivider(
          color: red,
        ),
        buildSpacer(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: List.generate(data["items"].length, (index) {
              final itemData = data["items"][index];
              return InkWell(
                onTap: () {
                  pushToNextScreen(
                      context,
                      DetailProductMarketPage(
                        id: itemData["product_variant"]["product_id"]
                            .toString(),
                      ));
                },
                child: Column(
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
                            onPressed: (context) {
                              _deleteProduct(indexComponent, index);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Container(
                        height: 100,
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  height: 30,
                                  width: 30,
                                  child: Checkbox(
                                      value: _cartData![indexComponent]["items"]
                                          [index]["check"] as bool,
                                      onChanged: (value) {
                                        _cartData![indexComponent]["items"]
                                            [index]["check"] = value as bool;
                                        setState(() {});
                                      })),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: ImageCacheRender(
                                  height: 100.0,
                                  width: 100.0,
                                  path: itemData["product_variant"]["image"] !=
                                              null &&
                                          itemData["product_variant"]["image"]
                                              .isNotEmpty
                                      ? itemData["product_variant"]["image"]
                                          ["url"]
                                      : "https://www.w3schools.com/w3css/img_lights.jpg",
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      itemData["product_variant"]["title"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  buildSpacer(height: 10),
                                  Text(
                                    itemData["product_variant"]["option1"] ==
                                                null &&
                                            itemData["product_variant"]
                                                    ["option2"] ==
                                                null
                                        ? "Phân loại: Không có"
                                        : "Phân loại  ${itemData["product_variant"]["option1"] ?? ""} ${itemData["product_variant"]["option2"] ?? ""}}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  buildSpacer(height: 10),
                                  buildTextContent(
                                      "₫ ${itemData["product_variant"]["price"].toString()}",
                                      true,
                                      fontSize: 15,
                                      colorWord: red),
                                  buildSpacer(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _updateQuantity(
                                              false, indexComponent, index);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: greyColor,
                                                  width: 0.4)),
                                          height: 20,
                                          width: 20,
                                          child: const Icon(
                                            FontAwesomeIcons.minus,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: greyColor, width: 0.2)),
                                        height: 20,
                                        width: 25,
                                        child: Center(
                                            child: Text(itemData["quantity"]
                                                .toString())),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _updateQuantity(
                                              true, indexComponent, index);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: greyColor,
                                                  width: 0.2)),
                                          height: 20,
                                          width: 20,
                                          // padding: EdgeInsets.all(10),
                                          child: const Icon(
                                              FontAwesomeIcons.plus,
                                              size: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        Container(
          height: 5,
          color: greyColor,
          margin: const EdgeInsets.symmetric(vertical: 10),
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
                    Row(
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
                  ]),
            ),
          ),
          buildDivider(
            color: red,
          ),
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
            color: red,
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
                          })),
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
                    buildTextContent("₫${_allMoney}", true,
                        colorWord: red, fontSize: 16),
                  ],
                ),
              ),
              Container(
                child: buildButtonForMarketWidget(
                    marginTop: 0,
                    width: width * 0.3,
                    bgColor: Colors.red,
                    title: "Mua",
                    function: () async {
                      await ref
                          .read(cartProductsProvider.notifier)
                          .updateCartProductList(_cartData!);
                      pushToNextScreen(context, const PaymentMarketPage());
                    }),
              ),
            ],
          ),
        ],
      ),
    );
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

  _deleteProduct(dynamic indexCategory, dynamic indexProduct) {
    // call api
    _callDeleteProductApi(
        _cartData![indexCategory]["items"][indexProduct]["product_variant"]
            ["product_id"],
        {
          "product_variant_id": _cartData![indexCategory]["items"][indexProduct]
              ["product_variant"]["id"]
        });
    _cartData![indexCategory]["items"].removeAt(indexProduct);
    if (_cartData![indexCategory]["items"].isEmpty) {
      _cartData!.removeAt(indexCategory);
    }
    setState(() {});
  }

  _updateQuantity(bool isPlus, dynamic indexCategory, dynamic indexProduct) {
    if (isPlus) {
      _cartData![indexCategory]["items"][indexProduct]["quantity"] += 1;
    } else {
      if (_cartData![indexCategory]["items"][indexProduct]["quantity"] != 0) {
        _cartData![indexCategory]["items"][indexProduct]["quantity"] -= 1;
      }
    }
    // call api
    _callUpdateQuantityApi({
      "product_variant_id": _cartData![indexCategory]["items"][indexProduct]
          ["product_variant"]["id"],
      "quantity": _cartData![indexCategory]["items"][indexProduct]["quantity"]
    });
    setState(() {});
  }

  _callDeleteProductApi(dynamic id, dynamic data) async {
    print("_callDeleteProductApi $id - $data");
    final response = await CartProductApi().deleteCartProductApi(id, data);
    print("_callDeleteProductApi $response");
  }

  _callUpdateQuantityApi(dynamic data) async {
    print("cart _callUpdateQuantityApi");
    final response =
        await ref.read(cartProductsProvider.notifier).updateCartQuantity(data);
  }
}
