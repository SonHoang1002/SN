import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/set_your_data_modules/location_page.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/set_your_data_modules/set_your_data_constants.dart';
import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../../../../../widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import '../../../../../../../widget/GeneralWidget/bottom_navigator_dot_widget.dart';
import '../../../../../../../widget/GeneralWidget/show_bottom_sheet_widget.dart';

class ApplicationAndWebsitePage extends StatelessWidget {
  late double width = 0;

  late double height = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BackIconAppbar(),
            AppBarTitle(
                title: ApplicationAndWebsiteConstants
                    .APPLICATION_AND_WEBSITE_APPBAR_TITLE),
            SizedBox(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.grey[900],
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 5),
                children: [
                  // title
                  buildTextContent(
                    ApplicationAndWebsiteConstants
                        .APPLICATION_AND_WEBSITE_TITLE,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: ApplicationAndWebsiteConstants
                            .APPLICATION_AND_WEBSITE_CONTENTS["data"].length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: GeneralComponent(
                              [
                                Container(
                                  // width: 200,
                                  child: buildTextContent(
                                      ApplicationAndWebsiteConstants
                                              .APPLICATION_AND_WEBSITE_CONTENTS[
                                          "data"][index]["title"],
                                      true,
                                      fontSize: 16),
                                )
                              ],
                              prefixWidget: Container(
                                padding: EdgeInsets.only(right: 15),
                                child: Image.asset(
                                  SettingConstants.PATH_IMG + "cat_1.png",
                                  height: 40,
                                ),
                              ),
                              suffixWidget:
                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //       backgroundColor: Colors.grey[700],
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(7.0),)),
                                  //   onPressed: (() {}),
                                  //   child: buildTextContent("Xoá, gỡ bỏ", true,
                                  //       fontSize: 17),
                                  // )
                                  GestureDetector(
                                onTap: (() {
                                  showBottomSheetCheckImportantSettings(
                                      context,
                                      370,
                                      ApplicationAndWebsiteConstants
                                              .APPLICATION_AND_WEBSITE_BOTTOM_SHEET_CONTENTS[
                                          'title'],
                                      widget: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: ApplicationAndWebsiteConstants
                                              .APPLICATION_AND_WEBSITE_BOTTOM_SHEET_CONTENTS[
                                                  "data"]
                                              .length,
                                          itemBuilder: ((context, index) {
                                            return GeneralComponent(
                                              [
                                                buildTextContent(
                                                    ApplicationAndWebsiteConstants
                                                            .APPLICATION_AND_WEBSITE_BOTTOM_SHEET_CONTENTS[
                                                        "data"][index]["title"],
                                                    false),
                                              ],
                                              suffixWidget:
                                                  ApplicationAndWebsiteConstants
                                                                      .APPLICATION_AND_WEBSITE_BOTTOM_SHEET_CONTENTS[
                                                                  "data"][index]
                                                              ["icon"] !=
                                                          null
                                                      ? Container(
                                                          child: Checkbox(
                                                          value: true,
                                                          onChanged:
                                                              ((value) {}),
                                                        ))
                                                      : null,
                                            );
                                          })));
                                }),
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      // color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(7)),
                                  child: buildTextContent("Xoá, gỡ bỏ", true,
                                      fontSize: 17),
                                ),
                              ),
                              changeBackground: Colors.grey[300],
                              suffixFlexValue: 10,
                              // padding: EdgeInsets.zero,
                            ),
                          );
                        })),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: GeneralComponent(
                      [
                        buildTextContent(
                            ApplicationAndWebsiteConstants
                                .APPLICATION_AND_WEBSITE_TIP["content"],
                            false,
                            // colorWord: Colors.grey[300],
                            fontSize: 16)
                      ],
                      prefixWidget: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          ApplicationAndWebsiteConstants
                              .APPLICATION_AND_WEBSITE_TIP["icon"],
                          color: Colors.blue,
                          // height: 40,
                        ),
                      ),
                      changeBackground: Colors.grey[300],
                      borderRadiusValue: 7,
                    ),
                  )
                ],
              ),
            ),
          ),

          buildBottomNavigatorDotWidget(
              context,
              2,
              1,
              ApplicationAndWebsiteConstants.APPLICATION_AND_WEBSITE_NEXT,
              LocationPage()),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}

// Container(
//                             child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Flexible(
//                                     flex: 8,
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           padding: EdgeInsets.only(right: 15),
//                                           child: Image.asset(
//                                             SettingConstants.PATH_IMG +
//                                                 "cat_1.png",
//                                             height: 40,
//                                           ),
//                                         ),
//                                         buildTextContent(ApplicationAndWebsiteConstants
//                                                       .APPLICATION_AND_WEBSITE_CONTENTS[
//                                                   "data"][index]["title"], true,fontSize: 15),
//                                         // Wrap(
//                                         //   children: [
//                                         //     Text(
//                                         //       ApplicationAndWebsiteConstants
//                                         //               .APPLICATION_AND_WEBSITE_CONTENTS[
//                                         //           "data"][index]["title"],
//                                         //       style: TextStyle(
//                                         //           color:  white),
//                                         //     ),
//                                         //   ],
//                                         // )
//                                       ],
//                                     ),
//                                   ),
//                                   Flexible(
//                                     flex: 2,
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 80,
//                                           height: 50,
//                                           padding: EdgeInsets.only(right: 15),
//                                           decoration: BoxDecoration(
//                                               color: Colors.red,
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10))),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ]),
//                           )