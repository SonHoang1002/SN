// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:social_network_app_mobile/constant/common.dart';
// import 'package:social_network_app_mobile/theme/colors.dart';

// class CreateFeedMenu extends StatelessWidget {
//   final Function handleChooseMenu;
//   final dynamic menuSelected;
//   const CreateFeedMenu({
//     super.key,
//     required this.handleChooseMenu,
//     this.menuSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     List menuDisabled = menuSelected?['disabled'] ?? [];

//     return Container(
//       decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           border: const Border(top: BorderSide(width: 0.1, color: greyColor))),
//       child: GridView.builder(
//         shrinkWrap: true,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisSpacing: 4,
//           mainAxisSpacing: 4,
//           crossAxisCount: 4,
//         ),
//         itemCount: listMenuPost.length,
//         itemBuilder: (context, index) {
//           bool isDisabled = menuDisabled.contains(listMenuPost[index]['key']);
//           return InkWell(
//             onTap: isDisabled
//                 ? null
//                 : () {
//                     handleChooseMenu(listMenuPost[index], 'menu_in');
//                   },
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   listMenuPost[index]['image'] != null
//                       ? SvgPicture.asset(
//                           listMenuPost[index]['image'],
//                           width: 20,
//                           color: isDisabled ? greyColor : null,
//                         )
//                       : const SizedBox(),
//                   listMenuPost[index]['icon'] != null
//                       ? Icon(
//                           listMenuPost[index]['icon'],
//                           color: isDisabled
//                               ? greyColor
//                               : Color(listMenuPost[index]['color']),
//                           size: 18,
//                         )
//                       : const SizedBox(),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Text(
//                     listMenuPost[index]['label'],
//                     style: TextStyle(
//                         fontSize: 12, color: isDisabled ? greyColor : null),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CreateFeedMenu extends StatelessWidget {
  final Function handleChooseMenu;
  final dynamic menuSelected;
  const CreateFeedMenu({
    super.key,
    required this.handleChooseMenu,
    this.menuSelected,
  });

  @override
  Widget build(BuildContext context) {
    List menuDisabled = menuSelected?['disabled'] ?? [];

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(top: BorderSide(width: 0.1, color: greyColor))),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 4,
        ),
        itemCount: listMenuPost.length,
        itemBuilder: (context, index) {
          bool isDisabled = menuDisabled.contains(listMenuPost[index]['key']);
          return InkWell(
            onTap: isDisabled
                ? null
                : () {
                    handleChooseMenu(listMenuPost[index], 'menu_in');
                  },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  listMenuPost[index]['image'] != null
                      ? SvgPicture.asset(
                          listMenuPost[index]['image'],
                          width: 20,
                          color: isDisabled ? greyColor : null,
                        )
                      : const SizedBox(),
                  listMenuPost[index]['icon'] != null
                      ? Icon(
                          listMenuPost[index]['icon'],
                          color: isDisabled
                              ? greyColor
                              : Color(listMenuPost[index]['color']),
                          size: 18,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    listMenuPost[index]['label'],
                    style: TextStyle(
                        fontSize: 12, color: isDisabled ? greyColor : null),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
