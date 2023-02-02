import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/check_important_settings_commons.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/check_private_rule_component_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../../../../../widget/GeneralWidget/show_bottom_sheet_widget.dart';
import '../../../../../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../../../setting_constants/general_settings_constants.dart';

class CheckImportantSettingsPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  String _selectedBottomNavigator = "Trang chủ";

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
            CloseIconAppbar(),
            // AppBarTitle(title: "Cài đặt"),
            MenuIconAppbar(),
          ],
        ),
      ),
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
                  SizedBox(
                    height: 5,
                  ),
                  // title
                  buildTextContent(
                      CheckImportantSettingsCommons
                          .CHECK_IMPORTANT_SETTINGS_TITLE,
                      true,
                      fontSize: 20),
                  //subTitle
                  buildTextContent(
                      CheckImportantSettingsCommons
                          .CHECK_IMPORTANT_SETTINGS_SUBTITLE,
                      true,
                      fontSize: 17,
                      // colorWord: Colors.grey
                      ),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextContent(
                      CheckImportantSettingsCommons
                          .CHECK_IMPORTANT_SETTINGS_QUESTION,
                      true,
                      fontSize: 17,
                      // colorWord: Colors.grey
                      ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 200,
                          mainAxisSpacing: 10),
                      itemCount: CheckImportantSettingsCommons
                          .CHECK_IMPORTANT_SETTINGS_CONTENTS["data"].length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: (() {
                            pushToNextScreen(
                              context,
                              CheckPrivateRuleComponentPage(
                                  path: CheckImportantSettingsCommons
                                          .CHECK_IMPORTANT_SETTINGS_CONTENTS[
                                      "data"][index]["img"],
                                  name: CheckImportantSettingsCommons
                                          .CHECK_IMPORTANT_SETTINGS_CONTENTS[
                                      "data"][index]["key"]),
                            );
                          }),
                          child: _buildCheckImportantSettingContentItem(
                              CheckImportantSettingsCommons
                                      .CHECK_IMPORTANT_SETTINGS_CONTENTS["data"]
                                  [index]["img"],
                              CheckImportantSettingsCommons
                                      .CHECK_IMPORTANT_SETTINGS_CONTENTS["data"]
                                  [index]["content"]),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextContent(
                      CheckImportantSettingsCommons
                          .CHECK_IMPORTANT_SETTINGS_ADDITINAL_INFORMATION,
                      true,
                      fontSize: 17,
                      // colorWord: Colors.grey
                      ),
                  SizedBox(
                    height: 37,
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Widget _buildCheckImportantSettingContentItem(String path, String title,
    {double? height, double? width}) {
  return Container(
    height: height ?? 0,
    width: width ?? 0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[200]
        ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          flex: 5,
          child: Image.asset(
            path,
            fit: BoxFit.fitWidth,
          ),
        ),
        Flexible(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: buildTextContent(title, true, fontSize: 19)),
        )
      ]),
    ),
  );
}

// showBottomSheetCheckImportantSettings(BuildContext context) {
//   showMaterialModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setStateFull) {
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             height: 235,
//             decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     topLeft: Radius.circular(15))),
//             child: Column(children: [
//               // drag and drop navbar
//               Container(
//                 padding: EdgeInsets.only(top: 5),
//                 margin: EdgeInsets.only(bottom: 15),
//                 child: Container(
//                   height: 4,
//                   width: 40,
//                   decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(15),
//                           topLeft: Radius.circular(15))),
//                 ),
//               ),
//               //  title
//               Text(
//                 "Bạn có thể làm gì ?",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               //content
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Divider(
//                   height: 10,
//                   color: Colors.white,
//                 ),
//               ),
//               Container(
//                 child: ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: CheckImportantSettingsCommons
//                         .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS["data"]
//                         .length,
//                     itemBuilder: ((context, index) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(vertical: 5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             GestureDetector(
//                               onTap: (() {}),
//                               child: GeneralComponent(
//                                 [
//                                   buildTextContent(
//                                       CheckImportantSettingsCommons
//                                               .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
//                                           "data"][index]["title"],
//                                       true,
//                                       fontSize: 18),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   buildTextContent(
//                                       CheckImportantSettingsCommons
//                                               .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
//                                           "data"][index]["subTitle"],
//                                       true,
//                                       fontSize: 16,
//                                       colorWord: Colors.grey),
//                                 ],
//                                 prefixWidget: Container(
//                                   padding: EdgeInsets.only(
//                                     right: 15,
//                                   ),
//                                   child: SvgPicture.asset(
//                                     CheckImportantSettingsCommons
//                                             .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
//                                         "data"][index]["icon"],
//                                     height: 20,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 5, vertical: 5),
//                                 changeBackground: Colors.transparent,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     })),
//               )
//             ]),
//           );
//         });
//       });
// }
