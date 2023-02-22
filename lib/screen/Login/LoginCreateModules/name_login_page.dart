import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import '../widgets/have_account_widget.dart';
import 'birthday_login_page.dart';
import 'main_login_page.dart';

class NameLoginPage extends StatefulWidget {
  const NameLoginPage({super.key});

  @override
  State<NameLoginPage> createState() => _NameLoginPageState();
}

class _NameLoginPageState extends State<NameLoginPage> {
  late double width = 0;
  late double height = 0;
  String name = '';
  bool isFillAll = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    checkFillAllInput();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          hiddenKeyboard(context);
        }),
        child: Column(children: [
          // main content
          Expanded(
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
                                NameLoginConstants.NAME_LOGIN_TITLE, true,
                                fontSize: 17,
                                colorWord: blackColor,
                                isCenterLeft: false),
                            buildSpacer(height: 25),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 20,
                              child: TextFormFieldCustom(
                                autofocus: true,
                                hintText: "Họ và tên",
                                handleGetValue: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                              ),
                            ),
                            buildSpacer(height: 15),
                            isFillAll
                                ? SizedBox(
                                    height: 36,
                                    child: ButtonPrimary(
                                      label: "Tiếp tục",
                                      handlePress: () {
                                        pushAndReplaceToNextScreen(
                                            context, const BirthdayLoginPage());
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: buildTextContent(
                                      NameLoginConstants.NAME_LOGIN_SUBTITLE,
                                      true,
                                      fontSize: 16,
                                      colorWord: Colors.grey,
                                      isCenterLeft: false,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildHaveAccountWidget(function: () {
            pushToNextScreen(context, const MainLoginPage());
          })
        ]),
      ),
    );
  }

  checkFillAllInput() {
    if (name.trim().isNotEmpty) {
      setState(() {
        isFillAll = true;
      });
    } else {
      setState(() {
        isFillAll = false;
      });
    }
  }
}
