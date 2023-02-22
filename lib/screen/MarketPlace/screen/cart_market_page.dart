// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
// import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
// import 'package:social_network_app_mobile/providers/market_place_providers/cart_product_provider.dart';
// import 'package:social_network_app_mobile/screen/MarketPlace/screen/notification_market_page.dart';
// import 'package:social_network_app_mobile/screen/MarketPlace/screen/payment_market_page.dart';
// import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
// import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
// import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
// import 'package:social_network_app_mobile/widget/appbar_title.dart';
// import 'package:social_network_app_mobile/widget/image_cache.dart';

// import '../../../../theme/colors.dart';
// import '../../../../widget/GeneralWidget/divider_widget.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class CartMarketPage extends ConsumerStatefulWidget {
//   const CartMarketPage({super.key});

//   @override
//   ConsumerState<CartMarketPage> createState() => _CartMarketPageState();
// }

// class _CartMarketPageState extends ConsumerState<CartMarketPage> {
//   late double width = 0;
//   late double height = 0;
//   List<dynamic>? _cartData;
//   List<dynamic>? _cartCheckBoxChildList;
//   double _allMoney = 0;
//   bool _isLoading = true;
//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(Duration(seconds: 2), () async {
//       if (ref.watch(cartProductsProvider).listCart.isEmpty) {
//         final initCartData =
//             await ref.read(cartProductsProvider.notifier).initCartProductList();
//         // final checkBoxData = await ref
//         //     .read(checkBoxCartProductsProvider.notifier)
//         //     .initCheckBoxCartProductList();
//       }
//     });
//     _cartCheckBoxChildList ??= [];
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _cartCheckBoxChildList = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     width = size.width;
//     height = size.height;
//     _cartData = ref.watch(cartProductsProvider).listCart;
//     // print("cart _cartData list is: ${json.encode(_cartData)}");
//     _buildCartCheckBox();
//     print("cart _cartCheckBoxChildList list is: ${_cartCheckBoxChildList}");
//     _updateTotalPrice();
//     _isLoading = false;
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () async {
//                   print("cart ---------------------");
//                   await ref
//                       .read(cartProductsProvider.notifier)
//                       .updateCartProductList(_cartData!);
//                   // await ref
//                   //     .read(checkBoxCartProductsProvider.notifier)
//                   //     .updateCheckBoxCartProductList(_cartCheckBoxChildList!);
//                   popToPreviousScreen(context);
//                 },
//                 child: Icon(
//                   FontAwesomeIcons.chevronLeft,
//                   color: Theme.of(context).textTheme.displayLarge!.color,
//                 ),
//               ),
//               const AppBarTitle(
//                   title: CartMarketConstants.CART_MARKET_CART_TITLE),
//               GestureDetector(
//                 onTap: () async {
//                   pushToNextScreen(context, NotificationMarketPage());
//                 },
//                 child: const Icon(
//                   FontAwesomeIcons.bell,
//                   size: 18,
//                   color: Colors.black,
//                 ),
//               )
//             ],
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   _isLoading
//                       ? Center(
//                           child: Container(
//                             width: 70,
//                             height: 70,
//                             child: const CircularProgressIndicator(
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.red),
//                               strokeWidth: 3,
//                             ),
//                           ),
//                         )
//                       : Column(
//                           children: List.generate(
//                               ref.watch(cartProductsProvider).listCart.length,
//                               (index) {
//                           final data =
//                               ref.watch(cartProductsProvider).listCart[index];
//                           return _buildCartProductItem(data, index);
//                         })),
//                 ],
//               ),
//             ),
//             _voucherAndBuyComponent()
//           ],
//         ));
//   }

//   Widget _buildCartProductItem(dynamic data, dynamic indexComponent) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   // checkbox
//                   Container(
//                       margin: const EdgeInsets.only(right: 5),
//                       height: 30,
//                       width: 30,
//                       child: Checkbox(
//                           value: _cartCheckBoxChildList?[indexComponent]
//                               .every((element) => element == true),
//                           onChanged: (value) {
//                             for (int i = 0;
//                                 i <
//                                     _cartCheckBoxChildList?[indexComponent]
//                                         .length;
//                                 i++) {
//                               _cartCheckBoxChildList?[indexComponent][i] =
//                                   value as bool;
//                             }
//                             setState(() {});
//                           })),
//                   // icon and title
//                   Container(
//                     height: 40,
//                     width: 40,
//                     padding: const EdgeInsets.all(10),
//                     child: const Icon(
//                       FontAwesomeIcons.store,
//                       size: 19,
//                     ),
//                   ),
//                   Container(
//                       width: 180,
//                       child: buildTextContent(data["title"], true,
//                           fontSize: 17, overflow: TextOverflow.ellipsis)),
//                   Container(
//                     height: 40,
//                     width: 40,
//                     child: const Icon(
//                       FontAwesomeIcons.angleRight,
//                       size: 19,
//                     ),
//                   ),
//                 ],
//               ),
//               // fix
//               buildTextContent("Sửa", false,
//                   fontSize: 15, colorWord: blueColor),
//             ],
//           ),
//         ),
//         buildDivider(
//           color: red,
//         ),
//         buildSpacer(height: 10),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 5.0),
//           child: Column(
//             children: List.generate(data["items"].length, (index) {
//               final itemData = data["items"][index];
//               return Column(
//                 children: [
//                   index != 0
//                       ? Padding(
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                           child: buildDivider(color: greyColor),
//                         )
//                       : SizedBox(),
//                   Slidable(
//                     endActionPane: ActionPane(
//                       motion: const ScrollMotion(),
//                       children: [
//                         SlidableAction(
//                           onPressed: (context) {
//                             _deleteProduct(indexComponent, index);
//                           },
//                           backgroundColor: const Color(0xFFFE4A49),
//                           foregroundColor: Colors.white,
//                           icon: Icons.delete,
//                           label: 'Delete',
//                         ),
//                       ],
//                     ),
//                     child: Container(
//                       height: 80,
//                       width: width,
//                       // margin: EdgeInsets.only(bottom: 5),
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Container(
//                         height: 80,
//                         child: Row(
//                           children: [
//                             Container(
//                                 margin: const EdgeInsets.only(right: 5),
//                                 height: 30,
//                                 width: 30,
//                                 child: Checkbox(
//                                     value:
//                                         _cartCheckBoxChildList?[indexComponent]
//                                             [index] as bool,
//                                     onChanged: (value) {
//                                       _cartCheckBoxChildList?[indexComponent]
//                                           [index] = value as bool;
//                                       setState(() {});
//                                     })),
//                             Container(
//                               margin: const EdgeInsets.only(right: 10),
//                               child: ImageCacheRender(
//                                 height: 80.0,
//                                 width: 80.0,
//                                 path: itemData["product_variant"]["image"] !=
//                                             null &&
//                                         itemData["product_variant"]["image"]
//                                             .isNotEmpty
//                                     ? itemData["product_variant"]["image"]
//                                         ["url"]
//                                     : "https://www.w3schools.com/w3css/img_lights.jpg",
//                               ),
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // buildTextContent(title, false, fontSize: 17),
//                                 Container(
//                                   width: 200,
//                                   child: Text(
//                                     itemData["product_variant"]["title"],
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                     style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 buildTextContent(
//                                     itemData["product_variant"]["price"]
//                                         .toString(),
//                                     true,
//                                     fontSize: 15,
//                                     colorWord: red),
//                                 Row(
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         _updateQuantity(
//                                             false, indexComponent, index);
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: greyColor, width: 0.4)),
//                                         height: 25,
//                                         width: 25,
//                                         // padding: EdgeInsets.all(10),
//                                         child: const Icon(
//                                           FontAwesomeIcons.minus,
//                                           size: 16,
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           border: Border.all(
//                                               color: greyColor, width: 0.2)),
//                                       height: 25,
//                                       width: 40,
//                                       child: Center(
//                                           child: Text(
//                                               itemData["quantity"].toString())),
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         _updateQuantity(
//                                             true, indexComponent, index);
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: greyColor, width: 0.2)),
//                                         height: 25,
//                                         width: 25,
//                                         // padding: EdgeInsets.all(10),
//                                         child: const Icon(FontAwesomeIcons.plus,
//                                             size: 16),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ),
//         Container(
//           height: 5,
//           color: greyColor,
//           margin: const EdgeInsets.symmetric(vertical: 10),
//         )
//       ],
//     );
//   }

//   Widget _voucherAndBuyComponent() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
//       width: width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           InkWell(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 5, bottom: 5),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           FontAwesomeIcons.virusCovid,
//                           size: 17,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         buildTextContent(
//                           "Phiếu giảm giá",
//                           false,
//                           fontSize: 16,
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         buildTextContent(
//                           "Phiếu giảm giá",
//                           false,
//                           fontSize: 16,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         const Icon(
//                           FontAwesomeIcons.arrowRight,
//                           size: 17,
//                         )
//                       ],
//                     ),
//                   ]),
//             ),
//           ),
//           buildDivider(
//             color: red,
//           ),
//           InkWell(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 5, bottom: 5),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           FontAwesomeIcons.virusCovid,
//                           size: 17,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         buildTextContent(
//                           "Phiếu giảm giá",
//                           false,
//                           fontSize: 16,
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                         height: 20,
//                         child: Switch(value: false, onChanged: (value) {})),
//                   ]),
//             ),
//           ),
//           buildDivider(
//             color: red,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                       margin: const EdgeInsets.only(right: 5),
//                       height: 30,
//                       width: 30,
//                       child: Checkbox(
//                           value: _checkBoxAll(),
//                           onChanged: (value) {
//                             for (int i = 0;
//                                 i < _cartCheckBoxChildList!.length;
//                                 i++) {
//                               for (int j = 0;
//                                   j < _cartCheckBoxChildList![i].length;
//                                   j++) {
//                                 _cartCheckBoxChildList![i][j] = value;
//                               }
//                             }
//                             setState(() {});
//                           })),
//                   buildTextContent("Tất cả", false,
//                       colorWord: greyColor, fontSize: 15),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     buildTextContent("Tổng thanh toán: ", false,
//                         colorWord: greyColor, fontSize: 12),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     buildTextContent("₫${_allMoney}", true,
//                         colorWord: red, fontSize: 16),
//                   ],
//                 ),
//               ),
//               Container(
//                 child: buildButtonForMarketWidget(
//                     marginTop: 0,
//                     width: width * 0.3,
//                     bgColor: Colors.red,
//                     title: "Mua",
//                     function: () async {
//                       await ref
//                           .read(cartProductsProvider.notifier)
//                           .updateCartProductList(_cartData!);
//                       pushToNextScreen(context, const PaymentMarketPage());
//                     }),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   _buildCartCheckBox() async {
//     // List<dynamic> listCartCheckbox =
//     //     ref.watch(checkBoxCartProductsProvider).listCartCheckbox;
//     // if (listCartCheckbox.isEmpty) {
//     if (_cartCheckBoxChildList!.isEmpty) {
//       final childDataList = _cartData?.map((element) {
//         return element["items"].map((childElement) {
//           return false;
//         }).toList();
//       }).toList();
//       _cartCheckBoxChildList = childDataList!;
//     }
//     // } else {
//     //   _cartCheckBoxChildList = listCartCheckbox;
//     // }
//     setState(() {});
//   }

//   _checkBoxAll() {
//     for (int i = 0; i < _cartCheckBoxChildList!.length; i++) {
//       for (int j = 0; j < _cartCheckBoxChildList![i].length; j++) {
//         if (_cartCheckBoxChildList![i][j] == false) {
//           return false;
//         }
//       }
//     }
//     return true;
//   }

//   _updateTotalPrice() {
//     _allMoney = 0;
//     for (int i = 0; i < _cartCheckBoxChildList!.length; i++) {
//       for (int j = 0; j < _cartCheckBoxChildList![i].length; j++) {
//         if (_cartCheckBoxChildList![i][j] == true) {
//           _allMoney += _cartData![i]["items"][j]["product_variant"]["price"] *
//               _cartData![i]["items"][j]["quantity"];
//         }
//       }
//     }
//     setState(() {});
//   }

//   _deleteProduct(dynamic indexCategory, dynamic indexProduct) {
//     // call api
//     _callDeleteProductApi({
//       "product_variant_id": _cartData![indexCategory]["items"][indexProduct]
//           ["product_variant"]["id"]
//     });
//     _cartData![indexCategory]["items"].removeAt(indexProduct);
//     _cartCheckBoxChildList?[indexCategory].removeAt(indexProduct);
//     print(
//         "cart _cartData![indexCategory]item.length: ${_cartData![indexCategory]["items"].length}");
//     if (_cartData![indexCategory]["items"].isEmpty) {
//       _cartData!.removeAt(indexCategory);
//       _cartCheckBoxChildList?.removeAt(indexCategory);
//     }
//     setState(() {});
//   }

//   _updateQuantity(bool isPlus, dynamic indexCategory, dynamic indexProduct) {
//     if (isPlus) {
//       _cartData![indexCategory]["items"][indexProduct]["quantity"] += 1;
//     } else {
//       if (_cartData![indexCategory]["items"][indexProduct]["quantity"] != 0) {
//         _cartData![indexCategory]["items"][indexProduct]["quantity"] -= 1;
//       }
//     }
//     // call api
//     _callUpdateQuantityApi({
//       "product_variant_id": _cartData![indexCategory]["items"][indexProduct]
//           ["product_variant"]["id"],
//       "quantity": _cartData![indexCategory]["items"][indexProduct]["quantity"]
//     });
//     setState(() {});
//   }

//   _callDeleteProductApi(dynamic data) async {
//     print("cart _callDeleteProductApi");
//     final response =
//         await ref.read(cartProductsProvider.notifier).deleteCartProduct(data);
//   }

//   _callUpdateQuantityApi(dynamic data) async {
//     print("cart _callUpdateQuantityApi");
//     final response =
//         await ref.read(cartProductsProvider.notifier).updateCartQuantity(data);
//   }
// }
