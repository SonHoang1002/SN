import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/emso_advertising_options/information_personal_page_adver.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import 'emso_advertising_options_constants.dart';

class RecommendAdvertisementOnEmsoPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;
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
                title: RecommendAdvertisementOnEmsoConstants
                    .RECOMMEND_ADVERTISEMENT_ON_Emso_APPBAR_TITLE),
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
                    RecommendAdvertisementOnEmsoConstants
                        .RECOMMEND_ADVERTISEMENT_ON_Emso_ADVERTISEMENT_YOU_SEE_ON_Emso,
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
                      RecommendAdvertisementOnEmsoConstants
                          .RECOMMEND_ADVERTISEMENT_ON_Emso_EXAMPLE_IF_YOU_EXCITED_TO_SPORT,
                      false,
                      fontSize: 14,
                      colorWord: Colors.grey[600]),
                  _buildSpacer(height: 10),
                  buildTextContent(
                    RecommendAdvertisementOnEmsoConstants
                        .RECOMMEND_ADVERTISEMENT_ON_Emso_TO_DETERMINE_ADVERTISEMENTS_YOU_CAN_CONCERN_WITH,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  _buildSpacer(height: 10),
                  buildTextContent(
                    RecommendAdvertisementOnEmsoConstants
                        .RECOMMEND_ADVERTISEMENT_ON_Emso_WE_MAY_ALSO_CONSIDER_YOUR_ACTIVITY_OUTSIDE_OF_Emso,
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
                      RecommendAdvertisementOnEmsoConstants
                          .RECOMMEND_ADVERTISEMENT_ON_Emso_EXAMPLE_IF_YOU_ACCESS_TO_ONLINE_SHOPPING_WEBSITE,
                      false,
                      fontSize: 14,
                      colorWord: Colors.grey[600]),
                  _buildSpacer(height: 10),
                  GeneralComponent(
                    [
                      buildTextContent(
                        RecommendAdvertisementOnEmsoConstants
                            .RECOMMEND_ADVERTISEMENT_ON_Emso_TIP,
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
                    RecommendAdvertisementOnEmsoConstants
                        .RECOMMEND_ADVERTISEMENT_ON_Emso_NEXT_WE_WILL_SHOW_HOW_TO_USE_A_FEW_OPTIONS,
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
