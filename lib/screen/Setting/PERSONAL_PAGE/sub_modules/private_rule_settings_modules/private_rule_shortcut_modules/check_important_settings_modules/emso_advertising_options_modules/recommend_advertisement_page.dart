import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/emso_advertising_options_modules/emso_advertising_options_constants.dart';
import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import 'information_on_personal_page_adver_page.dart';

class RecommendAdvertisementOnFacebookPage extends StatelessWidget {
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
                title: RecommendAdvertisementOnFacebookConstants
                    .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_APPBAR_TITLE),
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
                    RecommendAdvertisementOnFacebookConstants
                        .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_ADVERTISEMENT_YOU_SEE_ON_FACEBOOK,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  _buildSpacer(height: 10),
                  Container(
                    height: 200,
                    width: width * 0.8,
                    color: Colors.red,
                    // child: Image.asset(SettingConstants.PATH_IMG + ""),
                  ),
                  _buildSpacer(height: 5),
                  buildTextContent(
                      RecommendAdvertisementOnFacebookConstants
                          .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_EXAMPLE_IF_YOU_EXCITED_TO_SPORT,
                      false,
                      fontSize: 14,
                      colorWord: Colors.grey[600]),
                  _buildSpacer(height: 10),
                  buildTextContent(
                    RecommendAdvertisementOnFacebookConstants
                        .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_TO_DETERMINE_ADVERTISEMENTS_YOU_CAN_CONCERN_WITH,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  _buildSpacer(height: 10),
                  buildTextContent(
                    RecommendAdvertisementOnFacebookConstants
                        .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_WE_MAY_ALSO_CONSIDER_YOUR_ACTIVITY_OUTSIDE_OF_FACEBOOK,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  _buildSpacer(height: 10),
                  Container(
                    height: 200,
                    width: width * 0.8,
                    color: Colors.green,
                    // child: Image.asset(SettingConstants.PATH_IMG + ""),
                  ),
                  _buildSpacer(height: 5),
                  buildTextContent(
                      RecommendAdvertisementOnFacebookConstants
                          .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_EXAMPLE_IF_YOU_ACCESS_TO_ONLINE_SHOPPING_WEBSITE,
                      false,
                      fontSize: 14,
                      colorWord: Colors.grey[600]),
                  _buildSpacer(height: 10),
                  GeneralComponent(
                    [
                      buildTextContent(
                        RecommendAdvertisementOnFacebookConstants
                            .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_TIP,
                        false,
                        fontSize: 16,
                        // colorWord: Colors.grey[200]
                      )
                    ],
                    prefixWidget: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        SettingConstants.PATH_ICON + "bell_icon.svg",
                        color: Colors.blue,
                      ),
                    ),
                    changeBackground: Colors.grey[300],
                    borderRadiusValue: 10,
                  ),
                  _buildSpacer(height: 10),
                  buildTextContent(
                    RecommendAdvertisementOnFacebookConstants
                        .RECOMMEND_ADVERTISEMENT_ON_FACEBOOK_NEXT_WE_WILL_SHOW_HOW_TO_USE_A_FEW_OPTIONS,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorDotWidget(
              context, 3, 1, "Tiếp", InformationOnPersonalAdverPagePage()),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}

_buildSpacer({double? height, double? width}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
  );
}
