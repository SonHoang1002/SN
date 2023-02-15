import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/all_completed_page.dart';
import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import 'facebook_advertising_options_commons.dart';

class InteractOnSocialNetworksPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;
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
            AppBarTitle(
                title: InteractOnSocialNetworksCommons
                    .INFORMATION_ON_FACEBOOK_APPBAR_TITLE),
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
                  buildTextContent(
                    InteractOnSocialNetworksCommons
                        .INTERACT_ON_SOCIAL_NETWORK_INTERACT_ON_SOCIAL_NETWORK,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  buildSpacer(height: 10),
                  buildTextContent(
                    InteractOnSocialNetworksCommons
                        .INTERACT_ON_SOCIAL_NETWORK_EXAMPLE_IF_SOCIAL_NETWORK_YOU_LIKE,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  buildSpacer(height: 10),
                  Container(
                    // height: 500,
                    width: width * 0.8,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: buildTextContent("Bạn đã thích một Trang", false,
                            fontSize: 14, colorWord: Colors.grey[800]),
                      ),
                      buildDivider(bottom: 5, top: 5),
                      GeneralComponent(
                        [
                          buildTextContent(
                            InteractOnSocialNetworksCommons
                                    .INTERACT_ON_SOCIAL_NETWORK_PAGE_CONTENTS[
                                "data"]["title"],
                            true,
                            fontSize: 15,
                            // colorWord: Colors.grey[200]
                          ),
                          buildSpacer(height: 5),
                          buildTextContent(
                            InteractOnSocialNetworksCommons
                                    .INTERACT_ON_SOCIAL_NETWORK_PAGE_CONTENTS[
                                "data"]["subTitle"],
                            false,
                            fontSize: 15,
                            // colorWord: Colors.grey[200]
                          )
                        ],
                        prefixWidget: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                InteractOnSocialNetworksCommons
                                        .INTERACT_ON_SOCIAL_NETWORK_PAGE_CONTENTS[
                                    "data"]["img"],
                              ),
                            )),
                            // prefixWidget: Container(
                            // // height: 40,
                            // // width: 40,
                            // // margin: EdgeInsets.only(right: 10),
                            // child: ClipRRect(
                            //   borderRadius: BorderRadius.circular(10),
                            //   child: AvatarSocial(
                            //     height:20,width:20,path:
                            //     InteractOnSocialNetworksCommons
                            //             .INTERACT_ON_SOCIAL_NETWORK_PAGE_CONTENTS[
                            //         "data"]["img"],
                            //   ),
                            // )),
                        suffixWidget: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            SettingConstants.PATH_ICON + "bell_icon.svg",
                            // InteractOnSocialNetworksCommons
                            //         .INTERACT_ON_SOCIAL_NETWORK_PAGE_CONTENTS[
                            //     "data"]["icon"],
                            // color: Colors.white,
                          ),
                        ),
                        changeBackground: Colors.grey[300],
                        borderRadiusValue: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 200,
                        color: Colors.red,
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GeneralComponent(
                      [
                        Padding(
                          padding: const EdgeInsets.only(right:10.0),
                          child: buildTextContent(
                              InteractOnSocialNetworksCommons
                                      .INTERACT_ON_SOCIAL_NETWORK_CONTENTS["data"]
                                  ["title"],
                              false),
                        )
                      ],
                      changeBackground: Colors.transparent,
                      prefixWidget: Card(),
                      suffixFlexValue: 20,
                      suffixWidget: Container(
                        child: GeneralComponent(
                          [
                            buildTextContent(
                                InteractOnSocialNetworksCommons
                                        .INTERACT_ON_SOCIAL_NETWORK_CONTENTS[
                                    "data"]["content"],
                                true,
                                fontSize: 15)
                          ],
                          prefixWidget: Container(
                            height: 30,
                            width: 30,
                            margin: EdgeInsets.only(right: 10),
                            child: SvgPicture.asset(
                              InteractOnSocialNetworksCommons
                                      .INTERACT_ON_SOCIAL_NETWORK_CONTENTS[
                                  "data"]["icon"],
                            ),
                          ),
                          suffixWidget: Container(
                            height: 30,
                            width: 30,

                            margin: EdgeInsets.all(5),

                            child: SvgPicture.asset(
                              InteractOnSocialNetworksCommons
                                      .INTERACT_ON_SOCIAL_NETWORK_CONTENTS[
                                  "data"]["icon"],
                            ),
                          ),
                          changeBackground: Colors.grey[400],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorDotWidget(
              context,
              3,
              3,
              "Tiếp",
              AllCompletedPage(
                name: "advertisement_settings_on_facebook",
              )),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
