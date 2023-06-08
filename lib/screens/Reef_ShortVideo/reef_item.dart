
// import 'package:flutter/material.dart';
// import 'package:social_network_app_mobile/theme/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:social_network_app_mobile/screen/Moment/moment_video.dart';

// class ReefItem extends StatelessWidget {
//   final dynamic reefData;
//   const ReefItem({required this.reefData, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return InkWell(
//       onTap: () {
//         // pushCustomCupertinoPageRoute(context, const Moment());
//       },
//       child: Container(
//         margin: const EdgeInsets.only(right: 10),
//         height: size.height * 0.45,
//         width: size.width * 0.5,
//         decoration:
//             BoxDecoration(color: red, borderRadius: BorderRadius.circular(10)),
//         child: reefData != null && reefData != ""
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: MomentVideo(
//                   moment: reefData,
//                 ),
//               )
//             : null,
//       ),
//     );
//   }
// }

