import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/order_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/request_product_market_page.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
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

class PersonalMarketPlacePage extends StatefulWidget {
  const PersonalMarketPlacePage({super.key});

  @override
  State<PersonalMarketPlacePage> createState() =>
      _PersonalMarketPlacePageState();
}

class _PersonalMarketPlacePageState extends State<PersonalMarketPlacePage> {
  late double width = 0;
  late double height = 0;
  // bool _isOpenYourAccount = false;
  // bool _isOpenYourShop = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    final theme = Provider.of<ThemeManager>(context);

    Color colorWord = theme.themeMode == ThemeMode.dark
        ? white
        : theme.themeMode == ThemeMode.light
            ? blackColor
            : blackColor;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Cá nhân"),
              GestureDetector(
                onTap: () {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: Icon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: colorWord,
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
                  //  san pham cua ban
                  GeneralComponent(
                    [
                      buildTextContent("Shop của bạn", true),
                    ],
                    changeBackground: transparent,
                    padding: const EdgeInsets.all(5),
                    function: () {
                      // setState(() {
                      //   _isOpenYourAccount = !_isOpenYourAccount;
                      // });
                    },
                  ),

                  // _isOpenYourAccount
                  //     ?
                  _buildRenderList(PersonalMarketPlaceConstants
                      .PERSONAL_MARKET_PLACE_YOUR_SHOP["data"]),
                  // : const SizedBox(),
                  GeneralComponent(
                    [
                      buildTextContent("Tài khoản", true),
                    ],
                    changeBackground: transparent,
                    padding: const EdgeInsets.all(5),
                    function: () {},
                  ),
                  _buildRenderList(PersonalMarketPlaceConstants
                      .PERSONAL_MARKET_PLACE_YOUR_ACCOUNT["data"]),
                ]),
              ),
            )
          ],
        ));
  }

  _checkNavigator(String value) {
    switch (value) {
      case "Quản lý đơn hàng":
        pushToNextScreen(context, const ManageOrderMarketPage());
        break;
      case "Quản lý sản phẩm":
        pushToNextScreen(context, const ManageProductMarketPage());
        break;
      case "Tạo sản phẩm mới":
        pushToNextScreen(context, const CreateProductMarketPage());
        break;
      case "Đơn hàng của tôi":
        pushToNextScreen(context, const OrderProductMarketPage());
        break;
      case "Lời mời":
        pushToNextScreen(context, const RequestProductMarketPage());
        break;
      case "Quan tâm":
        pushToNextScreen(context, const InterestProductMarketPage());
        break;
      default:
        pushToNextScreen(context, const CartMarketPage());
        break;
    }
  }

  Widget _buildRenderList(dynamic data) {
    return Column(
      children: List.generate(data.length, (index) {
        return GeneralComponent(
          [buildTextContent(data[index]["title"], false)],
          prefixWidget: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(5),
            child: Icon(
              data[index]["icon"],
            ),
          ),
          changeBackground: transparent,
          padding: const EdgeInsets.all(5),
          function: () {
            _checkNavigator(data[index]["title"]);
          },
        );
      }).toList(),
    );
  }
}
