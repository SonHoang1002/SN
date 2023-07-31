import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/all_completed_page.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/emso_advertising_options/emso_advertising_options_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class InteractOnSocialNetworksPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  InteractOnSocialNetworksPage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
                title: InteractOnSocialNetworksConstants
                    .INFORMATION_ON_Emso_APPBAR_TITLE),
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
                    InteractOnSocialNetworksConstants
                        .INTERACT_ON_SOCIAL_NETWORK_INTERACT_ON_SOCIAL_NETWORK,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  buildSpacer(height: 10),
                  buildTextContent(
                    InteractOnSocialNetworksConstants
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
                            InteractOnSocialNetworksConstants
                                    .INTERACT_ON_SOCIAL_NETWORK_PAGE_CONTENTS[
                                "data"]["title"],
                            true,
                            fontSize: 15,
                            // colorWord: Colors.grey[200]
                          ),
                          buildSpacer(height: 5),
                          buildTextContent(
                            InteractOnSocialNetworksConstants
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
                                InteractOnSocialNetworksConstants
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
                        //     InteractOnSocialNetworksConstants
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
                            // InteractOnSocialNetworksConstants
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
                          padding: const EdgeInsets.only(right: 10.0),
                          child: buildTextContent(
                              InteractOnSocialNetworksConstants
                                      .INTERACT_ON_SOCIAL_NETWORK_CONTENTS[
                                  "data"]["title"],
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
                                InteractOnSocialNetworksConstants
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
                              InteractOnSocialNetworksConstants
                                      .INTERACT_ON_SOCIAL_NETWORK_CONTENTS[
                                  "data"]["icon"],
                            ),
                          ),
                          suffixWidget: Container(
                            height: 30,
                            width: 30,
                            margin: EdgeInsets.all(5),
                            child: SvgPicture.asset(
                              InteractOnSocialNetworksConstants
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
                name: "advertisement_settings_on_Emso",
              )),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
