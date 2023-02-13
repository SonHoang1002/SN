import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevateButton_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/request_product_market_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';
import 'cart_market_page.dart';
import 'create_product_market_page.dart';
import 'interest_product_market_page.dart';
import 'manage_order_market_page.dart';
import 'manage_product_market_page.dart';
import 'notification_market_page.dart';
import 'order_product_market_page.dart';

class PersonalMarketPlacePage extends StatefulWidget {
  @override
  State<PersonalMarketPlacePage> createState() =>
      _PersonalMarketPlacePageState();
}

class _PersonalMarketPlacePageState extends State<PersonalMarketPlacePage> {
  late double width = 0;
  late double height = 0;
  bool _isOpenProductOfYou = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackIconAppbar(),
              AppBarTitle(title: "Cá nhân"),
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  //button
                  //  san pham cua ban
                  buildElevateButtonWidget(
                      width: width,
                      bgColor: secondaryColor,
                      title: "Tạo bài niêm yết mới",
                      iconData: FontAwesomeIcons.penToSquare,
                      function: () {
                        pushToNextScreen(context, CreateProductMarketPage());
                      }),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GeneralComponent(
                      [
                        buildTextContent("Trang hoạt động của bạn", false,
                            fontSize: 18)
                      ],
                      prefixWidget: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          MarketPlaceConstants.PATH_IMG + "cat_1.png",
                          height: 20,
                        ),
                      ),
                      changeBackground: transparent,
                      padding: EdgeInsets.zero,
                      function: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Text(
                                      "Chuyen sang trang trung bay san pham cua ban"),
                                ));
                      },
                    ),
                  ),
                  GeneralComponent(
                    [
                      buildTextContent("Sản phẩm của bạn", true),
                    ],
                    suffixWidget: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        _isOpenProductOfYou
                            ? FontAwesomeIcons.caretUp
                            : FontAwesomeIcons.caretDown,
                      ),
                    ),
                    changeBackground: transparent,
                    padding: EdgeInsets.all(5),
                    function: () {
                      setState(() {
                        _isOpenProductOfYou = !_isOpenProductOfYou;
                      });
                    },
                  ),
                  _isOpenProductOfYou
                      ? Column(
                          children: List.generate(
                              PersonalMarketPlaceConstants
                                  .PERSONAL_MARKET_PLACE_PRODUCT_OF_YOU_CONTENTS[
                                      "data"]
                                  .length, (index) {
                            final data = PersonalMarketPlaceConstants
                                    .PERSONAL_MARKET_PLACE_PRODUCT_OF_YOU_CONTENTS[
                                "data"];
                            return GeneralComponent(
                              [
                                buildTextContent(data[index]["title"], false,
                                    function: () {
                                  _checkNavigator(data[index]["title"]);
                                })
                              ],
                              prefixWidget: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  data[index]["icon"],
                                ),
                              ),
                              changeBackground: transparent,
                              padding: EdgeInsets.all(5),
                            );
                          }).toList(),
                        )
                      : SizedBox(),
                  GeneralComponent(
                    [
                      buildTextContent("Thông báo(có hoặc không)", true),
                    ],
                    suffixWidget: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(5),
                    ),
                    changeBackground: transparent,
                    padding: EdgeInsets.all(5),
                  ),
                ]),
              ),
            )
          ],
        ));
  }

  _checkNavigator(String value) {
    switch (value) {
      case "Lời mời":
        pushToNextScreen(context, RequestProductMarketPage());
        break;
      case "Quan tâm":
        pushToNextScreen(context, InterestProductMarketPage());
        break;
      case "Quản lý đơn hàng":
        pushToNextScreen(context, ManageOrderMarketPage());
        break;
      case "Quản lý sản phẩm":
        pushToNextScreen(context, ManageProductMarketPage());
        break;
      case "Đơn mua":
        pushToNextScreen(context, OrderProductMarketPage());
        break;
      default:
        pushToNextScreen(context, CartMarketPage());
        break;
    }
  }
}
