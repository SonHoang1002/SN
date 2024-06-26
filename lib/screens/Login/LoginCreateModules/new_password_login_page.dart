import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../home/home.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../widgets/appbar_title.dart';
import '../../../widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/screens/Login/widgets/build_elevate_button_widget.dart';

class NewPasswordLoginPage extends StatefulWidget {
  const NewPasswordLoginPage({super.key});

  @override
  State<NewPasswordLoginPage> createState() => _NewPasswordLoginPageState();
}

class _NewPasswordLoginPageState extends State<NewPasswordLoginPage> {
  late double width = 0;

  late double height = 0;
  bool isValid = true;
  final TextEditingController _newPasswordController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
              child: const Row(
                children: [
                  BackIconAppbar(),
                  SizedBox(
                    width: 5,
                  ),
                  AppBarTitle(title: "Quay lại"),
                ],
              ),
            ),
            AppBarTitle(
                title:
                    NewPasswordLoginConstants.NEW_PASWORD_LOGIN_APPBAR_TITLE),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const AppBarTitle(title: "Hủy"),
            ),
          ],
        ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
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
                              buildTextContent(
                                  NewPasswordLoginConstants
                                      .NEW_PASWORD_LOGIN_TITLE,
                                  true,
                                  fontSize: 16,
                                  colorWord: Colors.orange,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),
                              _buildTextFormField(
                                  _newPasswordController,
                                  NewPasswordLoginConstants
                                      .NEW_PASWORD_LOGIN_PLACEHOLDER),
                              buildSpacer(height: 10),
                              Text(
                                NewPasswordLoginConstants
                                    .NEW_PASWORD_LOGIN_DESCRIPTION,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.purple,
                                ),
                              ),
                              buildButtonForLoginWidget(
                                  width: width,
                                  function: () {
                                    pushAndRemoveUntil(context, const Home());
                                  })
                            ],
                          ),
                        ),
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

  Widget _buildTextFormField(
    TextEditingController controller,
    String placeHolder,
  ) {
    return SizedBox(
      height: 50,
      child: TextFormField(
          textAlign: TextAlign.center,
          controller: controller,
          onChanged: ((value) {}),
          validator: (value) {
            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
            counterText: "",
            hintText: placeHolder,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          )),
    );
  }
}
