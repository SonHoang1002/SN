import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/build_elevateButton_widget.dart';
import 'complete_login_page.dart';

class PasswordLoginPage extends StatefulWidget {
  @override
  State<PasswordLoginPage> createState() => _PasswordLoginPageState();
}

class _PasswordLoginPageState extends State<PasswordLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _iShowPassword = false;
  TextEditingController _passwordController = TextEditingController(text: "");

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
                                  fontSize: 16,
                                  colorWord: blackColor,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),

                              // input
                              _buildTextFormField(
                                  _passwordController,
                                  EmailLoginConstants
                                      .EMAIL_LOGIN_NAME_PLACEHOLODER),
                              buildSpacer(height: 10),
                              // description
                              _passwordController.text.trim().length > 0
                                  ? buildElevateButtonWidget(
                                      width: width,
                                      function: () {
                                        pushToNextScreen(
                                            context, CompleteLoginPage());
                                      })
                                  : Text(
                                      EmailLoginConstants.EMAIL_LOGIN_SUBTITLE,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: greyColor,
                                      ),
                                    ),
                              buildSpacer(height: 10),
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
          ),
        ]),
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String placeHolder,
      {double? borderRadius = 5,
      bool? isHavePrefix = false,
      bool? numberType = false}) {
    return Container(
      height: 40,
      child: TextFormField(
        controller: controller,
        onChanged: ((value) {}),
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
              margin: EdgeInsets.only(right: 10),
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
