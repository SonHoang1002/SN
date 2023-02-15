import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'authenticate_two_factors_modules/main_authenticate_two_factors_page.dart';
import 'how_to_protect_your_account_commons.dart';

class PasswordPage extends StatefulWidget {
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  late double width = 0;

  late double height = 0;

  late TextEditingController currentPasswordController =
      TextEditingController(text: "");

  late TextEditingController newPasswordController =
      TextEditingController(text: "");

  late TextEditingController reEnterPasswordController =
      TextEditingController(text: "");

  bool isClickForChangePasswordButton = false;

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
          children: const [
            BackIconAppbar(),
            AppBarTitle(title: PasswordCommons.PASSWORD_APPAR_TITLE),
            SizedBox(),
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.grey[900],
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 5),
                children: [
                  // title
                  buildTextContent(PasswordCommons.PASSWORD_TITLE, true,
                      fontSize: 22),
                  SizedBox(
                    height: 5,
                  ),
                  //subTitle
                  buildTextContent(
                    PasswordCommons.PASSWORD_SUBTITLE, false,
                    fontSize: 15,
                    // colorWord: Colors.grey
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // change password  bien mat khi click vao nut nay
                  !isClickForChangePasswordButton
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isClickForChangePasswordButton = true;
                              });
                            },
                            child: Text(
                              PasswordCommons.PASSWORD_CHANGE_PASSWORD,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(width * 0.9, 40),
                                backgroundColor: Colors.blue),
                          ),
                        )
                      // change password component hien ra khi nut doi mat khau bien mat
                      : Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: GeneralComponent(
                                [
                                  buildTextContent(
                                    PasswordCommons.PASSWORD_CONTENTS["title"],
                                    true,
                                    fontSize: 20,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: PasswordCommons
                                              .PASSWORD_CONTENTS["subTitle"]
                                              .length,
                                          itemBuilder: ((context, index) {
                                            return GeneralComponent(
                                              [
                                                buildTextContent(
                                                    PasswordCommons
                                                            .PASSWORD_CONTENTS[
                                                        "subTitle"][index],
                                                    false,
                                                    fontSize: 15,
                                                    colorWord: Colors.grey),
                                              ],
                                              prefixWidget: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  height: 7,
                                                  width: 7,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  3.5)))),
                                              changeBackground:
                                                  Colors.transparent,
                                              padding: EdgeInsets.zero,
                                            );
                                          })))
                                ],
                                prefixWidget: Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: SvgPicture.asset(
                                    SettingConstants.PATH_ICON +
                                        "bell_icon.svg",
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                changeBackground: Colors.grey[800],
                              ),
                            ),
                            //inputs
                            _buildInput(
                                height,
                                currentPasswordController,
                                SettingConstants.MENU_ICON_DATA,
                                "Mật khẩu hiện tại"),
                            _buildInput(
                                height,
                                newPasswordController,
                                SettingConstants.MENU_ICON_DATA,
                                "Nhập mật khẩu mới"),
                            _buildInput(
                                height,
                                reEnterPasswordController,
                                SettingConstants.MENU_ICON_DATA,
                                "Nhập lại mật khẩu"),
                            //save change
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                PasswordCommons.PASSWORD_SAVE_CHANGE,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(width * 0.9, 40),
                                  backgroundColor: Colors.blue),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                  child: GestureDetector(
                                onTap: (() {
                                  print(
                                      PasswordCommons.PASSWORD_FORGOT_PASSWORD);
                                }),
                                child: buildTextContent(
                                    PasswordCommons.PASSWORD_FORGOT_PASSWORD,
                                    false,
                                    colorWord: Colors.blue[900],
                                    isCenterLeft: false),
                              )),
                            )
                          ],
                        )
                ],
              ),
            ),
          ),
          buildBottomNavigatorDotWidget(
              context, 3, 2, "Bỏ qua", MainAuthenticateTwoFactorsPage()),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}

_buildInput(double width, TextEditingController controller, IconData iconData,
    String hintText) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
    height: 50,
    width: width * 0.9,
    child: TextFormField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 15,
            ),
          )),
    ),
  );
}
