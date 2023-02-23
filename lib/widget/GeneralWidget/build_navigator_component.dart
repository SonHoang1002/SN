// import 'package:flutter/material.dart';

// buildNavigatorComponentWithButtonAndChip(double width, int currentPage,
//       {Function? function}) {
//     return Container(
//       height: 70,
//       color: Colors.black87,
//       child: Column(children: [
//         Center(
//           child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   fixedSize: Size(width * 0.9, 40),
//                   backgroundColor: nameController.text.trim() == ""
//                       ? Colors.grey[800]
//                       : Colors.blue),
//               onPressed: () {
//                 function != null ? function() : null;
//               },
//               child: Text(currentPage == 7 ? done : next)),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Center(
//             child: Container(
//           height: 6,
//           width: width * 0.9,
//           child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 7,
//               itemBuilder: ((context, index) {
//                 return Container(
//                   margin: EdgeInsets.fromLTRB(
//                       index == 0 ? 0 : 5, 0, index == 6 ? 0 : 5, 0),
//                   width: width * 0.10555,
//                   // height: 2,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(3),
//                     color: index <= currentPage - 1
//                         ? Colors.blue
//                         : Colors.grey[800],
//                   ),
//                 );
//               })),
//         ))
//       ]),
//     );
//   }
// }