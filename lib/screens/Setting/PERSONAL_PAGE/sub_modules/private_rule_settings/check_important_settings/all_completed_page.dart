import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/check_important_settings_page.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/how_find_you_modules/how_find_you_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/see_your_share_modules/who_see_share_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/set_your_data_modules/set_your_data_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../../../../../../theme/colors.dart';
import 'protect_account/protect_your_account_constants.dart';

class AllCompletedPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  final String name;
  AllCompletedPage({super.key, required this.name});

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
                children: [checkName(name)],
              ),
            ),
          ),
          Container(
            height: name == "how_to_protect_your_account" ? 130 : 80,
            color: transparent,
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Divider(
                  height: 10,
                  // color:  white,
                ),
              ),
              Expanded(
                  child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.9, 40),
                        // backgroundColor: Colors.blue
                      ),
                      onPressed: (() {
                        pushToNextScreen(context, CheckImportantSettingsPage());
                      }),
                      child: buildTextContent("Xem lại chủ đề khác", true,
                          isCenterLeft: false),
                    ),
                    name == "how_to_protect_your_account"
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(width * 0.9, 40),
                                backgroundColor: Colors.grey[700]),
                            onPressed: (() {
                              // pushToNextScreen(context, CheckImportantSettingsPage());
                            }),
                            child: buildTextContent("Sửa các lỗi còn lại", true,
                                isCenterLeft: false),
                          )
                        : const SizedBox(),
                  ],
                ),
              ))
            ]),
          )
        ]),
      ),
    );
  }

  Widget _buildContent(String title, String subTitle, dynamic contents) {
    // final contents = AllComplete4Constants.ALL_COMPLETED_CONTENTS;
    return Column(
      children: [
        // img
        Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.only(bottom: 15),
          child: Image.asset("${SettingConstants.PATH_IMG}cat_1.png"),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            children: [
              Text(
                title,
                style: const TextStyle(
                    // color:  white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        buildTextContent(
          subTitle, false,
          fontSize: 17,
          //  colorWord: Colors.grey[300]
        ),
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
                    // colorWord: Colors.grey[300]
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

  checkName(String name) {
    switch (name) {
      case "who_can_see_what_you_share":
        return _buildContent(
            WhoCanSeeYourShareConstants.ALL_COMPLETED_TITLE,
            WhoCanSeeYourShareConstants.ALL_COMPLETED_SUBTITLE,
            WhoCanSeeYourShareConstants.ALL_COMPLETED_CONTENTS);
      case "how_to_protect_your_account":
        return _buildContent(
            HowToProtectYourAccountConstants.ALL_COMPLETED_TITLE,
            HowToProtectYourAccountConstants.ALL_COMPLETED_SUBTITLE,
            HowToProtectYourAccountConstants.ALL_COMPLETED_CONTENTS);
      case "how_people_can_find_you_on_Emso":
        return _buildContent(
            HowPeopleCanFindYouOnEmsoConstants.ALL_COMPLETED_TITLE,
            HowPeopleCanFindYouOnEmsoConstants.ALL_COMPLETED_SUBTITLE,
            HowPeopleCanFindYouOnEmsoConstants.ALL_COMPLETED_CONTENTS);
      case "set_your_data_on_Emso":
        return _buildContent(
            AllComplete4Constants.ALL_COMPLETED_TITLE,
            AllComplete4Constants.ALL_COMPLETED_SUBTITLE,
            AllComplete4Constants.ALL_COMPLETED_CONTENTS);
      default:
        return _buildContent(
            AllComplete4Constants.ALL_COMPLETED_TITLE,
            AllComplete4Constants.ALL_COMPLETED_SUBTITLE,
            AllComplete4Constants.ALL_COMPLETED_CONTENTS);
    }
  }
}
