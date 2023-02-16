import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'begin_join_emso_login_page.dart';
import 'main_login_page.dart';
import 'setting_login_page.dart';

class OnboardingLoginPage extends StatelessWidget {
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              // color: Colors.grey[900],
              child: Column(
                // padding: EdgeInsets.symmetric(vertical: 5),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // title
                  Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: const BorderRadius.all(Radius.circular(30))),
                      child: Image.asset("${LoginConstants.PATH_IMG}cat_1.png"),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            // borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Image.asset(
                              "${LoginConstants.PATH_IMG}avatar_img.png"),
                        ),
                        buildTextContent(
                            OnboardingLoginConstants.ONBOARDING_LOGIN_USERNAME,
                            true,
                            fontSize: 16,
                            colorWord: Colors.black,
                            isCenterLeft: false)
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pushToNextScreen(context, SettingLoginPage());
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                                // color: Colors.grey[900],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: const Icon(
                              FontAwesomeIcons.gear,
                              color: blackColor,
                            ),
                          ),
                        ),
                        buildSpacer(height: 20),
                        buildTextContent(
                            OnboardingLoginConstants
                                .ONBOARDING_LOGIN_LOGIN_WITH_DIFFERENCE_ACCOUNT,
                            true,
                            fontSize: 15,
                            colorWord: blackColor,
                            isCenterLeft: false, function: () {
                          pushToNextScreen(context, MainLoginPage());
                        }),
                        buildSpacer(height: 20),
                        buildTextContent(
                            OnboardingLoginConstants
                                .ONBOARDING_LOGIN_SIGNIN_EMSO_ACCOUNT,
                            true,
                            fontSize: 15,
                            colorWord: blackColor,
                            isCenterLeft: false, function: () {
                          pushToNextScreen(context, BeginJoinEmsoLoginPage());
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
