import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

import 'reef_setting_bodies/reef_favorite.dart';

List reefSelections = [
  {
    "key": "favorite",
    "icon": "assets/icons/star_favorite.png",
    "title": "Yêu thích",
    "content":
        "Thêm mọi người và Trang để ưu tiên bài viết của họ trong Bảng Feed."
  },
  {
    "key": "hide",
    "icon": "assets/icons/clock_favorite.png",
    "title": "Tạm ẩn",
    "content":
        "Tạm ẩn người, Trang và Nhóm để tạm thời dừng xem bài viết của họ."
  },
  {
    "key": "unfollow",
    "icon": "assets/icons/reject__favorite.png",
    "title": "Bỏ theo dõi",
    "content": "Bỏ theo dõi người, Trang và Nhóm để dừng xem bài viết của họ."
  },
  {
    "key": "reconnect",
    "icon": "assets/icons/plus_favorite.png",
    "title": "Kết nối lại",
    "content":
        "kết nối lại với những người, Trang và Nhóm mà bạn đã bỏ theo dõi"
  },
];

class ReefSettingMain extends StatefulWidget {
  const ReefSettingMain({
    Key? key,
  }) : super(key: key);

  @override
  State<ReefSettingMain> createState() => _ReefSettingMain1State();
}

class _ReefSettingMain1State extends State<ReefSettingMain> {
  handleChooseSelections(dynamic key) {
    Widget nextScreen;
    String title = "";
    if (key == "favorite") {
      nextScreen = const ReefFavorite();
      title = reefSelections[0]["title"];
    } else {
      nextScreen = const SizedBox();
    }

    pushToNextScreen(
        context,
        CreateModalBaseMenu(
            title: title, body: nextScreen, buttonAppbar: const SizedBox()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final bgColor =
        ThemeMode.dark == true ? blackColor.withOpacity(0.4) : greyColor[200];
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              buildSpacer(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(
                    width: 10,
                  ),
                  BackIconAppbar(),
                  SizedBox()
                ],
              ),
              buildSpacer(height: 20),
              Image.asset("assets/icon/logo_app.png", height: 30),
              buildSpacer(height: 15),
              buildTextContent("Có gì trong bảng Feed", true,
                  fontSize: 20, isCenterLeft: false),
              buildSpacer(height: 7),
              buildTextContent(
                  "Quản lý xem bạn sẽ nhìn thấy bài viết của ai trong Bảng Feed. Tìm hiểu cách hoạt động của Bảng Feed ",
                  false,
                  fontSize: 14,
                  isCenterLeft: false),
              buildSpacer(height: 15),
              Column(
                children: reefSelections.map((child) {
                  return GeneralComponent(
                    [
                      buildTextContent(child["title"], false, fontSize: 15),
                      buildSpacer(height: 4),
                      buildTextContent(child["content"], false,
                          fontSize: 12, colorWord: greyColor)
                    ],
                    prefixWidget: Image.asset(
                      child["icon"],
                      height: 20,
                      // ignore: unrelated_type_equality_checks
                      color: ThemeMode.dark == true ? white : blackColor,
                    ),
                    suffixWidget: const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 18,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                    changeBackground: transparent,
                    function: () {
                      handleChooseSelections(child["key"]);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          Container(
            color: bgColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTextContent("Nội dung này có hữu ích không", false,
                      fontSize: width > 400 ? 17 : 13),
                  Row(
                    children: [
                      const ButtonPrimary(
                        label: "Có",
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                      ),
                      buildSpacer(width: 10),
                      const ButtonPrimary(label: "Không"),
                    ],
                  )
                ]),
          )
        ],
      ),
    ));
  }
}
