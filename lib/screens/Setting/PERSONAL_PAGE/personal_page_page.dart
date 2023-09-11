import 'package:flutter/cupertino.dart';
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

  final String _selectedBottomNavigator = "Trang chủ";

  PersonalSettingsPage({super.key});

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
            const BackIconAppbar(),
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
                          listView: SizedBox(
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
                                                CupertinoPageRoute(
                                                    builder: (_) =>
                                                        const PrivateRulesSettingPage()));
                                            break;
                                          }
                                        case "personal_page_and_tag":
                                          {
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Trang ca nhan ...")));
                                              break;
                                            }
                                          }
                                        case "public_post":
                                          {
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Bài viết công khai ...")));
                                              break;
                                            }
                                          }
                                        case "block":
                                          {
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Bài viết công khai ...")));
                                              break;
                                            }
                                          }
                                        default:
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
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
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              // color:  white
                                            )),
                                        Text(
                                            PersonalPageConstants
                                                    .PRIVATE_INFORMATION_LIST[
                                                index]["data"]["subTitle"],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              // color: Colors.grey
                                            )),
                                      ],
                                      prefixWidget: Container(
                                        height: 40,
                                        width: 40,
                                        padding: const EdgeInsets.all(7),
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: const BoxDecoration(
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
                                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
                                    ),
                                  );
                                })),
                          )),
                      // notification
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants.NOTIFICATION_TITLE,
                        subTitle:
                            PersonalPageConstants.NOTIFICATION_DESCRIPTION,
                        listView: SizedBox(
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
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .NOTIFICATION_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.all(7),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: const BoxDecoration(
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
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
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
                        listView: SizedBox(
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
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .YOUR_INFORMATION_IN_Emso_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.all(7),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: const BoxDecoration(
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
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
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
                        listView: SizedBox(
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
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .FEED_SETTINGS_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.all(7),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: const BoxDecoration(
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
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      //  file and contact
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants.STORY_TITLE,
                        subTitle: PersonalPageConstants.STORY_DESCRIPTION,
                        listView: SizedBox(
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
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .STORY_INFORMATION_LIST[index]
                                              ["data"]["subTitle"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.all(7),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: const BoxDecoration(
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
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
                                  ),
                                );
                              })),
                        ),
                      ),
                      // SHORT CUT
                      TitleDescriptionAndContentListWidget(
                        title: PersonalPageConstants.SHORTCUT_TITLE,
                        subTitle: PersonalPageConstants.SHORTCUT_DESCRIPTION,
                        listView: SizedBox(
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
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            // color:  white
                                          )),
                                      Text(
                                          PersonalPageConstants
                                                  .SHORTCUT_INFORMATION_LIST[
                                              index]["data"]["subTitle"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            // color: Colors.grey
                                          )),
                                    ],
                                    prefixWidget: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.all(7),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: const BoxDecoration(
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
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
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
