import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import 'begin_join_emso_login_page.dart';
import 'search_account_login_page.dart';

class MainLoginPage extends StatelessWidget {
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
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const BackIconAppbar(),
            ),
          ],
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
                            buildButtonForLoginWidget(
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
                      buildButtonForLoginWidget(
                        title: "Tiếp tục với Google",
                        width: width,
                        bgColor: blueColor,
                        function: () {
                          pushToNextScreen(context, BeginJoinEmsoLoginPage());
                        },
                      ),
                      buildButtonForLoginWidget(
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
        ]),
      ),
    );
  }
}

Widget _buildTextFormField(
    // TextEditingController controller,
    String placeHolder) {
  return Container(
    height: 50,
    child: TextFormField(
      // controller: controller,
      onChanged: ((value) {}),
      validator: (value) {},
      obscureText:
          placeHolder == MainLoginConstants.MAIN_LOGIN_PASSWORD_PLACEHOLDER,
      decoration: InputDecoration(
          counterText: "",
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: greyColor, width: 0.2),
          ),
          hintText: placeHolder,
          hintStyle: const TextStyle(
            color: greyColor,
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 30),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
    ),
  );
}
