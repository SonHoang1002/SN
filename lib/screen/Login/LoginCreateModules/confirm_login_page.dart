import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
import '../widgets/build_elevateButton_widget.dart';
import 'logout_all_device_login_papge.dart';
import 'main_login_page.dart';

class ConfirmLoginPage extends StatefulWidget {
  const ConfirmLoginPage({super.key});

  @override
  State<ConfirmLoginPage> createState() => _ConfirmLoginPageState();
}

class _ConfirmLoginPageState extends State<ConfirmLoginPage> {
  late double width = 0;
  late double height = 0;
  final _selectionList = ["sms", "email"];
  String _selectionValue = "sms";
  bool _isOnEnterCodePart = false;

  TextEditingController _codeController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    handleSeedDataEmail() async {
      setState(() {
        isLoad = true;
      });
      dynamic response;
      var data = {"email": email};
      if (isNext) {
        response = await AuthenApi().forgotPassword(data);
      } else {
        response = await AuthenApi().reconfirmationEmail(data);
      }
      setState(() {
        isLoad = false;
      });
      if (response != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đã gửi mail xác nhận tới $email")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: primaryColor,
            content: Text("Không thể gửi mail xác nhận tới $email")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(
                title: ConfirmLoginConstants.CONFIRM_LOGIN_APPBAR_TITLE),
            Container()
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
                        const SizedBox(
                          height: 15,
                        ),
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
                                          changeBackground: Colors.transparent,
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
                                                  changeBackground:
                                                      Colors.transparent,
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
                                  ? buildElevateButtonWidget(
                                      width: width,
                                      function: () {
                                        setState(() {
                                          isNext = true;
                                        });
                                      })
                                  : buildElevateButtonWidget(
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
                                        buildElevateButtonWidget(
                                            width: width,
                                            bgColor: Colors.transparent,
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
