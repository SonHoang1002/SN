import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'begin_join_login_page.dart';
import 'main_login_page.dart';

// ignore: must_be_immutable
class OnboardingLoginPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  OnboardingLoginPage({super.key});
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Emso",
                          style: TextStyle(
                              fontSize: 22,
                              color: primaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Social",
                          style: TextStyle(
                              fontSize: 22,
                              color: secondaryColor,
                              fontWeight: FontWeight.w700),
                        )
                      ]),
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
                            pushToNextScreen(context, const MainLoginPage());
                          },
                          child: const Text(
                            OnboardingLoginConstants
                                .ONBOARDING_LOGIN_LOGIN_WITH_DIFFERENCE_ACCOUNT,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        buildSpacer(height: 20),
                        GestureDetector(
                          onTap: () {
                            pushToNextScreen(context, BeginJoinEmsoLoginPage());
                          },
                          child: const Text(
                            OnboardingLoginConstants
                                .ONBOARDING_LOGIN_SIGNIN_EMSO_ACCOUNT,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        buildSpacer(height: 30),
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
