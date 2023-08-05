import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/check_important_settings_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/check_private_rule_component.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../../../../../widgets/GeneralWidget/text_content_widget.dart';

class CheckImportantSettingsPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  CheckImportantSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                padding: const EdgeInsets.symmetric(vertical: 5),
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  // title
                  buildTextContent(
                      CheckImportantSettingsConstants
                          .CHECK_IMPORTANT_SETTINGS_TITLE,
                      true,
                      fontSize: 20),
                  //subTitle
                  buildTextContent(
                    CheckImportantSettingsConstants
                        .CHECK_IMPORTANT_SETTINGS_SUBTITLE,
                    true,
                    fontSize: 17,
                    // colorWord: Colors.grey
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildTextContent(
                    CheckImportantSettingsConstants
                        .CHECK_IMPORTANT_SETTINGS_QUESTION,
                    true,
                    fontSize: 17,
                    // colorWord: Colors.grey
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 200,
                              mainAxisSpacing: 10),
                      itemCount: CheckImportantSettingsConstants
                          .CHECK_IMPORTANT_SETTINGS_CONTENTS["data"].length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: (() {
                            pushToNextScreen(
                              context,
                              CheckPrivateRuleComponentPage(
                                  path: CheckImportantSettingsConstants
                                          .CHECK_IMPORTANT_SETTINGS_CONTENTS[
                                      "data"][index]["img"],
                                  name: CheckImportantSettingsConstants
                                          .CHECK_IMPORTANT_SETTINGS_CONTENTS[
                                      "data"][index]["key"]),
                            );
                          }),
                          child: _buildCheckImportantSettingContentItem(
                              CheckImportantSettingsConstants
                                      .CHECK_IMPORTANT_SETTINGS_CONTENTS["data"]
                                  [index]["img"],
                              CheckImportantSettingsConstants
                                      .CHECK_IMPORTANT_SETTINGS_CONTENTS["data"]
                                  [index]["content"]),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildTextContent(
                    CheckImportantSettingsConstants
                        .CHECK_IMPORTANT_SETTINGS_ADDITINAL_INFORMATION,
                    true,
                    fontSize: 17,
                    // colorWord: Colors.grey
                  ),
                  const SizedBox(
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
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[200]),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: buildTextContent(title, true, fontSize: 19)),
        )
      ]),
    ),
  );
}

// showCustomBottomSheet(BuildContext context) {
//   showMaterialModalBottomSheet(
//       backgroundColor: transparent,
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
//                     color:  white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               //content
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Divider(
//                   height: 10,
//                   color:  white,
//                 ),
//               ),
//               Container(
//                 child: ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: CheckImportantSettingsConstants
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
//                                       CheckImportantSettingsConstants
//                                               .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
//                                           "data"][index]["title"],
//                                       true,
//                                       fontSize: 18),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   buildTextContent(
//                                       CheckImportantSettingsConstants
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
//                                     CheckImportantSettingsConstants
//                                             .CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS[
//                                         "data"][index]["icon"],
//                                     height: 20,
//                                     color:  white,
//                                   ),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 5, vertical: 5),
//                                 changeBackground: transparent,
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
