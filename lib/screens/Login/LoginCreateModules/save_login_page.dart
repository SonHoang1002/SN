import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';

import '../../../constant/login_constants.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../widgets/button_primary.dart';
import 'add_avatar_login_page.dart';

class SaveLoginPage extends StatelessWidget {
  const SaveLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Column(
                      children: [
                        buildTextContent(SaveLogin.SAVE_LOGIN_TITLE, true,
                            fontSize: 25,
                            colorWord:
                                Theme.of(context).textTheme.bodyLarge?.color,
                            isCenterLeft: false),
                        buildTextContent(
                            "Sau khi được xác minh tài khoản qua email hoặc số điện thoại",
                            true,
                            fontSize: 25,
                            colorWord:
                                Theme.of(context).textTheme.bodyLarge?.color,
                            isCenterLeft: false),
                        buildSpacer(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: buildTextContent(
                            SaveLogin.SAVE_LOGIN_SUB,
                            false,
                            fontSize: 16,
                            colorWord: Colors.grey,
                            isCenterLeft: false,
                          ),
                        ),
                        buildSpacer(height: 30),
                        // button
                        SizedBox(
                          height: 40,
                          child: ButtonPrimary(
                            fontSize: 18,
                            label: "Lưu",
                            handlePress: () {
                              pushToNextScreen(
                                  context, const AddAvatarLoginPage());
                            },
                          ),
                        ),
                        buildSpacer(height: 20),
                        ButtonPrimary(
                          colorBorder: Colors.grey,
                          colorButton: Colors.white,
                          fontSize: 18,
                          label: "Lúc khác",
                          colorText: Colors.grey[700],
                          handlePress: () {
                            pushToNextScreen(
                                context, const AddAvatarLoginPage());
                          },
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
    );
  }
}
