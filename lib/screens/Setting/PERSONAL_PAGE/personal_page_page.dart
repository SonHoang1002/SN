import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import '../../../widgets/GeneralWidget/general_component.dart';
import '../../../widgets/GeneralWidget/title_description_content_list.dart';
import '../../../widgets/back_icon_appbar.dart';
import '../../../widgets/search_input.dart';
import 'personal_page_constants.dart';
import 'sub_modules/private_rule_settings/private_rule_settings_page.dart';

class PersonalSettingsPage extends StatelessWidget {
  late double width = 0;

  late double height = 0;

  String _selectedBottomNavigator = "Trang chủ";

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
          children: [
            BackIconAppbar(),
            Expanded(
                child: SearchInput(
              handleSearch: demoFunction,
            ))
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
                  // padding: const EdgeInsets.symmetric(horizontal: 15),
                  // color: Colors.grey[900],
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // private rules
                      TitleDescriptionAndContentListWidget(
                          title: PersonalPageConstants.PRIVATE_TITLE,
                          subTitle: PersonalPageConstants.PRIVATE_DESCRIPTION,
                          listView: Container(
                            height: 305,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: PersonalPageConstants
                                    .PRIVATE_INFORMATION_LIST.length,
                                itemBuilder: ((context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // final list = PersonalPageConstants
                                      //     .PRIVATE_INFORMATION_LIST;
                                      //////////////////////////h/////////////////////////////////////////////////////////////////////
                                      switch (PersonalPageConstants
                                              .PRIVATE_INFORMATION_LIST[index]
                                          ["key"]) {
                                        case "private_rule":
                                          {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        PrivateRulesSettingPage()));
                                            break;
                                          }
                                        case "personal_page_and_tag":
                                          {
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Trang ca nhan ...")));
                                              break;
                                            }
                                          }
                                        case "public_post":
                                          {
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Bài viết công khai ...")));
                                              break;
                                            }
                                          }
                                        case "block":
                                          {
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Bài viết công khai ...")));
                                              break;
                                            }
                                          }
                                        default:
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Trạng thái hoạt động ...")));
                                            break;
                                          }
                                      }
                                    },
                                    child: GeneralComponent(
                                      [
                                        Text(
                                            PersonalPageConstants
                                                    .PRIVATE_INFORMATION_LIST[
                                                index]["data"]["title"],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              // color:  white
                                            )),
                                        Text(
                                            PersonalPageConstants
                                                    .PRIVATE_INFORMATION_LIST[
                                                index]["data"]["subTitle"],
                                            style: TextStyle(
                                              fontSize: 15,
                                              // color: Colors.grey
                                            )),
                                      ],
                                      prefixWidget: Container(
                                        height: 40,
                                        width: 40,
                                        padding: EdgeInsets.all(7),
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: SvgPicture.asset(
                                          PersonalPageConstants
                                                  .PRIVATE_INFORMATION_LIST[
                                              index]["data"]["icon"],
                                          // color:  white,
                                        ),
                                      ),
                                      changeBackground: transparent,
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                    ),
                                  );
                                })),
                          )),
                      // notification
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants.NOTIFICATION_TITLE,
                        subTitle:
                            PersonalPageConstants.NOTIFICATION_DESCRIPTION,
                        listView: Container(
                          height: 340,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageConstants
                                  .NOTIFICATION_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageConstants
                                                  .NOTIFICATION_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .NOTIFICATION_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: SvgPicture.asset(
                                        PersonalPageConstants
                                                .NOTIFICATION_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color:  white,
                                      ),
                                    ),
                                    changeBackground: transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      // your information in Emso
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants
                            .YOUR_INFORMATION_IN_Emso_TITLE,
                        subTitle: PersonalPageConstants
                            .YOUR_INFORMATION_IN_Emso_DESCRIPTION,
                        listView: Container(
                          height: 290,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageConstants
                                  .YOUR_INFORMATION_IN_Emso_INFORMATION_LIST
                                  .length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageConstants
                                                  .YOUR_INFORMATION_IN_Emso_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .YOUR_INFORMATION_IN_Emso_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: SvgPicture.asset(
                                        PersonalPageConstants
                                                .YOUR_INFORMATION_IN_Emso_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color:  white,
                                      ),
                                    ),
                                    changeBackground: transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      //  file and contact
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants.FEED_SETTINGS_TITLE,
                        subTitle:
                            PersonalPageConstants.FEED_SETTINGS_DESCRIPTION,
                        listView: Container(
                          height: 120,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageConstants
                                  .FEED_SETTINGS_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageConstants
                                                  .FEED_SETTINGS_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .FEED_SETTINGS_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: SvgPicture.asset(
                                        PersonalPageConstants
                                                .FEED_SETTINGS_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color:  white,
                                      ),
                                    ),
                                    changeBackground: transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      //  file and contact
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants.STORY_TITLE,
                        subTitle: PersonalPageConstants.STORY_DESCRIPTION,
                        listView: Container(
                          height: 70,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageConstants
                                  .STORY_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageConstants
                                                  .STORY_INFORMATION_LIST[index]
                                              ["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .STORY_INFORMATION_LIST[index]
                                              ["data"]["subTitle"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: SvgPicture.asset(
                                        PersonalPageConstants
                                                .STORY_INFORMATION_LIST[index]
                                            ["data"]["icon"],
                                        // color:  white,
                                      ),
                                    ),
                                    changeBackground: transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      // SHORT CUT
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants.SHORTCUT_TITLE,
                        subTitle: PersonalPageConstants.SHORTCUT_DESCRIPTION,
                        listView: Container(
                          height: 70,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageConstants
                                  .SHORTCUT_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageConstants
                                                  .SHORTCUT_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .SHORTCUT_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: SvgPicture.asset(
                                        PersonalPageConstants
                                                .SHORTCUT_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color:  white,
                                      ),
                                    ),
                                    changeBackground: transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      Container(
                        height: 50,
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

demoFunction() {}
