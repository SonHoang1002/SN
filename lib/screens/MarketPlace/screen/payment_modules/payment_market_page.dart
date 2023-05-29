import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/cart_product_provider.dart';
import 'package:market_place/providers/market_place_providers/delivery_addresses_provider.dart';
import 'package:market_place/providers/market_place_providers/repo_variables/order_data_saver.dart';
import 'package:market_place/screens/MarketPlace/screen/address_module/choose_address_page.dart';
import 'package:market_place/screens/MarketPlace/screen/payment_modules/checkout_payment_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/apis/market_place_apis/order_product_apis.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

class PaymentMarketPage extends ConsumerStatefulWidget {
  const PaymentMarketPage({super.key});

  @override
  ConsumerState<PaymentMarketPage> createState() => _PaymentMarketPageState();
}

class _PaymentMarketPageState extends ConsumerState<PaymentMarketPage> {
  late double width = 0;
  late double height = 0;
  TextEditingController controller = TextEditingController(text: "");
  List<dynamic>? _allProductList = [];
  List<dynamic>? _filterProductList = [];
  List<dynamic>? _addressData;
  dynamic _selectedAddress;
  bool _isLoading = false;
  double shoppingFee = 18300;
  double reduceFree = 10000;
  dynamic _mainData = {};
  List<dynamic> paymentMethods = [
    {
      "key": "wallet",
      "value": 1,
      "status": true,
      "title": "EmsoCoin",
    },
    {
      "key": "direct",
      "value": 0,
      "status": false,
      "title": "Thanh toán khi nhận hàng",
    },
    // {
    //   "key": "bank",
    //   "value":0,"status": false,
    //   "title": "Thanh toán qua ngân hàng",
    // }
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final addressData = await ref
          .read(deliveryAddressProvider.notifier)
          .getDeliveryAddressList();
    });
  }

  Future _initData() async {
    _mainData = ref.watch(selectedAddressSaverProvider).selectedAddressSaver;

    if (_allProductList!.isEmpty) {
      _allProductList = await ref.watch(cartProductsProvider).listCart;
      _filterProduct();
    }
    if (_addressData == null || _addressData!.isEmpty) {
      _addressData = await ref.watch(deliveryAddressProvider).addressList;
    }
    _selectedAddress =
        ref.watch(selectedAddressSaverProvider).selectedAddressSaver;
    if (_selectedAddress.isEmpty) {
      if (_addressData!.isNotEmpty) {
        _selectedAddress = _addressData![0];
      }
    }
    setState(() {});
  }

  void _filterProduct() {
    List<dynamic> filterProductList = _allProductList!;
    for (var childShop in _allProductList!) {
      List<dynamic> itemsList = childShop["items"].where((element) {
        return element["check"] == true;
      }).toList();
      filterProductList[_allProductList!.indexOf(childShop)]["items"] =
          itemsList;
    }
    List<dynamic> primaryFilterList = filterProductList;
    for (var childFilterProduct in List.from(filterProductList)) {
      if (childFilterProduct["items"].isEmpty) {
        primaryFilterList
            .removeAt(filterProductList.indexOf(childFilterProduct));
      }
    }
    _filterProductList = primaryFilterList;
  }

  double _caculateMoneyEveryShop(List<dynamic> data, dynamic shoppingFee) {
    double sum = 0;
    data.forEach((element) {
      sum = element["quantity"] * element["product_variant"]["price"];
    });
    return sum + shoppingFee;
  }

  double _totalCoreProductMoney() {
    double sum = 0;
    _filterProductList!.forEach((element) {
      element["items"].forEach((element) {
        sum += element["quantity"] * element["product_variant"]["price"];
      });
    });
    return sum;
  }

  double _totalAriseShipping() {
    double sum = 0;
    _filterProductList!.forEach((element) {
      sum += shoppingFee;
    });
    return sum;
  }

  double _totalReduceShipping() {
    double sum = 0;
    _filterProductList!.forEach((element) {
      sum += reduceFree;
    });
    return sum;
  }

  double _totalReduceVoucher() {
    return 1000.0;
  }

  double _totalPayment() {
    return _totalCoreProductMoney() +
        _totalAriseShipping() -
        _totalReduceShipping() -
        _totalReduceVoucher();
  }

  Future<dynamic> setDataForOrder() async {
    setState(() {
      _isLoading = true;
    });
    _mainData = {
      "order": {
        "delivery_address_id":
            _selectedAddress["id"] + _selectedAddress["name"],
        "shipping_method_id": paymentMethods.where((element) {
          return element["status"] == true;
        }).toList()[0]["value"],
        "delivery_fee": "25000"
      },
      "order_items_attributes": _filterProductList!.map((childFilter) {
        return {
          "page_id": childFilter["page_id"],
          "items": childFilter["items"].map((ele) {
            return {
              "product_variant_id": ele["product_variant"]["id"],
              "quantity": ele["quantity"]
            };
          }).toList()
        };
      }).toList()
    };
    final response = await OrderApis().createBuyerOrderApi(_mainData);
    setState(() {
      _isLoading = false;
    });
    return response;
  }

  @override
  void dispose() {
    super.dispose();
    _allProductList = [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Future.wait([_initData()]);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            GestureDetector(
                onTap: () {
                  popToPreviousScreen(context);
                },
                child: const AppBarTitle(text: "Thanh toán")),
            const SizedBox()
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _isLoading
            ? buildCircularProgressIndicator()
            : Column(
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(children: [
                          buildDivider(
                            height: 1,
                            color: red,
                          ),
                          _buildGeneralWidget(
                            "Đã áp dụng Mã miễn phí vận chuyển",
                            isHavePreffixWidget: true,
                            prefixIconData: FontAwesomeIcons.car,
                          ),
                          const CrossBar(
                            height: 5,
                          ),
                          _buildAddressWidget(),
                          buildSpacer(height: 7),
                          const CrossBar(
                            margin: 0,
                            height: 5,
                          ),
                          buildSpacer(height: 3),
                          Column(
                            children: List.generate(_filterProductList!.length,
                                (index) {
                              final data = _filterProductList![index];
                              return _buildPaymentProduct(data);
                            }).toList(),
                          ),
                          buildSpacer(height: 10),
                          const CrossBar(
                            margin: 0,
                            height: 5,
                          ),
                          _buildVoucherAndSelect(
                              title: "Emso Voucher",
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 15)),
                          const CrossBar(
                            margin: 0,
                            height: 5,
                          ),
                          _buildGeneralWidget("Không thể sử dụng xu",
                              isHavePreffixWidget: true,
                              isHaveSuffixWidget: true,
                              prefixIconData: FontAwesomeIcons.coins,
                              suffixWidget: Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                      value: true, onChanged: (value) {}))),
                          const CrossBar(
                            margin: 0,
                            height: 5,
                          ),
                          _buildGeneralWidget("Phương thức thanh toán",
                              content: paymentMethods.where((element) {
                                return element["status"] == true;
                              }).toList()[0]["title"],
                              isHavePreffixWidget: true,
                              isHaveSuffixWidget: true, function: () {
                            showCustomBottomSheet(context, 500,
                                title: "Phương thức thanh toán", widget:
                                    StatefulBuilder(
                                        builder: (context, setStatefull) {
                              return Column(
                                  children: List.generate(paymentMethods.length,
                                      (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: GeneralComponent(
                                    [
                                      buildTextContent(
                                          paymentMethods[index]["title"], false,
                                          isCenterLeft: false,
                                          colorWord: paymentMethods[index]
                                                  ["status"]
                                              ? red
                                              : greyColor),
                                    ],
                                    isHaveBorder: true,
                                    borderColor: paymentMethods[index]["status"]
                                        ? red
                                        : greyColor,
                                    changeBackground: transparent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    function: () {
                                      setStatefull(() {
                                        paymentMethods.forEach((ele) {
                                          ele["status"] = false;
                                        });
                                        paymentMethods[index]["status"] = true;
                                      });
                                      setState(() {});
                                      popToPreviousScreen(context);
                                    },
                                  ),
                                );
                              }));
                            }));
                          }),
                          const CrossBar(
                            margin: 0,
                            height: 5,
                          ),
                          _buildVoucherAndSelect(
                              title: "Thông tin thanh toán",
                              subTitle: "",
                              haveSuffixIcon: false,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                          _buildVoucherAndSelect(
                              title: "Tổng tiền hàng",
                              subTitle:
                                  "₫${formatCurrency(_totalCoreProductMoney())}",
                              haveSuffixIcon: false,
                              havePrefixIcon: false,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                          _buildVoucherAndSelect(
                              title: "Tổng tiền phí vận chuyển",
                              subTitle:
                                  "₫${formatCurrency(_totalAriseShipping())}",
                              haveSuffixIcon: false,
                              havePrefixIcon: false,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                          _buildVoucherAndSelect(
                              title: "Giảm chi phí vận chuyển",
                              subTitle:
                                  "-₫${formatCurrency(_totalReduceShipping())}",
                              haveSuffixIcon: false,
                              havePrefixIcon: false,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                          _buildVoucherAndSelect(
                              title: "Tổng cộng voucher giảm giá",
                              subTitle:
                                  "-₫${formatCurrency(_totalReduceVoucher())}",
                              haveSuffixIcon: false,
                              havePrefixIcon: false,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                          _buildVoucherAndSelect(
                              title: "Tổng thanh toán",
                              subTitle: "₫${formatCurrency(_totalPayment())}",
                              haveSuffixIcon: false,
                              havePrefixIcon: false,
                              subTitleColor: red,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              fontSize: 15),
                        ])),
                  ),
                  buildMarketButton(
                      width: width,
                      height: 40,
                      bgColor: Colors.orange[300],
                      contents: [
                        buildTextContent("Đặt hàng", false,
                            fontSize: 15, isCenterLeft: false)
                      ],
                      marginTop: 0,
                      radiusValue: 0,
                      isHaveBoder: false,
                      function: () async {
                        buildMessageDialog(
                            context, "Bạn chắc chắn thanh toán đơn hàng này ??",
                            oKFunction: () async {
                          popToPreviousScreen(context);

                          final response = await setDataForOrder();
                          if (response.isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            buildMessageDialog(context, "Đặt hàng thành công",
                                oneButton: true, oKFunction: () {
                              popToPreviousScreen(context);
                              pushAndReplaceToNextScreen(
                                  context,
                                  CheckoutPaymentPage(
                                    paymentKey: paymentMethods.where((element) {
                                      return element["status"] == true;
                                    }).toList()[0]["value"],
                                  ));
                            });
                          }
                        });
                      }),
                ],
              ),
      ),
    );
  }

  Widget _buildAddressWidget() {
    return InkWell(
      onTap: () async {
        pushToNextScreen(context, const ChooseAddressPage());
      },
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(
                "Địa chỉ nhận hàng",
                false,
                fontSize: 13,
              )
            ],
            prefixWidget: const Icon(
              FontAwesomeIcons.locationCrosshairs,
              size: 15,
              color: red,
            ),
            isHaveBorder: false,
            borderRadiusValue: 0,
            changeBackground: transparent,
            padding: const EdgeInsets.only(left: 10, bottom: 7),
            function: () async {
              pushToNextScreen(context, const ChooseAddressPage());
            },
          ),
          GeneralComponent(
            _selectedAddress != null
                ? _selectedAddress!.isNotEmpty
                    ? [
                        buildTextContent(
                            "${_selectedAddress["name"]} | ${_selectedAddress["phone_number"]}",
                            false,
                            fontSize: 15),
                        buildTextContent(
                            "${_selectedAddress["detail_addresses"]}, ${_selectedAddress["addresses"]} ",
                            false,
                            fontSize: 15),
                      ]
                    : [
                        buildTextContent("Bạn chưa có địa chỉ nào", false,
                            fontSize: 15),
                      ]
                : [
                    buildTextContent("-- | --", false, fontSize: 13),
                    buildTextContent("----------- ", false, fontSize: 13),
                  ],
            prefixWidget: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: SizedBox(),
            ),
            suffixWidget: const Icon(
              FontAwesomeIcons.chevronRight,
              size: 15,
            ),
            isHaveBorder: false,
            borderRadiusValue: 0,
            changeBackground: transparent,
            padding: const EdgeInsets.only(left: 10),
            function: () async {
              pushToNextScreen(context, const ChooseAddressPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProduct(dynamic data) {
    if (data["items"].isEmpty) {
      return const SizedBox();
    }
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ten shop
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  FontAwesomeIcons.store,
                  size: 15,
                ),
              ),
              SizedBox(
                  width: 180,
                  child: buildTextContent(data["title"], true,
                      fontSize: 17, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
      buildDivider(
        color: red,
      ),
      buildSpacer(height: 10),
      Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: [
              Column(
                  children: List.generate(data["items"].length, (index) {
                return InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        _buildChildPaymentProduct(data["items"][index])
                      ],
                    ));
              })),
              buildSpacer(height: 10),
              buildDivider(height: 1, color: red),
              _buildVoucherAndSelect(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15)),
              buildDivider(height: 1, color: red),
              _customGeneralComponent([
                buildTextContent("Phương thức vận chuyển (nhấn để chọn)", false,
                    fontSize: 13, colorWord: Colors.green),
                buildSpacer(height: 10),
              ], bgColor: Colors.green.withOpacity(0.4), function: () {}),
              buildDivider(height: 1, color: greyColor),
              _customGeneralComponent(
                  [buildTextContent("Nhanh", false, fontSize: 13)],
                  bgColor: Colors.green.withOpacity(0.4),
                  suffixWidget: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                        buildTextContent(
                            "₫${formatCurrency(shoppingFee)}", false,
                            fontSize: 13),
                        const Icon(
                          FontAwesomeIcons.chevronRight,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                  suffixFlexValue: 6),
              _customGeneralComponent([
                buildTextContent("Nhận hàng vào T5 Th03 - 15 Th03", false,
                    fontSize: 11),
                buildSpacer(height: 10)
              ],
                  bgColor: Colors.green.withOpacity(0.4),
                  suffixWidget: const SizedBox(),
                  suffixFlexValue: 6),
              buildDivider(height: 1, color: red),
              _buildInput(controller, width),
              buildDivider(height: 1, color: red),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTextContent(
                        "Tổng số tiền (${data["items"].length} sản phẩm)",
                        false,
                        fontSize: 13),
                    buildTextContent(
                        "₫${formatCurrency(_caculateMoneyEveryShop(data["items"], shoppingFee))}",
                        true,
                        fontSize: 16,
                        colorWord: red),
                  ],
                ),
              )
            ],
          ))
    ]);
  }

  Widget _buildChildPaymentProduct(dynamic childItemData) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            ImageCacheRender(
              height: 80.0,
              width: 80.0,
              path: childItemData["product_variant"]["image"] != null
                  ? childItemData["product_variant"]["image"]["url"]
                  : "https://kynguyenlamdep.com/wp-content/uploads/2022/01/hinh-anh-meo-con-sieu-cute-700x467.jpg",
            ),
            buildSpacer(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTextContent(
                      childItemData["product_variant"]["title"], false,
                      fontSize: 15,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  buildSpacer(height: 10),
                  buildTextContent(
                    "${childItemData["product_variant"]["option1"] ?? ""} ${childItemData["product_variant"]["option2"] != null ? " - ${childItemData["product_variant"]["option2"]}" : ""}",
                    false,
                    colorWord: greyColor[700],
                    fontSize: 13,
                  ),
                  buildSpacer(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent(
                        "₫${formatCurrency(childItemData["product_variant"]["price"])}",
                        false,
                        colorWord: greyColor[700],
                        fontSize: 13,
                      ),
                      buildTextContent(
                        "x${childItemData["quantity"]}",
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
        ));
  }
//general

  Widget _buildVoucherAndSelect(
      {String? title,
      Color? titleColor,
      String? subTitle,
      Color? subTitleColor,
      Function? function,
      bool haveSuffixIcon = true,
      bool havePrefixIcon = true,
      EdgeInsets? padding,
      double? fontSize}) {
    return GestureDetector(
        onTap: () {
          function != null
              ? function()
              : showCustomBottomSheet(context, 500, title: "Chọn  voucher");
        },
        child: Container(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  havePrefixIcon
                      ? Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.moneyBill1,
                              size: 15,
                            ),
                            buildSpacer(width: 10),
                          ],
                        )
                      : const SizedBox(),
                  buildTextContent(title ?? "Voucher của Shop", false,
                      fontSize: fontSize ?? 13, colorWord: titleColor),
                ],
              ),
              Row(
                children: [
                  buildTextContent(subTitle ?? "Chọn hoặc nhập mã", false,
                      fontSize: fontSize ?? 13, colorWord: subTitleColor),
                  haveSuffixIcon
                      ? Row(
                          children: [
                            buildSpacer(width: 5),
                            const Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 15,
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildGeneralWidget(String title,
      {String? content,
      bool isHavePreffixWidget = false,
      bool isHaveSuffixWidget = false,
      IconData? prefixIconData,
      IconData? suffixIconData,
      Widget? suffixWidget,
      Function? function}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: GeneralComponent(
        [
          buildTextContent(
            title,
            false,
            fontSize: 12,
          ),
          content != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: buildTextContent(
                    content,
                    true,
                    fontSize: 13,
                  ),
                )
              : const SizedBox(),
        ],
        prefixWidget: isHavePreffixWidget
            ? Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: blackColor.withOpacity(.2)),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(
                    prefixIconData ?? FontAwesomeIcons.moneyBill1,
                    size: 16,
                  ),
                ),
              )
            : null,
        suffixWidget: isHaveSuffixWidget
            ? suffixWidget ??
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Icon(
                      suffixIconData ?? FontAwesomeIcons.chevronRight,
                      size: 16,
                    ),
                  ),
                )
            : null,
        function: () {
          function != null ? function() : null;
        },
        changeBackground: transparent,
        padding: const EdgeInsets.symmetric(vertical: 5),
      ),
    );
  }

  Widget _customGeneralComponent(List<Widget> listWidget,
      {Widget? prefixWidget,
      Widget? suffixWidget,
      int? suffixFlexValue,
      Color? bgColor,
      int? preffixFlexValue,
      EdgeInsets? padding,
      Function? function}) {
    return GeneralComponent(
      listWidget,
      prefixWidget: prefixWidget,
      suffixWidget: suffixWidget,
      preffixFlexValue: preffixFlexValue,
      suffixFlexValue: suffixFlexValue,
      isHaveBorder: false,
      borderRadiusValue: 0,
      changeBackground: bgColor ?? transparent,
      padding: padding ?? const EdgeInsets.only(top: 10, left: 10),
      function: function,
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    double width, {
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(
        left: 10,
      ),
      width: width,
      child: TextFormField(
        textAlign: TextAlign.right,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 20),
          border: InputBorder.none,
          hintText: "Lưu ý cho người bán",
          hintStyle: TextStyle(fontSize: 12),
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 13.0, right: 20),
            child: Text("Tin nhắn"),
          ),
        ),
      ),
    );
  }
}
