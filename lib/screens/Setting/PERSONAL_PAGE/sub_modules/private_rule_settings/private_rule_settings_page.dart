import 'package:flutter/material.dart';

import '../../../../../helper/push_to_new_screen.dart';
import '../../../../../theme/colors.dart';
import '../../../../../widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import '../../../../../widgets/GeneralWidget/general_component.dart';
import '../../../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../../../widgets/appbar_title.dart';
import '../../../../../widgets/back_icon_appbar.dart';
import '../../personal_page_constants.dart';
import 'private_rule_settings_constants.dart';
import 'check_important_settings/check_important_settings_page.dart';

class PrivateRulesSettingPage extends StatefulWidget {
  const PrivateRulesSettingPage({super.key});

  @override
  State<PrivateRulesSettingPage> createState() =>
      _PrivateRulesSettingPageState();
}

class _PrivateRulesSettingPageState extends State<PrivateRulesSettingPage> {
  late double width = 0;
  late double height = 0;

  final String _selectedBottomNavigator = "Trang chủ";

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
            AppBarTitle(title: PersonalPageConstants.PRIVATE_APPBAR_TITLE),
            SizedBox(),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Stack(
          children: [
            Column(children: [
              // main content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  // color: Colors.grey[900],
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: [
                      // PRIVATE_RULE_SHORTCUT
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(children: [
                          // title
                          buildTextContent(
                              PrivateRuleSettingsCommons
                                  .PRIVATE_RULE_SHORTCUT["title"],
                              true,
                              fontSize: 20),
                          // content
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                itemCount: PrivateRuleSettingsCommons
                                    .PRIVATE_RULE_SHORTCUT["data"].length,
                                itemBuilder: ((context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          switch (PrivateRuleSettingsCommons
                                                  .PRIVATE_RULE_SHORTCUT["data"]
                                              [index]["key"]) {
                                            case "check_out_a_few_important_settings":
                                              pushToNextScreen(context,
                                                  CheckImportantSettingsPage());
                                          }
                                        },
                                        child: GeneralComponent(
                                          [
                                            buildTextContent(
                                                PrivateRuleSettingsCommons
                                                        .PRIVATE_RULE_SHORTCUT[
                                                    "data"][index]["subTitle"],
                                                true,
                                                fontSize: 17),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            buildTextContent(
                                              PrivateRuleSettingsCommons
                                                      .PRIVATE_RULE_SHORTCUT[
                                                  "data"][index]["content"],
                                              false,
                                              fontSize: 15,
                                              // colorWord: Colors.grey
                                            ),
                                          ],
                                          suffixWidget: Container(
                                            child: Icon(
                                              PrivateRuleSettingsCommons
                                                      .PRIVATE_RULE_SHORTCUT[
                                                  "data"][index]["icon"],
                                              // color:  white,
                                              size: 19,
                                            ),
                                          ),
                                          changeBackground: transparent,
                                          padding:
                                              const EdgeInsets.symmetric(vertical: 5),
                                        ),
                                      ),
                                      const Divider(
                                        height: 10,
                                        color: white,
                                      )
                                    ],
                                  );
                                })),
                          ),
                        ]),
                      ),
                      // ACTIVITY_OF_YOU
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(children: [
                          // title
                          buildTextContent(
                            PrivateRuleSettingsCommons.ACTIVITY_OF_YOU["title"],
                            true,
                            fontSize: 20,
                          ),
                          // content
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                itemCount: PrivateRuleSettingsCommons
                                    .ACTIVITY_OF_YOU["data"].length,
                                itemBuilder: ((context, index) {
                                  return Column(
                                    children: [
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                            PrivateRuleSettingsCommons
                                                    .ACTIVITY_OF_YOU["data"]
                                                [index]["subTitle"],
                                            true,
                                            fontSize: 17,
                                          ),
                                          PrivateRuleSettingsCommons
                                                              .ACTIVITY_OF_YOU[
                                                          "data"][index]
                                                      ["content"] ==
                                                  ""
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    buildTextContent(
                                                      PrivateRuleSettingsCommons
                                                                  .ACTIVITY_OF_YOU[
                                                              "data"][index]
                                                          ["content"],
                                                      false,
                                                      fontSize: 15,
                                                      // colorWord: Colors.grey
                                                    )
                                                  ],
                                                ),
                                        ],
                                        suffixWidget: Container(
                                          child: Icon(
                                            PrivateRuleSettingsCommons
                                                    .ACTIVITY_OF_YOU["data"]
                                                [index]["icon"],
                                            // color:  white,
                                            size: 19,
                                          ),
                                        ),
                                        changeBackground: transparent,
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      const Divider(
                                        height: 10,
                                        color: white,
                                      )
                                    ],
                                  );
                                })),
                          ),
                        ]),
                      ),
                      // WAY_TO_FIND_AND_CONTACT_WITH_YOU
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(children: [
                          // title
                          buildTextContent(
                            PrivateRuleSettingsCommons
                                .WAY_TO_FIND_AND_CONTACT_WITH_YOU["title"],
                            true,
                            fontSize: 20,
                          ),
                          // content
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                itemCount: PrivateRuleSettingsCommons
                                    .WAY_TO_FIND_AND_CONTACT_WITH_YOU["data"]
                                    .length,
                                itemBuilder: ((context, index) {
                                  return Column(
                                    children: [
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                            PrivateRuleSettingsCommons
                                                    .WAY_TO_FIND_AND_CONTACT_WITH_YOU[
                                                "data"][index]["subTitle"],
                                            true,
                                            fontSize: 17,
                                          ),
                                          PrivateRuleSettingsCommons
                                                          .WAY_TO_FIND_AND_CONTACT_WITH_YOU[
                                                      "data"][index]["key"] ==
                                                  "who_can_see_your_friends_list"
                                              ? buildTextContent(
                                                  PrivateRuleSettingsCommons
                                                      .ADDTIONAL_FOR_WHO_CAN_SEE_FRIEND_LIST_OF_YOU,
                                                  false,
                                                  // colorWord:  white,
                                                  fontSize: 16)
                                              : const SizedBox(),
                                          PrivateRuleSettingsCommons
                                                          .WAY_TO_FIND_AND_CONTACT_WITH_YOU[
                                                      "data"][index]["content"] ==
                                                  ""
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    buildTextContent(
                                                      PrivateRuleSettingsCommons
                                                              .WAY_TO_FIND_AND_CONTACT_WITH_YOU[
                                                          "data"][index]["content"],
                                                      false,
                                                      fontSize: 15,
                                                      // colorWord: Colors.grey
                                                    )
                                                  ],
                                                ),
                                        ],
                                        suffixWidget: Container(
                                          child: Icon(
                                            PrivateRuleSettingsCommons
                                                    .WAY_TO_FIND_AND_CONTACT_WITH_YOU[
                                                "data"][index]["icon"],
                                            // color:  white,
                                            size: 19,
                                          ),
                                        ),
                                        changeBackground: transparent,
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                      ),
                                      const Divider(
                                        height: 10,
                                        color: white,
                                      )
                                    ],
                                  );
                                })),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 37,
                      )
                    ],
                  ),
                ),
              ),
            ]),
            // bottom navigator
            buildBottomNavigatorBarWidget(context)
          ],
        ),
      ),
    );
  }
}
