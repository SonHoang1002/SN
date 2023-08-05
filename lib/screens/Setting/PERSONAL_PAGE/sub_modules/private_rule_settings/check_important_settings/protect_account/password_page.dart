import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../theme/colors.dart';
import '../../../../../../../widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import '../../../../../../../widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import '../../../../../../../widgets/GeneralWidget/general_component.dart';
import '../../../../../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../../../../../widgets/appbar_title.dart';
import '../../../../../../../widgets/back_icon_appbar.dart';
import '../../../../../setting_constants/general_settings_constants.dart';
import 'authenticate_two_factors_modules/authenticate_two_factors.dart';
import 'protect_your_account_constants.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

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
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(title: PasswordConstants.PASSWORD_APPAR_TITLE),
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
                padding: const EdgeInsets.symmetric(vertical: 5),
                children: [
                  // title
                  buildTextContent(PasswordConstants.PASSWORD_TITLE, true,
                      fontSize: 22),
                  const SizedBox(
                    height: 5,
                  ),
                  //subTitle
                  buildTextContent(
                    PasswordConstants.PASSWORD_SUBTITLE, false,
                    fontSize: 15,
                    // colorWord: Colors.grey
                  ),
                  const SizedBox(
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
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(width * 0.9, 40),
                                backgroundColor: Colors.blue),
                            child: const Text(
                              PasswordConstants.PASSWORD_CHANGE_PASSWORD,
                              style: TextStyle(color: white, fontSize: 17),
                            ),
                          ),
                        )
                      // change password component hien ra khi nut doi mat khau bien mat
                      : Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: GeneralComponent(
                                [
                                  buildTextContent(
                                    PasswordConstants
                                        .PASSWORD_CONTENTS["title"],
                                    true,
                                    fontSize: 20,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: PasswordConstants
                                              .PASSWORD_CONTENTS["subTitle"]
                                              .length,
                                          itemBuilder: ((context, index) {
                                            return GeneralComponent(
                                              [
                                                buildTextContent(
                                                    PasswordConstants
                                                            .PASSWORD_CONTENTS[
                                                        "subTitle"][index],
                                                    false,
                                                    fontSize: 15,
                                                    colorWord: Colors.grey),
                                              ],
                                              prefixWidget: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  height: 7,
                                                  width: 7,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  3.5)))),
                                              changeBackground: transparent,
                                              padding: EdgeInsets.zero,
                                            );
                                          })))
                                ],
                                prefixWidget: Container(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: SvgPicture.asset(
                                    "${SettingConstants.PATH_ICON}bell_icon.svg",
                                    height: 20,
                                    // color:  white,
                                  ),
                                ),
                                changeBackground: Colors.grey[300],
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
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(width * 0.9, 40),
                                  backgroundColor: Colors.blue),
                              child: const Text(
                                PasswordConstants.PASSWORD_SAVE_CHANGE,
                                style: TextStyle(color: white, fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                  child: GestureDetector(
                                onTap: (() {}),
                                child: buildTextContent(
                                    PasswordConstants.PASSWORD_FORGOT_PASSWORD,
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
    margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
    height: 50,
    width: width * 0.9,
    child: TextFormField(
      // style: TextStyle(color:  white),
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              iconData,
              // color:  white,
              size: 15,
            ),
          )),
    ),
  );
}
