// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// import '../../theme/colors.dart';


// Widget buildBottomNavigatorBarWidget(BuildContext context) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       Container(
//         color: Colors.grey[800],
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: SettingConstants.BOTTOM_NAVIGATOR_ITEM_LIST.map((item) {
//             int index =
//                 SettingConstants.BOTTOM_NAVIGATOR_ITEM_LIST.indexOf(item);
//             return GestureDetector(
//               onTap: (() {
//                 Provider.of<RouteProvider>(context, listen: false)
//                     .setRouteProvider(index);
//               }),
//               child: Container(
//                 height: 50,
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       item[0] is IconData
//                           ? Container(
//                               height: Provider.of<RouteProvider>(
//                                 context,
//                               ).getRouteList[index]
//                                   ? 35
//                                   : 30,
//                               width: Provider.of<RouteProvider>(
//                                 context,
//                               ).getRouteList[index]
//                                   ? 35
//                                   : 30,
//                               child: Icon(
//                                 item[0],
//                                 color: Provider.of<RouteProvider>(
//                                   context,
//                                 ).getRouteList[index]
//                                     ? Colors.blue
//                                     : white,
//                                 size: 22,
//                               ),
//                             )
//                           : Container(
//                               height: Provider.of<RouteProvider>(
//                                 context,
//                               ).getRouteList[index]
//                                   ? 35
//                                   : 30,
//                               width: Provider.of<RouteProvider>(
//                                 context,
//                               ).getRouteList[index]
//                                   ? 35
//                                   : 30,
//                               padding: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(15))),
//                               child: Image.asset(
//                                 item[0],
//                               ),
//                             ),
//                       Wrap(
//                         children: [
//                           Text(
//                             item[1],
//                             style: TextStyle(
//                                 color: Provider.of<RouteProvider>(
//                                   context,
//                                 ).getRouteList[index]
//                                     ? Colors.blue
//                                     : white,
//                                 fontSize: Provider.of<RouteProvider>(
//                                   context,
//                                 ).getRouteList[index]
//                                     ? 12
//                                     : 10),
//                           )
//                         ],
//                       )
//                     ]),
//               ),
//             );
//           }).toList(),
//         ),
//       )
//     ],
//   );
// }
