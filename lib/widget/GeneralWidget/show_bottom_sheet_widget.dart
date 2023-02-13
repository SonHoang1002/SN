import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/colors.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showBottomSheetCheckImportantSettings(
    BuildContext context, double height, String title,
    {Widget? widget, Color? bgColor, IconData? iconData}) {
  showModalBottomSheet(
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      barrierColor: transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      backgroundColor: transparent,
      // context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: height,
          decoration: BoxDecoration(
              color: bgColor != null ? bgColor : Colors.grey[800],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(children: [
            // drag and drop navbar
            Container(
              padding: EdgeInsets.only(top: 5),
              margin: EdgeInsets.only(bottom: 15),
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
              ),
            ),
            //  title
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
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
                    style: TextStyle(
                        // color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox()
                ],
              ),
            ),
            //content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 10,
                color: white,
              ),
            ),
            widget != null ? widget : Container()
          ]),
        );
      });
}
