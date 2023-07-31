import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/colors.dart';

showCustomBottomSheet(BuildContext context, double height,
    {String? title = "",
    Widget? widget,
    Color? bgColor,
    bool? isBarrierTransparent = false,
    Widget? suffixWidget,
    Function? prefixFunction,
    IconData? iconData,
    double? paddingHorizontal,
    bool? isDismissible = true,
    bool? enableDrag = true,
    bool? isNoHeader = false,
    bool? isShowCloseButton = true,
    Function? onEnd,
    bool? isHaveCloseButton = true}) {
  const Color transparent = Colors.transparent;
  showModalBottomSheet(
      enableDrag: enableDrag!,
      isDismissible: isDismissible!,
      context: context,
      isScrollControlled: true,
      barrierColor: isBarrierTransparent! ? transparent : null,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          height: height,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(children: [
            // drag and drop navbar
            Container(
              padding: const EdgeInsets.only(top: 5),
              margin: const EdgeInsets.only(bottom: 15),
              child: Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              ),
            ),
            !isNoHeader!
                ? Column(
                    children: [
                      //  title
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isShowCloseButton!
                                ? GestureDetector(
                                    onTap: () {
                                      prefixFunction != null
                                          ? prefixFunction()
                                          : Navigator.pop(context);
                                    },
                                    child: Icon(
                                      iconData ?? FontAwesomeIcons.close,
                                    ),
                                  )
                                : const SizedBox(),
                            Text(
                              title!,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            suffixWidget ?? const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            //content
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 10,
                color: white,
              ),
            ),
            widget ?? Container()
          ]),
        );
      }).whenComplete(() {
    onEnd != null ? onEnd() : null;
  });
}
 
// showCustomBottomSheet(BuildContext context, double height, String title,
//     {Widget? widget,
//     Color? bgColor,
//     bool? isBarrierTransparent = false,
//     bool? isHaveHeader = true,
//     IconData? iconData,
//     bool? isHaveCloseButton = true}) {
//   final bgColor1 = Theme.of(context).scaffoldBackgroundColor;
//   showModalBottomSheet(
//       enableDrag: true,
//       context: context,
//       isScrollControlled: true,
//       barrierColor: isBarrierTransparent! ? transparent : null,
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
//       backgroundColor: transparent,
//       // context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           height: height,
//           decoration: BoxDecoration(
//               color: bgColor1,
//               // color: bgColor ?? greyColor[300],
//               borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(15), topLeft: Radius.circular(15))),
//           child: Column(children: [
//             // drag and drop navbar
//             Container(
//               padding: const EdgeInsets.only(top: 5),
//               margin: const EdgeInsets.only(bottom: 15),
//               child: Container(
//                 height: 4,
//                 width: 40,
//                 decoration: const BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(15),
//                         topLeft: Radius.circular(15))),
//               ),
//             ),
//             //  title
//             isHaveHeader!
//                 ? Container(
//                     padding: const EdgeInsets.only(left: 5, right: 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         isHaveCloseButton!
//                             ? GestureDetector(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Icon(
//                                   iconData ?? FontAwesomeIcons.close,
//                                   // color: white,
//                                   // size: 15,
//                                 ),
//                               )
//                             : const SizedBox(),
//                         Text(
//                           title,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox()
//                       ],
//                     ),
//                   )
//                 : SizedBox(),
//             //content
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Divider(
//                 height: 10,
//                 color: white,
//               ),
//             ),
//             widget ?? Container()
//           ]),
//         );
//       });
// }
