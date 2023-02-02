import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/personal_page_commons.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_settings_page.dart';
import 'package:social_network_app_mobile/screen/Setting/setting.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/GeneralWidget/title_description_and_content_list.dart';
import '../../../widget/search_input.dart';
import '../setting_constants/general_settings_constants.dart';

class PersonalSettingsPage extends StatelessWidget {
  late double width = 0;

  late double height = 0;

  String _selectedBottomNavigator = "Trang chủ";

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
                          title: PersonalPageCommons.PRIVATE_TITLE,
                          subTitle: PersonalPageCommons.PRIVATE_DESCRIPTION,
                          listView: Container(
                            height: 305,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: PersonalPageCommons
                                    .PRIVATE_INFORMATION_LIST.length,
                                itemBuilder: ((context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // final list = PersonalPageCommons
                                      //     .PRIVATE_INFORMATION_LIST;
                                      //////////////////////////h/////////////////////////////////////////////////////////////////////
                                      switch (PersonalPageCommons
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
                                            PersonalPageCommons
                                                    .PRIVATE_INFORMATION_LIST[
                                                index]["data"]["title"],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.white
                                            )),
                                        Text(
                                            PersonalPageCommons
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
                                          PersonalPageCommons
                                                  .PRIVATE_INFORMATION_LIST[
                                              index]["data"]["icon"],
                                          // color: Colors.white,
                                        ),
                                      ),
                                      changeBackground: Colors.transparent,
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                    ),
                                  );
                                })),
                          )),
                      // notification
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageCommons.NOTIFICATION_TITLE,
                        subTitle: PersonalPageCommons.NOTIFICATION_DESCRIPTION,
                        listView: Container(
                          height: 340,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageCommons
                                  .NOTIFICATION_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageCommons
                                                  .NOTIFICATION_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.white
                                          )),
                                      Text(
                                          PersonalPageCommons
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
                                        PersonalPageCommons
                                                .NOTIFICATION_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color: Colors.white,
                                      ),
                                    ),
                                    changeBackground: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      // your information in facebook
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageCommons
                            .YOUR_INFORMATION_IN_FACEBOOK_TITLE,
                        subTitle: PersonalPageCommons
                            .YOUR_INFORMATION_IN_FACEBOOK_DESCRIPTION,
                        listView: Container(
                          height: 290,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageCommons
                                  .YOUR_INFORMATION_IN_FACEBOOK_INFORMATION_LIST
                                  .length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageCommons
                                                  .YOUR_INFORMATION_IN_FACEBOOK_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.white
                                          )),
                                      Text(
                                          PersonalPageCommons
                                                  .YOUR_INFORMATION_IN_FACEBOOK_INFORMATION_LIST[
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
                                        PersonalPageCommons
                                                .YOUR_INFORMATION_IN_FACEBOOK_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color: Colors.white,
                                      ),
                                    ),
                                    changeBackground: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      //  file and contact
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageCommons.FEED_SETTINGS_TITLE,
                        subTitle: PersonalPageCommons.FEED_SETTINGS_DESCRIPTION,
                        listView: Container(
                          height: 120,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageCommons
                                  .FEED_SETTINGS_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageCommons
                                                  .FEED_SETTINGS_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.white
                                          )),
                                      Text(
                                          PersonalPageCommons
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
                                        PersonalPageCommons
                                                .FEED_SETTINGS_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color: Colors.white,
                                      ),
                                    ),
                                    changeBackground: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      //  file and contact
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageCommons.STORY_TITLE,
                        subTitle: PersonalPageCommons.STORY_DESCRIPTION,
                        listView: Container(
                          height: 70,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageCommons
                                  .STORY_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageCommons
                                                  .STORY_INFORMATION_LIST[index]
                                              ["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.white
                                          )),
                                      Text(
                                          PersonalPageCommons
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
                                        PersonalPageCommons
                                                .STORY_INFORMATION_LIST[index]
                                            ["data"]["icon"],
                                        // color: Colors.white,
                                      ),
                                    ),
                                    changeBackground: Colors.transparent,
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      // SHORT CUT
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageCommons.SHORTCUT_TITLE,
                        subTitle: PersonalPageCommons.SHORTCUT_DESCRIPTION,
                        listView: Container(
                          height: 70,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: PersonalPageCommons
                                  .SHORTCUT_INFORMATION_LIST.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ////
                                  },
                                  child: GeneralComponent(
                                    [
                                      Text(
                                          PersonalPageCommons
                                                  .SHORTCUT_INFORMATION_LIST[
                                              index]["data"]["title"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.white
                                          )),
                                      Text(
                                          PersonalPageCommons
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
                                        PersonalPageCommons
                                                .SHORTCUT_INFORMATION_LIST[
                                            index]["data"]["icon"],
                                        // color: Colors.white,
                                      ),
                                    ),
                                    changeBackground: Colors.transparent,
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
