import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import 'complete_login_page.dart';

class PasswordLoginPage extends StatefulWidget {
  final dynamic data;
  const PasswordLoginPage({super.key, this.data});

  @override
  State<PasswordLoginPage> createState() => _PasswordLoginPageState();
}

class _PasswordLoginPageState extends State<PasswordLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _iShowPassword = true;
  TextEditingController _passwordController = TextEditingController(text: "");
  TextEditingController _passwordConfirmController =
      TextEditingController(text: "");

  RegExp numbersRegex = RegExp(r'\d');
  RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
                            _buildTextFormField(
                                _passwordController,
                                EmailLoginConstants
                                    .EMAIL_LOGIN_NAME_PLACEHOLODER,
                                handleUpdate: (value) {
                              setState(() {});
                            }),
                            !checkPassValidate()
                                ? const Text(
                                    "Mật khẩu phải lớn hơn 9 kí tự, bao gồm số, chữ thường và ký tự đặc biệt :,.?...",
                                    style: TextStyle(
                                      height: 2,
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  )
                                : const SizedBox(),
                            buildSpacer(height: 15),
                            // input
                            _buildTextFormField(
                                _passwordConfirmController, "Xác nhận mật khẩu",
                                handleUpdate: (value) {
                              setState(() {});
                            }),
                            _passwordConfirmController.text.trim() !=
                                        _passwordController.text.trim() &&
                                    _passwordConfirmController.text
                                        .trim()
                                        .isNotEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Mật khẩu không trùng khớp",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  )
                                : const SizedBox(),

                            buildSpacer(height: 15),
                            // description
                            checkValidate()
                                ? SizedBox(
                                    height: 40,
                                    child: ButtonPrimary(
                                      label: "Tiếp tục",
                                      handlePress: () {
                                        pushAndReplaceToNextScreen(
                                            context,
                                            CompleteLoginPage(data: {
                                              ...widget.data,
                                              "password": _passwordController
                                                  .text
                                                  .trim(),
                                              "password_confirmation":
                                                  _passwordConfirmController
                                                      .text
                                                      .trim(),
                                            }));
                                      },
                                    ),
                                  )
                                : const SizedBox(),
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

  bool checkPassValidate() {
    final pass = _passwordController.text.trim();
    final status = pass.length >= 9 &&
        specialCharRegex.hasMatch(pass) &&
        numbersRegex.hasMatch(pass);
    return status;
  }

  bool checkPassConfirmValidate() {
    final passConfirm = _passwordConfirmController.text.trim();
    final pass = _passwordController.text.trim();
    final status = passConfirm.length >= 9 && passConfirm == pass;
    return status;
  }

  bool checkValidate() {
    final status = checkPassConfirmValidate() && checkPassValidate();
    return status;
  }

  Widget _buildTextFormField(
      TextEditingController controller, String placeHolder,
      {Function? handleUpdate,
      double? borderRadius = 5,
      bool? numberType = false}) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        onChanged: ((value) {
          handleUpdate != null ? handleUpdate(value) : null;
        }),
        controller: controller,
        validator: (value) {},
        obscureText: _iShowPassword,
        keyboardType: numberType! ? TextInputType.number : TextInputType.text,
        maxLength: numberType ? 10 : 100,
        decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.9), width: 0.4),
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
