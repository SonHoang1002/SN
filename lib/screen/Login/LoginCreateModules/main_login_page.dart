import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/authen_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/screen/Login/LoginCreateModules/confirm_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class MainLoginPage extends ConsumerStatefulWidget {
  const MainLoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainLoginPage> createState() => _MainLoginPageState();
}

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../widget/back_icon_appbar.dart';
import '../widgets/build_elevateButton_widget.dart';
import 'begin_join_emso_login_page.dart';
import 'search_account_login_page.dart';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          hiddenKeyboard(context);
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const BackIconAppbar(), Container()],
            ),
          ),
          body: getBody(context, size),
        ),
      ),
      resizeToAvoidBottomInset: false,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // img
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 270,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                          ),
                          child: Image.asset(
                            LoginConstants.PATH_IMG + "example_cover_img_1.jpg",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Column(
                            children: [
                              _buildTextFormField(MainLoginConstants
                                  .MAIN_LOGIN_EMAIL_OR_PHONE_PLACEHOLDER),
                              buildSpacer(height: 5),
                              _buildTextFormField(MainLoginConstants
                                  .MAIN_LOGIN_PASSWORD_PLACEHOLDER),
                              buildElevateButtonWidget(
                                  title: MainLoginConstants
                                      .MAIN_LOGIN_LOGIN_TEXT_BUTTON,
                                  width: width,
                                  marginBottom: 20),
                              buildTextContent(
                                  MainLoginConstants.MAIN_LOGIN_FORGET_PASSWORD,
                                  true,
                                  fontSize: 16,
                                  colorWord: Colors.red,
                                  isCenterLeft: false, function: () {
                                pushToNextScreen(
                                    context, SearchAccountLoginPage());
                              }),
                              buildSpacer(height: 15),
                              buildTextContent(
                                  MainLoginConstants.MAIN_LOGIN_BACK_TEXT, true,
                                  fontSize: 16,
                                  colorWord: greyColor,
                                  isCenterLeft: false, function: () {
                                popToPreviousScreen(context);
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Column(
                      children: [
                        // buildTextContent(
                        //     MainLoginConstants.MAIN_LOGIN_OR_TEXT, true,
                        //     fontSize: 16,
                        //     colorWord: Colors.black,
                        //     isCenterLeft: false),
                        buildSpacer(height: 20),
                        buildElevateButtonWidget(
                          title: "Tiếp tục với Google",
                          width: width,
                          bgColor: blueColor,
                          function: () {
                            pushToNextScreen(context, BeginJoinEmsoLoginPage());
                          },
                        ),
                        buildElevateButtonWidget(
                          title:
                              MainLoginConstants.MAIN_LOGIN_CREATE_NEW_ACCOUNT,
                          // colorText: Colors.orange,
                          width: width,
                          bgColor: secondaryColor,
                          function: () {
                            pushToNextScreen(context, BeginJoinEmsoLoginPage());
                          },
                        ),
                        buildSpacer(height: 10),
                      ],
                    ),
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
