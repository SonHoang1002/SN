import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

import '../../theme/colors.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showCustomBottomSheet(BuildContext context, double height, String title,
    {Widget? widget,
    Color? bgColor,
    bool? isBarrierTransparent = false,
    bool? isHaveHeader = true,
    IconData? iconData}) {
  final bgColor1 = ThemeMode.dark == true
      ? Theme.of(context).cardColor
      : const Color(0xfff1f2f5);
  showModalBottomSheet(
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      barrierColor: isBarrierTransparent! ? transparent : null,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      backgroundColor: transparent,
      // context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: height,
          decoration: BoxDecoration(
              color: bgColor1,
              // color: bgColor ?? greyColor[300],
              borderRadius: const BorderRadius.only(
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
                        topLeft: Radius.circular(15))),
              ),
            ),
            //  title
            isHaveHeader!
                ? Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            iconData ?? FontAwesomeIcons.close,
                            // color: white,
                            // size: 15,
                          ),
                        ),
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              // color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox()
                      ],
                    ),
                  )
                : SizedBox(),
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
      });
}
