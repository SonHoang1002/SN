import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import 'complete_login_page.dart';

class PasswordLoginPage extends StatefulWidget {
  const PasswordLoginPage({super.key});

  @override
  State<PasswordLoginPage> createState() => _PasswordLoginPageState();
}

class _PasswordLoginPageState extends State<PasswordLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _iShowPassword = false;
  String _passwordController = '';

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
                                EmailLoginConstants.EMAIL_LOGIN_TITLE, true,
                                fontSize: 17, isCenterLeft: false),
                            buildSpacer(height: 15),

                            // input
                            _buildTextFormField((value) {
                              setState(() {
                                _passwordController = value;
                              });
                            },
                                EmailLoginConstants
                                    .EMAIL_LOGIN_NAME_PLACEHOLODER),

                            buildSpacer(height: 15),

                            // input
                            _buildTextFormField((value) {
                              setState(() {
                                _passwordController = value;
                              });
                            }, "Xác nhận mật khẩu"),
                            buildSpacer(height: 15),
                            // description
                            _passwordController.trim().isNotEmpty
                                ? SizedBox(
                                    height: 36,
                                    child: ButtonPrimary(
                                      label: "Tiếp tục",
                                      handlePress: () {
                                        pushAndReplaceToNextScreen(
                                            context, const CompleteLoginPage());
                                      },
                                    ),
                                  )
                                : Text(
                                    EmailLoginConstants.EMAIL_LOGIN_SUBTITLE,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: greyColor,
                                    ),
                                  ),
                            buildSpacer(height: 15),
                            // change status button
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildTextFormField(Function handleUpdate, String placeHolder,
      {double? borderRadius = 5, bool? numberType = false}) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        onChanged: ((value) {
          handleUpdate(value);
        }),
        validator: (value) {},
        obscureText: _iShowPassword,
        keyboardType: numberType! ? TextInputType.number : TextInputType.text,
        maxLength: numberType ? 10 : 100000,
        decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
              borderSide: const BorderSide(color: Colors.black, width: 0.4),
            ),
            hintText: placeHolder,
            hintStyle: const TextStyle(
              color: greyColor,
            ),
            suffix: Container(
              margin: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _iShowPassword = !_iShowPassword;
                  });
                },
                child: Icon(
                  !_iShowPassword
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  color: greyColor,
                  size: 15,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      ),
    );
  }
}
