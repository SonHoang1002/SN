import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/emso_advertising_options_modules/emso_advertising_options_constants.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/how_find_you_modules/how_find_you_constants.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/how_protect_account_modules/login_warning_page.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/set_your_data_modules/application_and_website_page.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/set_your_data_modules/set_your_data_constants.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/check_important_settings_modules/see_your_share_modules/who_see_share_constants.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import '../../../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../../../widget/GeneralWidget/text_content_widget.dart';
import 'emso_advertising_options_modules/recommend_advertisement_page.dart';
import 'how_find_you_modules/add_friend_request_page.dart';
import 'how_protect_account_modules/protect_your_account_constants.dart';
import 'see_your_share_modules/information_personal_page.dart';

class CheckPrivateRuleComponentPage extends StatelessWidget {
  CheckPrivateRuleComponentPage({required this.path, required this.name});
  String path;
  String name;

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
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
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
                children: [_buildContent(path, name)],
              ),
            ),
          ),
          Container(
            height: 90,
            color: transparent,
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Divider(
                  height: 10,
                  // color:  white,
                ),
              ),
              Expanded(
                  child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(width * 0.9, 40)),
                  child: const Text("Tiep tuc"),
                  onPressed: (() {
                    Widget nextRoute;
                    switch (name) {
                      case "who_can_see_what_you_share":
                        nextRoute = InformationOnPersonalPagePage();
                        break;
                      case "how_to_protect_your_account":
                        nextRoute = LoginWarningPage();
                        break;
                      case "how_people_can_find_you_on_facebook":
                        nextRoute = AddFriendRequestPage();
                        break;
                      case "set_your_data_on_facebook":
                        nextRoute = ApplicationAndWebsitePage();
                        break;
                      default:
                        nextRoute = RecommendAdvertisementOnFacebookPage();
                        break;
                    }
                    pushToNextScreen(context, nextRoute);
                  }),
                ),
              ))
            ]),
          )
        ]),
      ),
    );
  }

  Widget _buildContent(String path, String name) {
    String title = "";
    String subTitle = "";
    var contents;

    switch (name) {
      case "who_can_see_what_you_share":
        title = WhoCanSeeYourShareConstants
            .WHO_CAN_SEE_WHAT_YOU_SHARE_COMPONENT_TITLE;
        subTitle = WhoCanSeeYourShareConstants
            .WHO_CAN_SEE_WHAT_YOU_SHARE_COMPONENT_SUBTITLE;
        contents = WhoCanSeeYourShareConstants
            .WHO_CAN_SEE_WHAT_YOU_SHARE_COMPONENT_CONTENTS;
        break;

      case "how_to_protect_your_account":
        title =
            HowToProtectYourAccountConstants.HOW_TO_PROTECT_YOUR_ACCOUNT_TITLE;
        subTitle = HowToProtectYourAccountConstants
            .HOW_TO_PROTECT_YOUR_ACCOUNT_SUBTITLE;
        contents = HowToProtectYourAccountConstants
            .HOW_TO_PROTECT_YOUR_ACCOUNT_CONTENTS;
        break;

      case "how_people_can_find_you_on_facebook":
        title = HowPeopleCanFindYouOnFacebookConstants
            .HOW_PEOPLE_CAN_FIND_YOU_ON_FACEBOOK_TITLE;
        subTitle = HowPeopleCanFindYouOnFacebookConstants
            .HOW_PEOPLE_CAN_FIND_YOU_ON_FACEBOOK_SUBTITLE;
        contents = HowPeopleCanFindYouOnFacebookConstants
            .HOW_PEOPLE_CAN_FIND_YOU_ON_FACEBOOK_CONTENTS;
        break;

      case "set_your_data_on_facebook":
        title = SetYourDataOnFacebookConstants.SET_YOUR_DATA_ON_FACEBOOK_TITLE;
        subTitle =
            SetYourDataOnFacebookConstants.SET_YOUR_DATA_ON_FACEBOOK_SUBTITLE;
        contents =
            SetYourDataOnFacebookConstants.SET_YOUR_DATA_ON_FACEBOOK_CONTENTS;
        break;
      default:
        title = FacebookAdvertisementOptionsConstants
            .FACEBOOK_ADVERTISEMENT_OPTIONS_TITLE;
        subTitle = FacebookAdvertisementOptionsConstants
            .FACEBOOK_ADVERTISEMENT_OPTIONS_SUBTITLE;
        contents = FacebookAdvertisementOptionsConstants
            .FACEBOOK_ADVERTISEMENT_OPTIONS_CONTENTS;
        break;
    }
    return Column(
      children: [
        // img
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Image.asset(path),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: buildTextContent(title, true, fontSize: 24),
        ),
        buildTextContent(subTitle, false, fontSize: 20),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: contents["data"].length,
            itemBuilder: ((context, index) {
              return GeneralComponent(
                [
                  buildTextContent(
                    contents["data"][index]["content"], false,
                    // colorWord: Colors.grey
                  )
                ],
                prefixWidget: Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: SvgPicture.asset(
                    contents["data"][index]["icon"],
                    height: 20,
                    // color:  white,
                  ),
                ),
                changeBackground: transparent,
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 5),
              );
            })),
      ],
    );
  }
}