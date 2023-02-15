
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/all_completed_page.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/how_protect_account_modules/authenticate_two_factors_modules/begin_main_authenticate_two_factors_page.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/how_protect_account_modules/protect_your_account_constants.dart';
import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
class MainAuthenticateTwoFactorsPage extends StatelessWidget {
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
            AppBarTitle(title: AuthenticateTwoFactorsConstants.AUTHENTICATE_TWO_FACTOR_APPAR_TITLE),
            SizedBox(),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      // backgroundColor: Colors.grey[900],
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
                      AuthenticateTwoFactorsConstants
                          .AUTHENTICATE_TWO_FACTOR_TITLE,
                      true,
                      fontSize: 22),
                  SizedBox(
                    height: 5,
                  ),
                  //subTitle
                  buildTextContent(
                      AuthenticateTwoFactorsConstants
                          .AUTHENTICATE_TWO_FACTOR_SUBTITLE,
                      false,
                      fontSize: 15,
                      // colorWord: Colors.grey
                      ),
                  SizedBox(
                    height: 10,
                  ),
                  // change password component hien ra khi nut doi mat khau bien mat
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: GeneralComponent(
                          [
                            buildTextContent(
                              AuthenticateTwoFactorsConstants
                                  .AUTHENTICATE_TWO_FACTOR_CONTENTS["title"],
                              true,
                              fontSize: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: AuthenticateTwoFactorsConstants
                                        .AUTHENTICATE_TWO_FACTOR_CONTENTS[
                                            "subTitle"]
                                        .length,
                                    itemBuilder: ((context, index) {
                                      return GeneralComponent(
                                        [
                                          buildTextContent(
                                              AuthenticateTwoFactorsConstants
                                                      .AUTHENTICATE_TWO_FACTOR_CONTENTS[
                                                  "subTitle"][index],
                                              false,
                                              fontSize: 15,
                                              // colorWord: Colors.grey
                                              ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                        prefixWidget: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3.5)))),
                                        changeBackground: Colors.grey[300],
                                        padding: EdgeInsets.zero,
                                      );
                                    })))
                          ],
                          prefixWidget: Container(
                            padding: EdgeInsets.only(right: 15),
                            child: SvgPicture.asset(
                              SettingConstants.PATH_ICON + "bell_icon.svg",
                              height: 20,
                              // color: Colors.white,
                            ),
                          ),
                          changeBackground: Colors.grey[300],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pushToNextScreen(
                              context, BeginAuthenticateTwoFactorsPage());
                        },
                        child: Text(
                          AuthenticateTwoFactorsConstants
                              .AUTHENTICATE_TWO_FACTORS_BEGIN_BUTTON,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(width * 0.9, 40),
                            backgroundColor: Colors.blue),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // push to learn more screen
                        },
                        child: Text(
                          AuthenticateTwoFactorsConstants
                              .AUTHENTICATE_TWO_FACTORS_LEARN_MORE_BUTTON,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(width * 0.9, 40),
                            backgroundColor: Colors.blue),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          buildBottomNavigatorDotWidget(context, 3, 3, "Bỏ qua", AllCompletedPage(name: "how_to_protect_your_account",)),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
