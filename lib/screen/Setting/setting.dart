// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:social_network_app_mobile/screen/Setting/darkmode_setting.dart';
// import 'package:social_network_app_mobile/widget/appbar_title.dart';
// import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

// class Setting extends StatelessWidget {
//   const Setting({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             BackIconAppbar(),
//             AppBarTitle(title: "Cài đặt"),
//             SizedBox(),
//           ],
//         ),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           Navigator.push(
//               context,
//               CupertinoPageRoute(
//                   builder: ((context) => const DarkModeSetting())));
//         },
//         child: Container(
//           margin: const EdgeInsets.all(15),
//           child: Row(
//             children: const [
//               Icon(FontAwesomeIcons.moon),
//               SizedBox(
//                 width: 8,
//               ),
//               Text("Chế độ tối")
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:social_network_app_mobile/screen/Setting/darkmode_setting.dart';
// import 'package:social_network_app_mobile/widget/appbar_title.dart';
// import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
// class Setting extends StatelessWidget {
//   const Setting({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             BackIconAppbar(),
//             AppBarTitle(title: "Cài đặt"),
//             SizedBox(),
//           ],
//         ),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           Navigator.push(
//               context,
//               CupertinoPageRoute(
//                   builder: ((context) => const DarkModeSetting())));
//         },
//         child: Container(
//           margin: const EdgeInsets.all(15),
//           child: Row(
//             children: const [
//               Icon(FontAwesomeIcons.moon),
//               SizedBox(
//                 width: 8,
//               ),
//               Text("Chế độ tối")
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/personal_page_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

import '../../theme/colors.dart';
import '../../widget/GeneralWidget/title_description_content_list.dart';
import 'setting_constants/general_settings_constants.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  get white => null;

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: [
                  // personal page description
                  Wrap(
                    children: [
                      const Text(
                        SettingConstants.PERSONAL_PAGE_DESCRIPTION,
                        style: TextStyle(
                          // color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  // user example
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PersonalSettingsPage()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: GeneralComponent(
                        [
                          Text(SettingConstants.USER_EXAMPLE[1],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                // color: Colors.grey[800]
                              )),
                          Text(SettingConstants.USER_EXAMPLE[2],
                              style: const TextStyle(
                                fontSize: 15,
                                // color: Colors.grey
                              )),
                        ],
                        prefixWidget: Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Image.asset(
                              SettingConstants.USER_EXAMPLE[0],
                              // color: Colors.grey[900],
                            )),
                        changeBackground: transparent,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // divider
            const CrossBar(),
            // account
            TitleDescriptionAndContentListWidget(
              title: SettingConstants.ACCOUNT_TITLE,
              subTitle: SettingConstants.ACCOUNT_DESCRIPTION,
              listView: Container(
                height: 380,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: SettingConstants.ACCOUNT_INFORMATION_LIST.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: GeneralComponent(
                          [
                            Text(
                                SettingConstants.ACCOUNT_INFORMATION_LIST[index]
                                    ["data"]["title"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  // color:  white
                                )),
                            Text(
                                SettingConstants.ACCOUNT_INFORMATION_LIST[index]
                                    ["data"]["subTitle"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  //  color: Colors.grey
                                )),
                          ],
                          prefixWidget: Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: SvgPicture.asset(
                              SettingConstants.ACCOUNT_INFORMATION_LIST[index]
                                  ["data"]["icon"],
                              // color: Colors.grey[900],
                            ),
                          ),
                          changeBackground: transparent,
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
                        ),
                      );
                    })),
              ),
            ),
            // security
            TitleDescriptionAndContentListWidget(
              title: SettingConstants.SECURITY_TITLE,
              subTitle: SettingConstants.SECURITY_DESCRIPTION,
              listView: Container(
                height: 390,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount:
                        SettingConstants.SECURITY_INFORMATION_LIST.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          ////
                        },
                        child: GeneralComponent(
                          [
                            Text(
                                SettingConstants
                                        .SECURITY_INFORMATION_LIST[index]
                                    ["data"]["title"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  // color:  white
                                )),
                            Text(
                                SettingConstants
                                        .SECURITY_INFORMATION_LIST[index]
                                    ["data"]["subTitle"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  //  color: Colors.grey
                                )),
                          ],
                          prefixWidget: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(7),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: SvgPicture.asset(
                                SettingConstants
                                        .SECURITY_INFORMATION_LIST[index]
                                    ["data"]["icon"],
                                // color: Colors.grey[900],
                              )),
                          changeBackground: transparent,
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
                        ),
                      );
                    })),
              ),
            ),
            //  advertisement
            TitleDescriptionAndContentListWidget(
              title: SettingConstants.ADVERTISEMENT_TITLE,
              subTitle: SettingConstants.ADVERTISEMENT_DESCRIPTION,
              listView: Container(
                height: 90,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount:
                        SettingConstants.ADVERTISEMENT_INFORMATION_LIST.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          ////
                        },
                        child: GeneralComponent(
                          [
                            Text(
                                SettingConstants
                                        .ADVERTISEMENT_INFORMATION_LIST[index]
                                    ["data"]["title"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  // color:  white
                                )),
                            Text(
                                SettingConstants
                                        .ADVERTISEMENT_INFORMATION_LIST[index]
                                    ["data"]["subTitle"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  //  color: Colors.grey
                                )),
                          ],
                          prefixWidget: Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: SvgPicture.asset(
                              SettingConstants.SECURITY_INFORMATION_LIST[index]
                                  ["data"]["icon"],
                            ),
                          ),
                          changeBackground: transparent,
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 7),
                        ),
                      );
                    })),
              ),
            ),
            // meta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                children: [
                  // meta title
                  Row(
                    children: [
                      const Text(
                        "Meta",
                        style: TextStyle(
                            // color:  white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // meta description
                  Row(
                    children: [
                      Text(
                        SettingConstants.META_DESCRIPTION[0],
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      Text(
                        SettingConstants.META_DESCRIPTION[1],
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CrossBar(),

            // privacy title
            TitleDescriptionAndContentListWidget(
              title: SettingConstants.POLICY_TITLE,
              listView: Container(
                height: 120,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: SettingConstants.POLICY_SUBTITLE.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          SettingConstants.POLICY_SUBTITLE[index]["data"]!,
                          style: TextStyle(color: white, fontSize: 15),
                        ),
                      );
                    })),
              ),
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}

demoFunction() {}
