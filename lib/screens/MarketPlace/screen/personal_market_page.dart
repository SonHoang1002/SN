// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:market_place/constant/marketPlace_constants.dart';
// import 'package:market_place/helpers/routes.dart';
// import 'package:market_place/screens/MarketPlace/screen/buyer_orders/my_order_page.dart';
// import 'package:market_place/screens/MarketPlace/screen/create_product_page.dart';
// import 'package:market_place/screens/MarketPlace/screen/interest_product_page.dart';
// import 'package:market_place/screens/MarketPlace/screen/manage_product_page.dart';
// import 'package:market_place/screens/MarketPlace/screen/request_product_page.dart';
// import 'package:market_place/screens/MarketPlace/screen/seller_orders/manage_order_page.dart';
// import 'package:market_place/theme/theme_manager.dart';
// import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
// import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
// import 'package:market_place/widgets/back_icon_appbar.dart';
// import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

// import '../../../../theme/colors.dart';
// import 'notification_market_page.dart';

// class PersonalMarketPlacePage extends StatefulWidget {
//   const PersonalMarketPlacePage({super.key});

//   @override
//   State<PersonalMarketPlacePage> createState() =>
//       _PersonalMarketPlacePageState();
// }

// class _PersonalMarketPlacePageState extends State<PersonalMarketPlacePage> {
//   late double width = 0;
//   late double height = 0;
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     width = size.width;
//     height = size.height;
//     final theme = Provider.of<ThemeManager>(context);

//     Color colorWord = theme.themeMode == ThemeMode.dark
//         ? white
//         : theme.themeMode == ThemeMode.light
//             ? blackColor
//             : blackColor;
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const BackIconAppbar(),
//               const AppBarTitle(text: "Cá nhân"),
//               GestureDetector(
//                 onTap: () {
//                   pushToNextScreen(context, NotificationMarketPage());
//                 },
//                 child: Icon(
//                   FontAwesomeIcons.bell,
//                   size: 18,
//                   color: colorWord,
//                 ),
//               )
//             ],
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Column(children: [
//                   //  san pham cua ban
//                   GeneralComponent(
//                     [
//                       buildTextContent("Shop của bạn", true),
//                     ],
//                     changeBackground: transparent,
//                     padding: const EdgeInsets.all(5),
//                     function: () {},
//                   ),
//                   _buildRenderList(PersonalMarketPlaceConstants
//                       .PERSONAL_MARKET_PLACE_YOUR_SHOP["data"]),
//                   GeneralComponent(
//                     [
//                       buildTextContent("Tài khoản", true),
//                     ],
//                     changeBackground: transparent,
//                     padding: const EdgeInsets.all(5),
//                     function: () {},
//                   ),
//                   _buildRenderList(PersonalMarketPlaceConstants
//                       .PERSONAL_MARKET_PLACE_YOUR_ACCOUNT["data"]),
//                 ]),
//               ),
//             )
//           ],
//         ));
//   }

//   _checkNavigator(String value) {
//     switch (value) {
//       case "Quản lý đơn hàng":
//         pushToNextScreen(context, const ManageOrderMarketPage());
//         break;
//       case "Quản lý sản phẩm":
//         pushToNextScreen(context, const ManageProductMarketPage());
//         break;
//       case "Tạo sản phẩm mới":
//         pushToNextScreen(context, const CreateProductMarketPage());
//         break;
//       case "Đơn mua của tôi":
//         pushToNextScreen(context, const MyOrderPage());
//         break;
//       case "Lời mời":
//         pushToNextScreen(
//             context,
//             RequestProductMarketPage(
//               listProduct: [],
//             ));
//         break;
//       default:
//         pushToNextScreen(context, const InterestProductMarketPage());
//         break;
//     }
//   }

//   Widget _buildRenderList(dynamic data) {
//     return Column(
//       children: List.generate(data.length, (index) {
//         return GeneralComponent(
//           [buildTextContent(data[index]["title"], false)],
//           prefixWidget: Container(
//             height: 40,
//             width: 40,
//             margin: const EdgeInsets.only(right: 10),
//             padding: const EdgeInsets.all(5),
//             child: Icon(
//               data[index]["icon"],
//             ),
//           ),
//           changeBackground: transparent,
//           padding: const EdgeInsets.all(5),
//           function: () {
//             _checkNavigator(data[index]["title"]);
//           },
//         );
//       }).toList(),
//     );
//   }
// }
