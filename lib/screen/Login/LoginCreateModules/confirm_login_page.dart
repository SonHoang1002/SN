import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/divider_widget.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import 'logout_all_device_login_papge.dart';
import 'main_login_page.dart';

class ConfirmLoginPage extends StatefulWidget {
  @override
  State<ConfirmLoginPage> createState() => _ConfirmLoginPageState();
}

class _ConfirmLoginPageState extends State<ConfirmLoginPage> {
  late double width = 0;

  late double height = 0;
  final _selectionList = ["sms", "email"];
  String _selectionValue = "sms";
  bool _isOnEnterCodePart = false;

  final TextEditingController _codeController = TextEditingController(text: "");

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
              child: Row(
                children: [
                  BackIconAppbar(),
                  SizedBox(
                    width: 5,
                  ),
                  const AppBarTitle(title: "Quay lại"),
                ],
              ),
            ),
            AppBarTitle(
                title: ConfirmLoginConstants.CONFIRM_LOGIN_APPBAR_TITLE),
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
              padding: EdgeInsets.symmetric(
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
                                  !_isOnEnterCodePart
                                      ? ConfirmLoginConstants
                                          .CONFIRM_LOGIN_TITLE[0]
                                      : ConfirmLoginConstants
                                          .CONFIRM_LOGIN_TITLE[1],
                                  true,
                                  fontSize: 16,
                                  colorWord: Colors.orange,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),
                              //
                              !_isOnEnterCodePart
                                  ? Column(
                                      children: [
                                        GeneralComponent(
                                          [
                                            buildTextContent(
                                                ConfirmLoginConstants
                                                        .CONFIRM_LOGIN_USER[
                                                    "title"],
                                                true,
                                                fontSize: 16,
                                                colorWord: Colors.orange),
                                            buildTextContent(
                                                ConfirmLoginConstants
                                                        .CONFIRM_LOGIN_USER[
                                                    "subTitle"],
                                                true,
                                                fontSize: 14,
                                                colorWord: Colors.purple),
                                          ],
                                          prefixWidget: Container(
                                            height: 60,
                                            width: 60,
                                            padding: EdgeInsets.all(5),
                                            child: Image.asset(
                                              ConfirmLoginConstants
                                                  .CONFIRM_LOGIN_USER["icon"],
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          changeBackground: transparent,
                                        ),
                                        buildDivider(color: Colors.black),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: ConfirmLoginConstants
                                              .CONFIRM_LOGIN_SELECTIONS["data"]
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                GeneralComponent(
                                                  [
                                                    buildTextContent(
                                                        ConfirmLoginConstants
                                                                    .CONFIRM_LOGIN_SELECTIONS[
                                                                "data"][index]
                                                            ["title"],
                                                        true,
                                                        fontSize: 16,
                                                        colorWord:
                                                            Colors.orange),
                                                    buildTextContent(
                                                        ConfirmLoginConstants
                                                                    .CONFIRM_LOGIN_SELECTIONS[
                                                                "data"][index]
                                                            ["content"],
                                                        true,
                                                        fontSize: 14,
                                                        colorWord:
                                                            Colors.purple),
                                                  ],
                                                  suffixWidget: Container(
                                                      height: 60,
                                                      width: 60,
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Radio(
                                                        onChanged: (value) {
                                                          _selectionValue =
                                                              _selectionList[
                                                                  index];
                                                          setState(() {});
                                                        },
                                                        value: _selectionList[
                                                            index],
                                                        groupValue:
                                                            _selectionValue,
                                                      )),
                                                  changeBackground: transparent,
                                                  padding: EdgeInsets.all(5),
                                                ),
                                                Divider(
                                                  height: 10,
                                                  color: Colors.black,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : _buildTextFormField(
                                      _codeController, "Nhập mã"),
                              // tiep tuc button
                              !_isOnEnterCodePart
                                  ? buildButtonForLoginWidget(
                                      width: width,
                                      function: () {
                                        setState(() {
                                          _isOnEnterCodePart = true;
                                        });
                                      })
                                  : buildButtonForLoginWidget(
                                      width: width,
                                      function: () {
                                        pushToNextScreen(context,
                                            LogoutAllDeviceLoginPage());
                                      }),
                              // nhap mat khau de tiep tuc vaf ko truy cap duoc nua
                              !_isOnEnterCodePart
                                  ? Column(
                                      children: [
                                        buildSpacer(height: 10),
                                        buildButtonForLoginWidget(
                                            width: width,
                                            bgColor: transparent,
                                            title: ConfirmLoginConstants
                                                .CONFIRM_LOGIN_ENTER_PASSWORD_TO_LOGIN,
                                            colorText: Colors.orange,
                                            function: () {
                                              pushToNextScreen(
                                                  context, MainLoginPage());
                                            },
                                            isHaveBoder: true),
                                        // not access
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: buildTextContent(
                                              ConfirmLoginConstants
                                                  .CONFIRM_LOGIN_NOT_ACCESS,
                                              false,
                                              fontSize: 15,
                                              colorWord: Colors.purple,
                                              isCenterLeft: false,
                                              function: () {}),
                                        ),
                                      ],
                                    )
                                  : SizedBox()
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
}

Widget _buildTextFormField(
  TextEditingController controller,
  String placeHolder, {
  double? borderRadius = 5,
}) {
  return Container(
    height: 40,
    child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        onChanged: ((value) {}),
        validator: (value) {},
        keyboardType: TextInputType.number,
        maxLength: 6,
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
