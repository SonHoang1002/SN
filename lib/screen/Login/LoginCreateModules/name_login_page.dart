import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/build_elevateButton_widget.dart';
import '../widgets/have_account_widget.dart';
import 'birthday_login_page.dart';
import 'main_login_page.dart';

class NameLoginPage extends StatefulWidget {
  @override
  State<NameLoginPage> createState() => _NameLoginPageState();
}

class _NameLoginPageState extends State<NameLoginPage> {
  late double width = 0;
  late double height = 0;
  TextEditingController _firstNameController =
      TextEditingController(text: "df");
  TextEditingController _lastNameController =
      TextEditingController(text: "tutuy");
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
                                  NameLoginConstants.NAME_LOGIN_TITLE, true,
                                  fontSize: 16,
                                  colorWord: blackColor,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width * 0.45,
                                    child: _buildTextFormField(
                                        _firstNameController,
                                        NameLoginConstants
                                            .NAME_LOGIN_NAME_PLACEHOLODER[0],
                                        borderRadius: 3),
                                  ),
                                  Container(
                                    width: width * 0.45,
                                    child: _buildTextFormField(
                                        _lastNameController,
                                        NameLoginConstants
                                            .NAME_LOGIN_NAME_PLACEHOLODER[1],
                                        borderRadius: 3),
                                  ),
                                ],
                              ),
                              buildSpacer(height: 10),
                              isFillAll
                                  ? buildElevateButtonWidget(
                                      title: "Tiếp",
                                      width: width,
                                      function: () {
                                        pushToNextScreen(
                                            context, BirthdayLoginPage());
                                      })
                                  : buildTextContent(
                                      NameLoginConstants.NAME_LOGIN_SUBTITLE,
                                      true,
                                      fontSize: 16,
                                      colorWord: Colors.grey,
                                      isCenterLeft: false,
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
          ),
          buildHaveAccountWidget(function: () {
            pushToNextScreen(context, MainLoginPage());
          })
        ]),
      ),
    );
  }

  checkFillAllInput() {
    if (_firstNameController.text.trim().length > 0 &&
        _lastNameController.text.trim().length > 0) {
      setState(() {
        isFillAll = true;
      });
    } else {
      setState(() {
        isFillAll = false;
      });
    }
  }

  Widget _buildTextFormField(
      TextEditingController controller, String placeHolder,
      {double? borderRadius = 5}) {
    return Container(
      height: 50,
      child: TextFormField(
        controller: controller,
        onChanged: ((value) {
          checkFillAllInput();
        }),
        validator: (value) {},
        decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
            hintText: placeHolder,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            // suffix: Container(
            //   padding: EdgeInsets.only(
            //     top: 25.0,
            //   ),
            //   child: Icon(
            //     Icons.close,
            //     color: Colors.grey,
            //   ),
            // ),
            contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 30),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      ),
    );
  }
}
