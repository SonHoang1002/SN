import 'package:flutter/material.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showBottomSheetCheckImportantSettings(
    BuildContext context, double height, String title,
    {Widget? widget}) {
  showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: height,
          decoration: BoxDecoration(
              color: Colors.grey[900],
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
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            //content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 10,
                color: Colors.white,
              ),
            ),
            widget != null ? widget : Container()
            // Container(
            //   child: ListView.builder(
            //       padding: EdgeInsets.zero,
            //       shrinkWrap: true,
            //       itemCount: CheckImportantSettingsCommon
            //           .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS["data"]
            //           .length,
            //       itemBuilder: ((context, index) {
            //         return Container(
            //           margin: EdgeInsets.symmetric(vertical: 5),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               GestureDetector(
            //                 onTap: (() {}),
            //                 child: GeneralComponent(
            //                   [
            //                     buildTextContent(
            //                         CheckImportantSettingsCommon
            //                                 .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
            //                             "data"][index]["title"],
            //                         true,
            //                         fontSize: 18),
            //                     SizedBox(
            //                       height: 5,
            //                     ),
            //                     buildTextContent(
            //                         CheckImportantSettingsCommon
            //                                 .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
            //                             "data"][index]["subTitle"],
            //                         true,
            //                         fontSize: 16,
            //                         colorWord: Colors.grey),
            //                   ],
            //                   prefixWidget: Container(
            //                     padding: EdgeInsets.only(
            //                       right: 15,
            //                     ),
            //                     child: SvgPicture.asset(
            //                       CheckImportantSettingsCommon
            //                               .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
            //                           "data"][index]["icon"],
            //                       height: 20,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                   padding: EdgeInsets.symmetric(
            //                       horizontal: 5, vertical: 5),
            //                   changeBackground: Colors.transparent,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       })),
            // )
          ]),
        );
      });
}
