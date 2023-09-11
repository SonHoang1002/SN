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

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/search/search_provider.dart';
import 'package:social_network_app_mobile/screens/Search/search_result.dart';
import 'package:social_network_app_mobile/screens/Search/search_result_page_detail.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/personal_page_page.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_list_settings.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

import '../../theme/colors.dart';
import '../../widgets/GeneralWidget/title_description_content_list.dart';
import 'setting_constants/general_settings_constants.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  ConsumerState<Setting> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  get white => null;
  String keyword = '';
  List paramsType = ['accounts', 'pages', 'groups'];
  @override
  Widget build(BuildContext context) {
    fetchSearch(params) async {
      ref.read(searchControllerProvider.notifier).getSearch(params);
    }

    handleSearch(value) {
      if (value.isEmpty) {
        fetchSearch({
          "type[]": paramsType.map((e) => e).toList(),
          "q": '',
          "limit": 3,
        });
        setState(() {
          keyword = '';
        });
        return;
      }
      EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
          () {
        fetchSearch({
          "type[]": paramsType.map((e) => e).toList(),
          "q": value,
          "limit": 3,
        });
      });
      setState(() {
        keyword = value;
      });
    }

    searcFunction(value) {
      keyword = value;
      handleSearch(value);
      setState(() {});
    }

    onClickUser() {
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (_) => UserSettings(
                data: ref.read(meControllerProvider)[0],
              )));
    }

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
              autoFocus: false,
              handleSearch: searcFunction,
            ))
          ],
        ),
      ),
      body: keyword != ''
          ? Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    SearchResultPageDetail(keyword: keyword)));
                        ref
                            .read(searchControllerProvider.notifier)
                            .getSearchDetail(
                                {"q": keyword, 'offset': 1, "limit": 5});
                      });
                      SearchApi().postSearchHistoriesApi({"keyword": keyword});
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.3)),
                            child: const Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: secondaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.75,
                            child: Text.rich(
                              key: ValueKey(keyword),
                              TextSpan(
                                  text: 'Tìm kiếm ',
                                  style: const TextStyle(
                                      fontSize: 13, color: secondaryColor),
                                  children: [
                                    TextSpan(
                                        text: keyword,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600))
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SearchResult()
              ],
            )
          : Container(
              // padding: const EdgeInsets.symmetric(horizontal: 15),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      children: [
                        // personal page description
                        const Wrap(
                          children: [
                            Text(
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
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: GeneralComponent(
                              [
                                Text(SettingConstants.USER_EXAMPLE[1],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.grey[800]
                                    )),
                                Text(
                                    "Dành cho ${ref.read(meControllerProvider)[0]["display_name"]}",
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: AvatarSocial(
                                    width: 40,
                                    height: 40,
                                    path:
                                        /* SettingConstants.USER_EXAMPLE[0] ?? */
                                        ref.read(meControllerProvider)[0]
                                                    ['avatar_media'] ==
                                                null
                                            ? linkAvatarDefault
                                            : ref.read(meControllerProvider)[0]
                                                ['avatar_media']["preview_url"],
                                    // color: Colors.grey[900],
                                  )),
                              changeBackground: transparent,
                              padding: EdgeInsets.zero,
                              function: onClickUser,
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
                    listView: SizedBox(
                      height: 380,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount:
                              SettingConstants.ACCOUNT_INFORMATION_LIST.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: GeneralComponent(
                                [
                                  Text(
                                      SettingConstants
                                              .ACCOUNT_INFORMATION_LIST[index]
                                          ["data"]["title"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        // color:  white
                                      )),
                                  Text(
                                      SettingConstants
                                              .ACCOUNT_INFORMATION_LIST[index]
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: SvgPicture.asset(
                                    SettingConstants
                                            .ACCOUNT_INFORMATION_LIST[index]
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
                    listView: SizedBox(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
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
                    listView: SizedBox(
                      height: 90,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: SettingConstants
                              .ADVERTISEMENT_INFORMATION_LIST.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                ////
                              },
                              child: GeneralComponent(
                                [
                                  Text(
                                      SettingConstants
                                              .ADVERTISEMENT_INFORMATION_LIST[
                                          index]["data"]["title"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        // color:  white
                                      )),
                                  Text(
                                      SettingConstants
                                              .ADVERTISEMENT_INFORMATION_LIST[
                                          index]["data"]["subTitle"],
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: SvgPicture.asset(
                                    SettingConstants
                                            .SECURITY_INFORMATION_LIST[index]
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Column(
                      children: [
                        // meta title
                        const Row(
                          children: [
                            Text(
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
                    listView: SizedBox(
                      height: 120,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: SettingConstants.POLICY_SUBTITLE.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                SettingConstants.POLICY_SUBTITLE[index]
                                    ["data"]!,
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
