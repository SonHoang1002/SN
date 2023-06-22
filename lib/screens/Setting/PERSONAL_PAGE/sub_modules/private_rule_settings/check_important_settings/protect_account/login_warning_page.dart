import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/protect_account/password_page.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/protect_account/protect_your_account_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../../../../../../widgets/appbar_title.dart';

class LoginWarningPage extends StatelessWidget {
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
            AppBarTitle(title: LoginWarningConstants.LOGIN_WARNING_APPAR_TITLE),
            SizedBox(),
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
                  // title
                  buildTextContent(
                      LoginWarningConstants.LOGIN_WARNING_TITLE, true,
                      fontSize: 22),
                  SizedBox(
                    height: 5,
                  ),
                  buildTextContent(
                    LoginWarningConstants.LOGIN_WARNING_SUBTITLE, false,
                    fontSize: 15,
                    //  colorWord: Colors.grey
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: LoginWarningConstants
                          .LOGIN_WARNING_CONTENTS["data"].length,
                      itemBuilder: ((context, index) {
                        final data = LoginWarningConstants
                            .LOGIN_WARNING_CONTENTS["data"];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: GeneralComponent(
                            [
                              buildTextContent(data[index]["title"], true,
                                  fontSize: 17),
                              buildTextContent(
                                data[index]["subTitle"], true,
                                fontSize: 14,
                                //  colorWord: Colors.grey
                              )
                            ],
                            prefixWidget: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    // color: Colors.grey[800],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  data[index]["icon"],
                                  // color:  white,
                                )),
                            suffixWidget: Container(
                              height: 30,
                              width: 30,
                              child: Checkbox(
                                onChanged: ((value) {}),
                                value: true,
                              ),
                            ),
                            changeBackground: Colors.grey[300],
                          ),
                        );
                      }))
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorDotWidget(
              context, 3, 1, "Bỏ qua", PasswordPage()),

          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
