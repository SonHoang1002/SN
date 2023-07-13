import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/text_form_field_custom.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
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
  dynamic errorText;

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
          hiddenKeyboard(context);
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Column(
                          children: [
                            buildTextContent(
                                NameLoginConstants.NAME_LOGIN_TITLE, true,
                                fontSize: 17,
                                colorWord: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                isCenterLeft: false),
                            buildSpacer(height: 25),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 20,
                              child: TextFormFieldCustom(
                                autofocus: true,
                                hintText: "Họ và tên",
                                handleGetValue: (value) {
                                  if (value.length <= 30) {
                                    setState(() {
                                      name = value;
                                      errorText = null;
                                    });
                                  } else {
                                    setState(() {
                                      errorText = 'Tên không vượt quá 30 kí tự';
                                    });
                                  }
                                },
                                errorText: errorText,
                              ),
                            ),
                            buildSpacer(height: 15),
                            name.trim().isNotEmpty && errorText == null
                                ? SizedBox(
                                    height: 40,
                                    child: ButtonPrimary(
                                      label: "Tiếp tục",
                                      handlePress: () {
                                        pushToNextScreen(
                                            context,
                                            BirthdayLoginPage(
                                                data: {"display_name": name}));
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
            pushToNextScreen(context, const MainLoginPage(null));
          })
        ]),
      ),
    );
  }
}
