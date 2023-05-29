

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/cart_apis.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/cart_product_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/payment_modules/payment_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (ref.watch(cartProductsProvider).listCart == null ||
          ref.watch(cartProductsProvider).listCart.isEmpty) {
        final initCartData =
            await ref.read(cartProductsProvider.notifier).initCartProductList();
      }
    });
  }

  Future _initData() async {
    Future.delayed(Duration.zero, () async {
      if (ref.watch(cartProductsProvider).listCart == null ||
          ref.watch(cartProductsProvider).listCart.isEmpty) {
        final initCartData =
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

  _deleteProduct(dynamic indexCategory, dynamic indexProduct) {
    // call api
    _callDeleteProductApi(
        _cartData![indexCategory]["items"][indexProduct]["product_variant"]
            ["product_id"],
        {
          "product_variant_id": int.parse(_cartData![indexCategory]["items"]
              [indexProduct]["product_variant"]["id"])
        });

    setState(() {
      _cartData![indexCategory]["items"].removeAt(indexProduct);
      if (_cartData![indexCategory]["items"].isEmpty) {
        _cartData!.removeAt(indexCategory);
      }
    });
  }

  _updateQuantity(bool isPlus, dynamic indexCategory, dynamic indexProduct) {
    // call api
    _callUpdateQuantityApi(
        _cartData![indexCategory]["items"][indexProduct]["product_variant"]
            ["product_id"],
        {
          "product_variant_id": _cartData![indexCategory]["items"][indexProduct]
              ["product_variant"]["id"],
          "quantity": _cartData![indexCategory]["items"][indexProduct]
              ["quantity"]
        });
    if (isPlus) {
      _cartData![indexCategory]["items"][indexProduct]["quantity"] += 1;
    } else {
      if (_cartData![indexCategory]["items"][indexProduct]["quantity"] != 0) {
        _cartData![indexCategory]["items"][indexProduct]["quantity"] -= 1;
      } else {
        _deleteProduct(indexCategory, indexProduct);
      }
    }
    setState(() {});
  }

  Future _callDeleteProductApi(dynamic id, dynamic data) async {
    final response = await CartProductApi().deleteCartProductApi(id, data);
  }

  _callUpdateQuantityApi(dynamic id, dynamic data) async {
    final response = await ref
        .read(cartProductsProvider.notifier)
        .updateCartQuantity(id, data);
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
                  text: CartMarketConstants.CART_MARKET_CART_TITLE),
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
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      buildDivider(color: greyColor),
                      _isLoading
                          ? buildCircularProgressIndicator()
                          : Column(
                              children:
                                  List.generate(_cartData!.length, (index) {
                              final data = _cartData![index];
                              return _buildCartProductItem(data, index);
                            })),
                    ],
                  ),
                ),
                _voucherAndBuyComponent()
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
          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                value: _cartData![indexComponent]["items"]
                                    .every((element) {
                                  return element["check"] == true;
                                }),
                                onChanged: (value) {
                                  for (int i = 0;
                                      i <
                                          _cartData?[indexComponent]["items"]
                                              .length;
                                      i++) {
                                    _cartData![indexComponent]["items"][i]
                                        ["check"] = value as bool;
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
                  fontSize: 15, colorWord: blueColor),
            ],
          ),
        ),
        buildDivider(
          color: greyColor,
        ),
        buildSpacer(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: List.generate(data["items"].length, (index) {
              final itemData = data["items"][index];
              return Column(
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
                    child: Stack(
                      children: [
                        Container(
                          height: 110,
                          width: width,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    !isNotExist
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                              right: 7,
                                              bottom: 25.0,
                                            ),
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.topCenter,
                                            child: Checkbox(
                                                value:
                                                    _cartData![indexComponent]
                                                            ["items"][index]
                                                        ["check"] as bool,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _cartData![indexComponent]
                                                                ["items"][index]
                                                            ["check"] =
                                                        value as bool;
                                                  });
                                                },
                                                shape: checkBoxBorder),
                                          )
                                        : const SizedBox(),
                                    InkWell(
                                      onTap: () {
                                        pushToNextScreen(
                                            context,
                                            DetailProductMarketPage(
                                              id: itemData["product_variant"]
                                                      ["product_id"]
                                                  .toString(),
                                            ));
                                      },
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: ImageCacheRender(
                                          height: 80.0,
                                          width: 80.0,
                                          path: itemData["product_variant"]
                                                          ["image"] !=
                                                      null &&
                                                  itemData["product_variant"]
                                                          ["image"]
                                                      .isNotEmpty
                                              ? itemData["product_variant"]
                                                  ["image"]["url"]
                                              : "https://www.w3schools.com/w3css/img_lights.jpg",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          pushToNextScreen(
                                              context,
                                              DetailProductMarketPage(
                                                id: itemData["product_variant"]
                                                        ["product_id"]
                                                    .toString(),
                                              ));
                                        },
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  isNotExist
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            _deleteProduct(
                                                                indexComponent,
                                                                index);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                boxDecoration,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child:
                                                                buildTextContent(
                                                              "Xóa",
                                                              false,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                              buildSpacer(height: 8),
                                              Text(
                                                itemData["product_variant"]
                                                                ["option1"] ==
                                                            null &&
                                                        itemData["product_variant"]
                                                                ["option2"] ==
                                                            null
                                                    ? "Phân loại: Không có"
                                                    : "Phân loại  ${itemData["product_variant"]["option1"] ?? ""} ${itemData["product_variant"]["option2"] ?? ""}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
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
                                                  false, indexComponent, index);
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
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 90,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: red, width: 0.4),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: buildTextContent("Tương tự", false,
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
              );
            }),
          ),
        ),
        const CrossBar(
          height: 5,
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
                          context,
                          "Bạn chưa chọn sản phẩm nào !",
                          oneButton: true,
                        );
                        return;
                      }
                      await ref
                          .read(cartProductsProvider.notifier)
                          .updateCartProductList(_cartData!);
                      // ignore: use_build_context_synchronously
                      pushToNextScreen(context, const PaymentMarketPage());
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
