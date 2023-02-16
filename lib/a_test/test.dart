// //   import 'dart:convert';

// // Future<http.Response?> updateStatusActiveApi(status) async {
// //     var dataUserId = await SecureStorage().getKeyStorage("userId");
// //     var dataToken = await SecureStorage().getKeyStorage("token");
// //     try {
// //       var response = await http.post(
// //           Uri.parse('$urlRocketChat/api/v1/method.call/getRoomRoles'),
// //           headers: {
// //             'X-Auth-Token': "$dataToken",
// //             'X-User-Id': "$dataUserId",
// //             'Content-Type': 'application/json'
// //           },
// //           body: jsonEncode({
// //             'msg': 'method',
// //             'id': '17',
// //             'method': 'setUserStatus',
// //             'params': [status, '']
// //           }));
// //       return response;
// //     } catch (e) {
// //       print(e);
// //     }
// //     return null;
// //   }


// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../../../constant/login_constants.dart';
// import '../../../../constant/marketPlace_constants.dart';
// import '../../../../theme/colors.dart';
// import '../../../../widget/GeneralWidget/spacer_widget.dart';
// import '../../../../widget/GeneralWidget/text_content_widget.dart';
// import '../../../../widget/image_cache.dart';

// class MainMarketBody extends StatelessWidget {
//   late double width = 0;

//   late double height = 0;
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     width = size.width;
//     height = size.height;
//     return GestureDetector(
//       onTap: (() {
//         FocusManager.instance.primaryFocus!.unfocus();
//       }),
//       child: Stack(
//         children: [
//           Column(children: [
//             // main content
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 // color: Colors.grey[900],
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   children: [
//                     // carousel trend product
//                     Container(
//                         child: CarouselSlider(
//                       options: CarouselOptions(
//                           height: 200.0,
//                           autoPlay: true,
//                           viewportFraction: 1,
//                           clipBehavior: Clip.antiAliasWithSaveLayer),
//                       items: [1, 2, 3, 4, 5].map((i) {
//                         return Builder(
//                           builder: (BuildContext context) {
//                             return Container(
//                                 width: width,
//                                 margin:
//                                     const EdgeInsets.symmetric(horizontal: 5.0),
//                                 decoration:
//                                     const BoxDecoration(color: Colors.amber),
//                                 child: Image.asset(
//                                   LoginConstants.PATH_IMG +
//                                       "example_cover_img_${i}.jpg",
//                                   fit: BoxFit.fitWidth,
//                                 ));
//                           },
//                         );
//                       }).toList(),
//                     )),

//                     // category product
//                     buildSpacer(height: 10),
//                     Container(
//                       // padding: EdgeInsets.,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           buildTextContent(
//                             "Danh mục",
//                             true,
//                             fontSize: 22,
//                             colorWord: secondaryColor,
//                           ),
//                           Row(
//                             children: [
//                               buildTextContent(
//                                 "Tìm hiểu thêm",
//                                 false,
//                                 fontSize: 14,
//                                 colorWord: greyColor,
//                               ),
//                               const Icon(
//                                 FontAwesomeIcons.angleRight,
//                                 color: greyColor,
//                                 size: 14,
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: 80,
//                       // width: 300,
//                       child: ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           itemCount: MainMarketBodyConstants
//                               .MAIN_MARKETPLACE_BODY_CATEGORY_CONTENTS["data"]
//                               .length,
//                           shrinkWrap: false,
//                           itemBuilder: (context, index) {
//                             final data = MainMarketBodyConstants
//                                     .MAIN_MARKETPLACE_BODY_CATEGORY_CONTENTS[
//                                 "data"];
//                             return Container(
//                               margin: const EdgeInsets.symmetric(vertical: 0.0),
//                               padding:
//                                   const EdgeInsets.only(bottom: 5.0, right: 5),
//                               decoration: const BoxDecoration(
//                                   border: Border(
//                                       bottom: BorderSide(
//                                           width: 0.2, color: greyColor))),
//                               child: Container(
//                                 height: 100,
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   // border: Border.all(
//                                   //     width: 0.4, color: greyColor)
//                                 ),
//                                 child: Column(children: [
//                                   Container(
//                                       height: 40,
//                                       width: 40,
//                                       padding: const EdgeInsets.all(5),
//                                       child: Image.asset(data[index]["icon"])),
//                                   _buildTextMarketPlace(data[index]["title"])

//                                   // buildTextContent(data[index]["title"], false,
//                                   //     fontSize: 19, isCenterLeft: false)
//                                 ]),
//                               ),
//                             );
//                           }),
//                     ),

//                     // suggest product
//                     buildSpacer(height: 10),
//                     Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           buildTextContent(
//                             MainMarketBodyConstants
//                                 .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_TITLE,
//                             true,
//                             fontSize: 22,
//                             colorWord: secondaryColor,
//                           ),
//                           Row(
//                             children: [
//                               buildTextContent(
//                                 "Xem tất cả",
//                                 false,
//                                 fontSize: 14,
//                                 colorWord: greyColor,
//                               ),
//                               const Icon(
//                                 FontAwesomeIcons.angleRight,
//                                 color: greyColor,
//                                 size: 14,
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: 300,
//                       margin:  const EdgeInsets.only(top: 10),
//                       child: GridView.builder(
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisSpacing: 4,
//                                   mainAxisSpacing: 4,
//                                   crossAxisCount: 2,
//                                   childAspectRatio: 2 / 3),
//                           itemCount: MainMarketBodyConstants
//                               .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
//                                   "data"]
//                               .length,
//                           // shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             final data = MainMarketBodyConstants
//                                     .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
//                                 "data"];
//                             return Container(
//                               // margin: const EdgeInsets.symmetric(vertical: 8.0),
//                               // padding:
//                               //     const EdgeInsets.only(bottom: 10.0, right: 8),
//                               // decoration:  BoxDecoration(
                               
//                               //     border: const Border(
//                               //         bottom: BorderSide(
//                               //             width: 0.4, color: greyColor))),
//                               child: Container(
//                                 // width:300,
//                                 margin: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 3),
//                                 height: 250,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey,
//                                      borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                         width: 0.2, color: greyColor)),
//                                 child: Container(
//                                   child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                             child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             //img
//                                             ClipRRect(
//                                               borderRadius:
//                                                   const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
//                                               child: ImageCacheRender(
//                                                 path: data[index]["img"],
//                                                 height: 150.0,
//                                                 width: width,
//                                               ),
//                                             ),
//                                             // title
//                                             _buildTextMarketPlace(
//                                                 data[index]["title"],
//                                                 fontSize: 14,
//                                                 color: Colors.black),
//                                             // price
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 10),
//                                                   child: _buildTextMarketPlace(
//                                                       "₫${data[index]["min_price"].toString()} ${data[index]["max_price"] != null ? "- ₫${data[index]["max_price"].toString()}" : ""}",
//                                                       fontSize: 15,
//                                                       color: Colors.red,
//                                                       textAlign:
//                                                           TextAlign.left),
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         )),
//                                         // rate and selled
//                                         Container(
//                                           margin: const EdgeInsets.only(bottom: 10),
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                   children: List.generate(5,
//                                                       (indexList) {
//                                                 return Container(
//                                                     height: 10,
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                             right: 3),
//                                                     child: Icon(
//                                                       Icons.star,
//                                                       color: data[index]
//                                                                   ["rate"] >=
//                                                               indexList
//                                                           ? Colors.yellow
//                                                           : white,
//                                                       size: 12,
//                                                     ));
//                                               }).toList()),
//                                               Container(
//                                                 child: _buildTextMarketPlace(
//                                                     "đã bán ${data[index]["selled"]}",
//                                                     color: blackColor,
//                                                     fontSize: 13),
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ]),
//                                 ),
//                               ),
//                             );
//                           }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }
// }

// _buildTextMarketPlace(String title,
//     {Color? color = secondaryColor,
//     double? fontSize = 14,
//     TextAlign? textAlign = TextAlign.center}) {
//   return Text(
//     title,
//     maxLines: 2,
//     textAlign: textAlign,
//     overflow: TextOverflow.ellipsis,
//     style: TextStyle(color: color!, fontSize: fontSize),
//   );
// }

// demoFunction() {}



// // Container(
// //                             width: width / 2 - 30,
// //                             decoration: BoxDecoration(
// //                               color: Colors.red,
// //                                 borderRadius: BorderRadius.circular(10)),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                               SvgPicture.asset(
// //                                 MarketPlaceConstants.PATH_ICON + "bell_icon.svg",
// //                                 height: 16,
// //                                 color: white,
// //                               ),
// //                               SizedBox(width:10),
// //                               _buildTextMarketPlace("Bans", color: Colors.green)
// //                             ]),
// //                           );


// // Container(
// //                         height: 40,
// //                         width: width,
// //                         padding: EdgeInsets.symmetric(horizontal: 10),
// //                         child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               ButtonPrimary(
// //                                 width: width / 2 - 30,
// //                                 label: "Bán",
// //                                 icon: Icon(
// //                                   Icons.usb_rounded,
// //                                   color: Colors.white,
// //                                   size: 20,
// //                                 ),
// //                                 radius: 25,
// //                               ),
// //                               ButtonPrimary(
// //                                 width: width / 2 - 30,
// //                                 label: "Hạng mục",
// //                                 icon: Icon(
// //                                   Icons.usb_rounded,
// //                                   color: Colors.white,
// //                                   size: 20,
// //                                 ),
// //                                 radius: 25,
// //                               ),
// //                             ])),
// //                     buildDivider(color: Colors.black),
// //                     buildSpacer(height: 10),



