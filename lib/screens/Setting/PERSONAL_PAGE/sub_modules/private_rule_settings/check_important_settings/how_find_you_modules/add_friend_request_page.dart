import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/how_find_you_modules/how_find_you_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/how_find_you_modules/phone_and_email_page.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class AddFriendRequestPage extends StatelessWidget {
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
                title:
                    AddFriendRequestConstants.ADD_FRIEND_REQUEST_APPBAR_TITLE),
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
                      AddFriendRequestConstants.ADD_FRIEND_REQUEST_TITLE, true,
                      fontSize: 16),
                  SizedBox(
                    height: 5,
                  ),
                  // content
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: buildTextContent(
                            AddFriendRequestConstants
                                .ADD_FRIEND_REQUEST_CONTENT["data"]["title"],
                            false,
                            fontSize: 16,
                            // colorWord: Colors.grey
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          width: 200,
                          child: GestureDetector(
                            onTap: (() {
                              showCustomBottomSheet(
                                  context, 300, title:" lam cai nay di");
                            }),
                            child: GeneralComponent(
                              [
                                buildTextContent(
                                    AddFriendRequestConstants
                                            .ADD_FRIEND_REQUEST_CONTENT["data"]
                                        ["content"],
                                    true,
                                    fontSize: 17)
                              ],
                              prefixWidget: Container(
                                height: 15,
                                width: 15,
                                margin: EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  AddFriendRequestConstants
                                          .ADD_FRIEND_REQUEST_CONTENT["data"]
                                      ["icon"],
                                  // color: Colors.grey[200],
                                ),
                              ),
                              suffixWidget: Container(
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
                  SizedBox(
                    height: 10,
                  ),
                  GeneralComponent(
                    [
                      buildTextContent(
                        AddFriendRequestConstants.ADD_FRIEND_REQUEST_TIP["data"]
                            ["title"],
                        false,
                        fontSize: 16,
                        // colorWord: Colors.grey[200]
                      )
                    ],
                    prefixWidget: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        AddFriendRequestConstants.ADD_FRIEND_REQUEST_TIP["data"]
                            ["icon"],
                        // color: Colors.grey[200],
                      ),
                    ),
                    changeBackground: Colors.grey[300],
                    borderRadiusValue: 10,
                  )
                ],
              ),
            ),
          ),

          buildBottomNavigatorDotWidget(
              context,
              3,
              1,
              AddFriendRequestConstants.ADD_FRIEND_REQUEST_NEXT,
              PhoneAndEmailPage()),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
