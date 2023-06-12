import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/protect_account/protect_your_account_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class BeginAuthenticateTwoFactorsPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // pop icon and search setting input
          Container(
            margin: EdgeInsets.only(top: 60, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        SettingConstants.BACK_ICON_DATA,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  buildTextContent(
                      AuthenticateTwoFactorsConstants
                          .AUTHENTICATE_TWO_FACTOR_APPAR_TITLE,
                      true),
                  Container(),
                ]),
          ),
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.grey[900],
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 5),
                children: [
                  Column(children: [
                    // img
                    Container(
                      height: 100,
                      width: 250,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Image.asset(
                        SettingConstants.PATH_IMG + "cat_1.png",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: buildTextContent(
                          AuthenticateTwoFactorsConstants
                              .AUTHENTICATE_TWO_FACTOR_PROTECT_ACCOUNT_TITLE,
                          true,
                          fontSize: 24),
                    ),
                    buildTextContent(
                        AuthenticateTwoFactorsConstants
                            .AUTHENTICATE_TWO_FACTOR_PROTECT_ACCOUNT_SUBTITLE,
                        false,
                        fontSize: 18,
                        colorWord: Colors.grey),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: buildTextContent(
                          AuthenticateTwoFactorsConstants
                              .AUTHENTICATE_TWO_FACTOR_CHOOSE_A_SECURITY_METHOD_TITLE,
                          true,
                          fontSize: 24),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: AuthenticateTwoFactorsConstants
                            .AUTHENTICATE_TWO_FACTOR_CHOOSE_A_SECURITY_METHOD_CONTENTS[
                                "data"]
                            .length,
                        itemBuilder: ((context, index) {
                          final data = AuthenticateTwoFactorsConstants
                                  .AUTHENTICATE_TWO_FACTOR_CHOOSE_A_SECURITY_METHOD_CONTENTS[
                              "data"];
                          return Column(
                            children: [
                              GeneralComponent(
                                [
                                  buildTextContent(data[index]["title"], true),
                                  buildTextContent(
                                      data[index]["subTitle"], false,
                                      colorWord: Colors.grey),
                                ],
                                suffixWidget: Container(
                                    // padding: EdgeInsets.only(right: 15),
                                    child: Radio(
                                  groupValue: true,
                                  value: true,
                                  onChanged: ((value) {}),
                                )),
                                padding: EdgeInsets.fromLTRB(0, 10, 5, 5),
                              ),
                              Divider(
                                height: 10,
                                color: Colors.white,
                              )
                            ],
                          );
                        })),
                  ])
                ],
              ),
            ),
          ),
          Container(
            height: 70,
            color: Colors.transparent,
            child: Column(children: [
              Divider(
                height: 10,
                color: Colors.white,
              ),
              Expanded(
                  child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(width * 0.9, 40)),
                  child: Text("Tiep tuc"),
                  onPressed: (() {}),
                ),
              ))
            ]),
          ),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }

  Widget _buildContent(String path, String title, String subTitle) {
    return Column(
      children: [
        // img
        Container(
          height: 100,
          width: 250,
          margin: EdgeInsets.only(bottom: 15),
          child: Image.asset(path),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: buildTextContent(title, true, fontSize: 24),
        ),
        buildTextContent(subTitle, false, fontSize: 18, colorWord: Colors.grey),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: buildTextContent(title, true, fontSize: 24),
        ),
        buildTextContent(subTitle, false, fontSize: 18, colorWord: Colors.grey),
        // ListView.builder(
        //     padding: EdgeInsets.zero,
        //     shrinkWrap: true,
        //     itemCount: contents["data"].length,
        //     itemBuilder: ((context, index) {
        //       return GeneralComponent(
        //         [
        //           buildTextContent(contents["data"][index]["content"], false,
        //               colorWord: Colors.grey)
        //         ],
        //         prefixWidget: Container(
        //           padding: EdgeInsets.only(right: 15),
        //           child: SvgPicture.asset(
        //             contents["data"][index]["icon"],
        //             height: 20,
        //             color: Colors.white,
        //           ),
        //         ),
        //         padding: EdgeInsets.fromLTRB(0, 10, 5, 5),
        //       );
        //     })),
      ],
    );
  }
}
