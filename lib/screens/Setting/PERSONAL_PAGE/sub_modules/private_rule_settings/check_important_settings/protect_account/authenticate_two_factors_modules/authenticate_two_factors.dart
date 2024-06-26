import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/all_completed_page.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/protect_account/protect_your_account_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import 'main_authenticate_two_factors.dart';

class MainAuthenticateTwoFactorsPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  MainAuthenticateTwoFactorsPage({super.key});
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
                title: AuthenticateTwoFactorsConstants
                    .AUTHENTICATE_TWO_FACTOR_APPAR_TITLE),
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
                padding: const EdgeInsets.symmetric(vertical: 5),
                children: [
                  // title
                  buildTextContent(
                      AuthenticateTwoFactorsConstants
                          .AUTHENTICATE_TWO_FACTOR_TITLE,
                      true,
                      fontSize: 22),
                  const SizedBox(
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
                  const SizedBox(
                    height: 10,
                  ),
                  // change password component hien ra khi nut doi mat khau bien mat
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: GeneralComponent(
                          [
                            buildTextContent(
                              AuthenticateTwoFactorsConstants
                                  .AUTHENTICATE_TWO_FACTOR_CONTENTS["title"],
                              true,
                              fontSize: 20,
                            ),
                            const SizedBox(
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
                                          const SizedBox(
                                            height: 5,
                                          )
                                        ],
                                        prefixWidget: Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            height: 7,
                                            width: 7,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3.5)))),
                                        changeBackground: Colors.grey[300],
                                        padding: EdgeInsets.zero,
                                      );
                                    })))
                          ],
                          prefixWidget: Container(
                            padding: const EdgeInsets.only(right: 15),
                            child: SvgPicture.asset(
                              "${SettingConstants.PATH_ICON}bell_icon.svg",
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
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(width * 0.9, 40),
                            backgroundColor: Colors.blue),
                        child: const Text(
                          AuthenticateTwoFactorsConstants
                              .AUTHENTICATE_TWO_FACTORS_BEGIN_BUTTON,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // push to learn more screen
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(width * 0.9, 40),
                            backgroundColor: Colors.blue),
                        child: const Text(
                          AuthenticateTwoFactorsConstants
                              .AUTHENTICATE_TWO_FACTORS_LEARN_MORE_BUTTON,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          buildBottomNavigatorDotWidget(
              context,
              3,
              3,
              "Bỏ qua",
              AllCompletedPage(
                name: "how_to_protect_your_account",
              )),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
