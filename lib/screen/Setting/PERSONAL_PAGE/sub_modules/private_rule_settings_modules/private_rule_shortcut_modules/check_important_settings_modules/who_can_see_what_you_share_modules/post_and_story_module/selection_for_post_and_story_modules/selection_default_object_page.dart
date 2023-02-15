import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/who_can_see_what_you_share_modules/post_and_story_module/selection_for_post_and_story_modules/selection_default_object_commons.dart';
import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
class SelectionDefaultObjectPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
/// chua lam tang tiep cua bajn be ngoai tru va ban be cu the
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
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
          // pop icon
          Container(
            margin: EdgeInsets.only(top: 60, bottom: 10),
            child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 50),
                    // height: 70,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        SettingConstants.BACK_ICON_DATA,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  Container(
                      child: buildTextContent(
                          SelectionDefaultObjectCommons.SELECTION_DEFAULT_OBJECT_APPBAR_TITLE,
                          true,fontSize: 18,)),
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
                  // title
                  _buildDivider(),
                  buildTextContent(
                      SelectionDefaultObjectCommons.SELECTION_DEFAULT_OBJECT_DESCRIPTION, false,
                      colorWord: Colors.grey, fontSize: 14),
                  // selection object
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: buildTextContent(
                        SelectionDefaultObjectCommons.SELECTION_DEFAULT_OBJECT_TITLE, true,
                        fontSize: 18),
                  ),
                  _buildDivider(),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                      itemCount: SelectionDefaultObjectCommons
                          .SELECTION_DEFAULT_OBJECT_CONTENT["data"].length,
                      itemBuilder: ((context, index) {
                        final data = SelectionDefaultObjectCommons
                            .SELECTION_DEFAULT_OBJECT_CONTENT["data"];
                        return _buildSelectionComponent(
                          data[index]["icon"],
                          data[index]["title"],
                          data[index]["subTitle"],
                          iconData: data[index]["iconNext"] ?? null,
                        );
                      }))
                ],
              ),
            ),
          ),
          // navigator
         buildBottomNavigatorBarWidget(context)]),
      ),
    );
  }
}

_buildDivider() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0, top: 5),
    child: Divider(
      height: 10,
      color: Colors.white,
    ),
  );
}

_buildSelectionComponent(String iconPath, String title, String subTitle,
    {IconData? iconData}) {
  return Container(
    // color: Colors.red,
    // padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                child: Radio(
                    value: true, groupValue: true, onChanged: ((value) {})),
              ),
              Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset(
                  iconPath,
                  color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildTextContent(
                    title,
                    false,
                    fontSize: 16,
                    colorWord: Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  buildTextContent(subTitle, false,
                      colorWord: Colors.grey, fontSize: 14)
                ],
              ),
            ],
          ),
          iconData != null
              ? Container(
                  child: Icon(iconData, color: Colors.grey),
                )
              : SizedBox()
        ],
      ),
      _buildDivider()
    ]),
  );
}
