
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/how_find_you_modules/how_find_you_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/how_find_you_modules/search_tool_page.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class PhoneAndEmailPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  PhoneAndEmailPage({super.key});
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
            BackIconAppbar(),
            AppBarTitle(
                title: PhoneAndEmailConstants.PHONE_AND_EMAIL_APPBAR_TITLE),
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
                padding: const EdgeInsets.symmetric(vertical: 5),
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  // tip
                  GeneralComponent(
                    [
                      buildTextContent(
                        PhoneAndEmailConstants.PHONE_AND_EMAIL_TIP["data"]
                            ["title"],
                        false,
                        fontSize: 16,
                        // colorWord: Colors.grey[200]
                      )
                    ],
                    prefixWidget: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        PhoneAndEmailConstants.PHONE_AND_EMAIL_TIP["data"]
                            ["icon"],
                        // color: Colors.grey[200],
                      ),
                    ),
                    changeBackground: Colors.grey[300],
                    borderRadiusValue: 10,
                  ),
                  // title
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: buildTextContent(
                      PhoneAndEmailConstants.PHONE_AND_EMAIL_TITLE, false,
                      fontSize: 16,
                      // colorWord: Colors.grey[200]
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: PhoneAndEmailConstants
                          .PHONE_AND_EMAIL_CONTENTS["data"].length,
                      itemBuilder: ((context, index) {
                        final data = PhoneAndEmailConstants
                            .PHONE_AND_EMAIL_CONTENTS["data"];
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: buildTextContent(
                                    data[index]["title"], false,
                                    fontSize: 16,
                                    // colorWord: Colors.grey[200]
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: SizedBox(
                                  width: 200,
                                  child: GestureDetector(
                                    onTap: (() {
                                      showCustomBottomSheet(context, 300,
                                          title: " lam cai nay di");
                                    }),
                                    child: GeneralComponent(
                                      [
                                        buildTextContent(
                                            data[index]["content"], true,
                                            fontSize: 17)
                                      ],
                                      prefixWidget: Container(
                                        height: 15,
                                        width: 15,
                                        margin: const EdgeInsets.only(right: 10),
                                        child: SvgPicture.asset(
                                          data[index]["icon"],
                                          // color: Colors.grey[200],
                                        ),
                                      ),
                                      suffixWidget: const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Icon(
                                          SettingConstants.DOWN_ICON_DATA,
                                          // color: Colors.grey[200],
                                          size: 16,
                                        ),
                                      ),
                                      changeBackground: Colors.grey[300],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),

          buildBottomNavigatorDotWidget(context, 3, 2,
              PhoneAndEmailConstants.ADD_FRIEND_REQUEST_NEXT, SearchToolPage()),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
