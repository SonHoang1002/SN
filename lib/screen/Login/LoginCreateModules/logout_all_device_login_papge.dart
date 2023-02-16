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
import 'new_password_login_page.dart';

class LogoutAllDeviceLoginPage extends StatefulWidget {
  @override
  State<LogoutAllDeviceLoginPage> createState() =>
      _LogoutAllDeviceLoginPageState();
}

class _LogoutAllDeviceLoginPageState extends State<LogoutAllDeviceLoginPage> {
  late double width = 0;

  late double height = 0;
  final _selectionList = [
    "Duy trì đăng nhập",
    "Đăng xuất tôi khỏi thiết bị khác"
  ];
  String _selectionValue = "Duy trì đăng nhập";

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
                children: const [
                  BackIconAppbar(),
                  SizedBox(
                    width: 5,
                  ),
                  AppBarTitle(title: "Quay lại"),
                ],
              ),
            ),
            AppBarTitle(
                title: LogoutAllDeviceLoginConstants
                    .LOGOUT_ALL_DEVICE_LOGIN_APPBAR_TITLE),
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
                                  LogoutAllDeviceLoginConstants
                                      .LOGOUT_ALL_DEVICE_LOGIN_TITLE,
                                  true,
                                  fontSize: 16,
                                  colorWord: Colors.orange,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),
                              Column(
                                children: [
                                  buildDivider(color: Colors.black),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: LogoutAllDeviceLoginConstants
                                        .LOGOUT_ALL_DEVICE_LOGIN_SELECTIONS[
                                            "data"]
                                        .length,
                                    itemBuilder: (context, index) {
                                      final data = LogoutAllDeviceLoginConstants
                                              .LOGOUT_ALL_DEVICE_LOGIN_SELECTIONS[
                                          "data"];
                                      return Column(
                                        children: [
                                          GeneralComponent(
                                            [
                                              buildTextContent(
                                                  data[index]["title"], true,
                                                  fontSize: 16,
                                                  colorWord: Colors.orange),
                                              data[index]["subTitle"] != null
                                                  ? buildTextContent(
                                                      data[index]["subTitle"],
                                                      true,
                                                      fontSize: 14,
                                                      colorWord: Colors.purple)
                                                  : const SizedBox()
                                            ],
                                            suffixWidget: Container(
                                                height: 40,
                                                width: 40,
                                                padding: const EdgeInsets.all(5),
                                                child: Radio(
                                                  onChanged: (value) {
                                                    _selectionValue =
                                                        _selectionList[index];
                                                    setState(() {});
                                                  },
                                                  value: _selectionList[index],
                                                  groupValue: _selectionValue,
                                                )),
                                            changeBackground: transparent,
                                            padding: const EdgeInsets.all(5),
                                          ),
                                          const Divider(
                                            height: 10,
                                            color: Colors.black,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              buildButtonForLoginWidget(
                                  width: width,
                                  function: () {
                                    pushToNextScreen(
                                        context, NewPasswordLoginPage());
                                  }),
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
