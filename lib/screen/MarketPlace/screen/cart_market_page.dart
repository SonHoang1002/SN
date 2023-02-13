import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevateButton_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/payment_market_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';
import 'notification_market_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartMarketPage extends StatefulWidget {
  @override
  State<CartMarketPage> createState() => _CartMarketPageState();
}

class _CartMarketPageState extends State<CartMarketPage> {
  late double width = 0;
  late double height = 0;
  bool _isOpenProductOfYou = false;
  Map<String, dynamic>? _cartData;
  List<bool>? _cartCheckBoxList = [];
  bool _all = false;
  double _allMoney = 0;
  @override
  void initState() {
    super.initState();
    _cartData = CartMarketConstants.CART_MARKET_CART_DATA;
    _buildCartCheckBox();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    _allMoney = 0;
    for (int i = 0; i < _cartCheckBoxList!.length; i++) {
      if (_cartCheckBoxList?[i] == true) {
        _allMoney += _cartData!['items'][i]["product_variant"]["price"] *
            _cartData!['items'][i]["quantity"];
      }
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackIconAppbar(),
              AppBarTitle(title: CartMarketConstants.CART_MARKET_CART_TITLE),
              GestureDetector(
                onTap: () {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: Icon(
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
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: [
                    Column(
                        children:
                            List.generate(_cartData?["items"].length, (index) {
                      final data = _cartData?["items"];
                      return _buildCartProductItem(
                          data[index]["product_variant"]["sku"],
                          data[index]["product_variant"]["title"],
                          data[index]["product_variant"]["image"]["url"],
                          data[index]["quantity"],
                          data[index]["product_variant"]["price"],
                          index);
                    })),
                  ],
                ),
              ),
            ),
            //
            _buildVoucherAndBuyProductBottomComponent()
          ],
        ));
  }

  Widget _buildCartProductItem(String sku, String title, String image,
      int quantity, double price, int index) {
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
                      margin: EdgeInsets.only(right: 5),
                      height: 30,
                      width: 30,
                      child: Checkbox(
                          value: _cartCheckBoxList?[index] ?? false,
                          onChanged: (value) {
                            _cartCheckBoxList?[index] = value as bool;
                            setState(() {});
                          })),
                  // icon and title
                  Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      FontAwesomeIcons.store,
                      size: 19,
                    ),
                  ),
                  buildTextContent(sku, true, fontSize: 17),
                  Container(
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
        Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            height: 80,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 80,
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 5),
                      height: 30,
                      width: 30,
                      child: Checkbox(
                          value: _cartCheckBoxList?[index] ?? false,
                          onChanged: (value) {
                            _cartCheckBoxList?[index] = value as bool;
                            setState(() {});
                          })),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: ImageCacheRender(
                      height: 80.0,
                      width: 80.0,
                      path: image,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // buildTextContent(title, false, fontSize: 17),
                      Container(
                        width: 200,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      buildTextContent(price.toString(), true,
                          fontSize: 15, colorWord: red),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: greyColor, width: 0.4)),
                            height: 25,
                            width: 25,
                            // padding: EdgeInsets.all(10),
                            child: Icon(
                              FontAwesomeIcons.minus,
                              size: 16,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: greyColor, width: 0.2)),
                            height: 25,
                            width: 40,
                            child: Center(child: Text(quantity.toString())),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: greyColor, width: 0.2)),
                            height: 25,
                            width: 25,
                            // padding: EdgeInsets.all(10),
                            child: Icon(FontAwesomeIcons.plus, size: 16),
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
        Container(
          height: 5,
          color: greyColor,
          margin: EdgeInsets.symmetric(vertical: 10),
        )
      ],
    );
  }

  _buildVoucherAndBuyProductBottomComponent() {
    return Container(
      // height: 120,
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
                        Icon(
                          FontAwesomeIcons.virusCovid,
                          size: 17,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        buildTextContent(
                          "Phiếu giảm giá",
                          false,
                          fontSize: 16,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        buildTextContent(
                          "Phiếu giảm giá",
                          false,
                          fontSize: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
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
                        Icon(
                          FontAwesomeIcons.virusCovid,
                          size: 17,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        buildTextContent(
                          "Phiếu giảm giá",
                          false,
                          fontSize: 16,
                        )
                      ],
                    ),
                    Container(
                        height: 20,
                        child: Switch(value: false, onChanged: (value) {})),
                  ]),
            ),
          ),
          buildDivider(
            color: red,
          ),
          Container(
            // height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 5),
                        height: 30,
                        width: 30,
                        child: Checkbox(
                            value: _cartCheckBoxList!
                                .every((element) => element == true),
                            onChanged: (value) {
                              setState(() {
                                for (int i = 0;
                                    i < _cartCheckBoxList!.length;
                                    i++) {
                                  _cartCheckBoxList?[i] = value as bool;
                                }
                              });
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
                      SizedBox(
                        height: 5,
                      ),
                      buildTextContent("₫${_allMoney}", true,
                          colorWord: red, fontSize: 16),
                    ],
                  ),
                ),
                Container(
                  child: buildElevateButtonWidget(
                      marginTop: 0,
                      width: width * 0.3,
                      bgColor: Colors.red,
                      title:
                          "Mua (${_cartCheckBoxList?.where((e) => e == true).length ?? 0})",
                      function: () {
                        pushToNextScreen(context, const PaymentMarketPage());
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCartCheckBox() {
    for (int i = 0; i < _cartData?["items"].length; i++) {
      _cartCheckBoxList?.add(false);
    }
  }
}
