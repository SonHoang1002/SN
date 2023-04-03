import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/have_account_widget.dart';
import 'main_login_page.dart';
import 'name_login_page.dart';

// ignore: must_be_immutable
class BeginJoinEmsoLoginPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  BeginJoinEmsoLoginPage({super.key});
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
      bottomNavigationBar: SizedBox(
        height: 80,
        child: buildHaveAccountWidget(function: () {
          pushToNextScreen(context, const MainLoginPage(null));
        }),
      ),
      body: GestureDetector(
        onTap: (() {
          hiddenKeyboard(context);
        }),
        child: Column(children: [
          // main content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // img
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Column(
                        children: [
                          buildTextContent(
                              BeginJoinEmsoLoginConstants
                                  .BEGIN_JOIN_EMSO_LOGIN_TITLE,
                              true,
                              fontSize: 17,
                              colorWord: primaryColor,
                              isCenterLeft: false),
                          buildSpacer(height: 15),
                          buildTextContent(
                            BeginJoinEmsoLoginConstants
                                .BEGIN_JOIN_EMSO_LOGIN_SUBTITLE,
                            false,
                            fontSize: 15,
                            isCenterLeft: false,
                          ),
                          buildSpacer(height: 25),
                          SizedBox(
                            height: 36,
                            child: ButtonPrimary(
                                label: "Bắt đầu",
                                handlePress: () {
                                  pushToNextScreen(
                                      context, const NameLoginPage());
                                }),
                          ),
                          buildSpacer(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
