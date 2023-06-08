import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../widgets/build_elevate_button_widget.dart';
import '../widgets/have_account_widget.dart';
import 'main_login_page.dart';
import 'name_login_page.dart';

class BeginJoinEmsoLoginPage extends StatelessWidget {
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
              child: Column(
                // padding: EdgeInsets.symmetric(vertical: 5),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  fontSize: 16,
                                  colorWord: Colors.blue,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),
                              buildTextContent(
                                BeginJoinEmsoLoginConstants
                                    .BEGIN_JOIN_EMSO_LOGIN_SUBTITLE,
                                false,
                                fontSize: 15,
                                colorWord: Colors.grey[700],
                                isCenterLeft: false,
                              ),
                              buildSpacer(height: 25),
                              buildButtonForLoginWidget(
                                  title: BeginJoinEmsoLoginConstants
                                      .BEGIN_JOIN_EMSO_LOGIN_BEGIN_TEXT_BUTTON,
                                  bgColor: secondaryColor,
                                  width: width,
                                  function: () {
                                    pushToNextScreen(context, NameLoginPage());
                                  }),
                              buildSpacer(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildHaveAccountWidget(function: () {
                    pushToNextScreen(context, MainLoginPage(null));
                  })
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
