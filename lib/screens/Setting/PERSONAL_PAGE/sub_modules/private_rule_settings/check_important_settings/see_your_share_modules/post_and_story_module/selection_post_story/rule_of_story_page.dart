import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'rule_of_story_constants.dart';

class SelectionPrivateRuleOfStoryPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
  /// chua lam phan man hinh tiep theo cho an tin voi va tin ban da tat
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: AppBarTitle(title: "Hủy")),
            AppBarTitle(title: "Cài đặt"),
            GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: AppBarTitle(title: "Lưu")),
            // MenuIconAppbar(),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // color: Colors.grey[900],
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 5),
                children: [
                  // title
                  _buildDivider(),
                  buildTextContent(
                      SelectionPrivateRuleOfStoryConstants
                          .SELECTION_PRIVATE_RULE_OF_STORY_TITLE[0],
                      true,
                      fontSize: 15),
                  // selection object
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: buildTextContent(
                        SelectionPrivateRuleOfStoryConstants
                            .SELECTION_PRIVATE_RULE_OF_STORY_DESCRIPTION,
                        false,
                        fontSize: 14),
                  ),
                  _buildDivider(),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: SelectionPrivateRuleOfStoryConstants
                          .SELECTION_PRIVATE_RULE_OF_STORY_CONTENT["data"][0]
                              ["subData"]
                          .length,
                      itemBuilder: ((context, index) {
                        final data = SelectionPrivateRuleOfStoryConstants
                                .SELECTION_PRIVATE_RULE_OF_STORY_CONTENT["data"]
                            [0]["subData"];
                        return Column(
                          children: [
                            GeneralComponent(
                              [
                                buildTextContent(data[index]["title"], true,
                                    fontSize: 18),
                                data[index]["subTitle"] != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: buildTextContent(
                                            data[index]["subTitle"], false,
                                            colorWord: Colors.grey,
                                            fontSize: 15),
                                      )
                                    : Container()
                              ],
                              prefixWidget: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  data[index]["icon"],
                                  // color: Colors.white,
                                ),
                              ),
                              suffixWidget: Container(
                                  height: 30,
                                  width: 30,
                                  child: data[index]["iconNext"] == ""
                                      ? Radio(
                                          value: true,
                                          groupValue: true,
                                          onChanged: (value) {})
                                      : Icon(
                                          SettingConstants.NEXT_ICON_DATA,
                                          // color: Colors.white,
                                          size: 20,
                                        )),
                              padding: EdgeInsets.zero,
                              changeBackground: Colors.transparent,
                            ),
                            _buildDivider()
                          ],
                        );
                      })),
                  // cai dat binh luan
                  buildTextContent(
                      SelectionPrivateRuleOfStoryConstants
                          .SELECTION_PRIVATE_RULE_OF_STORY_TITLE[1],
                      true,
                      fontSize: 15),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: SelectionPrivateRuleOfStoryConstants
                          .SELECTION_PRIVATE_RULE_OF_STORY_CONTENT["data"][1]
                              ["subData"]
                          .length,
                      itemBuilder: ((context, index) {
                        final data = SelectionPrivateRuleOfStoryConstants
                                .SELECTION_PRIVATE_RULE_OF_STORY_CONTENT["data"]
                            [1]["subData"];
                        return Column(
                          children: [
                            GeneralComponent(
                              [
                                buildTextContent(data[index]["title"], true,
                                    fontSize: 18),
                                data[index]["subTitle"] != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: buildTextContent(
                                            data[index]["subTitle"], false,
                                            colorWord: Colors.grey,
                                            fontSize: 15),
                                      )
                                    : Container()
                              ],
                              prefixWidget: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  data[index]["icon"],
                                  // color: Colors.white,
                                ),
                              ),
                              suffixWidget: Container(
                                  height: 30,
                                  width: 30,
                                  child: data[index]["iconNext"] == ""
                                      ? Checkbox(
                                          value: true, onChanged: (value) {})
                                      : Icon(
                                          SettingConstants.NEXT_ICON_DATA,
                                          // color: Colors.white,
                                          size: 20,
                                        )),
                              padding: EdgeInsets.zero,
                              changeBackground: Colors.transparent,
                            ),
                            _buildDivider()
                          ],
                        );
                      })),
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorBarWidget(context)
        ]),
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
