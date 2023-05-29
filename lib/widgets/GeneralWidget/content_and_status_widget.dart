// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../theme/colors.dart';
// import 'text_content_widget.dart';

// buildContentAndStatusWidget(String title,
//     {List<Map<String, dynamic>>? contents, Function? function}) {
//   return Column(
//     children: [
//       _buildDivider(),
//       Padding(
//         padding: const EdgeInsets.only(bottom: 10.0),
//         child: buildTextContent(
//           title,
//           true,
//           fontSize: 17,
//         ),
//       ),
//       Container(
//         child: ListView.builder(
//             padding: EdgeInsets.zero,
//             shrinkWrap: true,
//             itemCount: contents!.length,
//             itemBuilder: ((context, index) {
//               return Container(
//                 margin: EdgeInsets.only(bottom: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: buildTextContent(
//                         contents[index]["content"]!.toString(), false,
//                         fontSize: 15,
//                         //  colorWord: Colors.grey
//                       ),
//                     ),
//                     contents[index]["status"] != null
//                         ? GestureDetector(
//                             onTap: (() {
//                               if (function != null) {
//                                 function();
//                               }
//                             }),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.grey[300],
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(5))),
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 10),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                           SettingConstants.PATH_ICON +
//                                               "bell_icon.svg",
//                                           height: 15,
//                                           // color:  white
//                                         ),
//                                         Container(
//                                           margin: EdgeInsets.only(
//                                               left: 5, right: 5),
//                                           child: buildTextContent(
//                                               contents[index]["status"]!
//                                                   .toString(),
//                                               true,
//                                               fontSize: 14),
//                                         ),
//                                         Icon(
//                                           SettingConstants.DOWN_ICON_DATA,
//                                           size: 15,
//                                           // color:  white,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         : Container()
//                   ],
//                 ),
//               );
//             })),
//       )
//     ],
//   );
// }

// _buildDivider() {
//   return Padding(
//       padding: EdgeInsets.symmetric(vertical: 5),
//       child: Divider(
//         color: white,
//         height: 10,
//       ));
// }
