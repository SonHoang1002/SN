import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/information_component_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../widgets/appbar_title.dart';
import 'main_login_page.dart';

class SettingLoginPage extends StatefulWidget {
  const SettingLoginPage({super.key});

  @override
  State<SettingLoginPage> createState() => _SettingLoginPageState();
}

class _SettingLoginPageState extends State<SettingLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _isCheck = false;
  bool _deleteAccount = false;

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
              child: const AppBarTitle(title: "Đóng"),
            ),
            const AppBarTitle(title: "Cài đặt đăng nhập"),
            const SizedBox(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
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
                children: [
                  Container(
                    height: 300,
                    // color: Colors.grey[800],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            // borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Image.asset(
                              LoginConstants.PATH_IMG + "avatar_img.png"),
                        ),
                        buildTextContent(
                            OnboardingLoginConstants.ONBOARDING_LOGIN_USERNAME,
                            true,
                            fontSize: 16,
                            colorWord: Colors.black,
                            isCenterLeft: false)
                      ],
                    ),
                  ),
                  Container(
                      height: 50,
                      color: Colors.grey[700],
                      // color: Colors.purpleAccent[200],
                      child: GeneralComponent(
                        [
                          buildTextContent("Nhận thông báo", false,
                              fontSize: 16, colorWord: white)
                        ],
                        suffixWidget: CupertinoSwitch(
                          onChanged: (value) {
                            setState(() {
                              _isCheck = !_isCheck;
                            });
                          },
                          value: _isCheck,
                        ),
                        changeBackground: transparent,
                        padding: const EdgeInsets.all(5),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  !_deleteAccount
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: SettingLoginConstants
                              .GETTING_LOGIN_SELECTIONS["data"].length,
                          itemBuilder: (context, index) {
                            final data = SettingLoginConstants
                                .GETTING_LOGIN_SELECTIONS["data"];
                            return Container(
                                // height: 50,
                                color: Colors.grey[700],
                                child: GeneralComponent(
                                  [
                                    buildTextContent(
                                        data[index]["title"], false,
                                        fontSize: 16, colorWord: Colors.red),
                                    buildTextContent(
                                        data[index]["subTitle"], false,
                                        fontSize: 13, colorWord: white)
                                  ],
                                  changeBackground: transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  function: () {
                                    setState(() {
                                      _deleteAccount = true;
                                    });
                                  },
                                ));
                          },
                        )
                      : Container(
                          color: Colors.grey[700],
                          child: GeneralComponent(
                            [
                              buildTextContent(
                                  SettingLoginConstants
                                      .GETTING_LOGIN_DELETE_ACCOUNT,
                                  false,
                                  fontSize: 16,
                                  colorWord: Colors.red),
                            ],
                            changeBackground: transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            function: () {
                              pushToNextScreen(context, MainLoginPage(null));
                            },
                          ),
                        )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
