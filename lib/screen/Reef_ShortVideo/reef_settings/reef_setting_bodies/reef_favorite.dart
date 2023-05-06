import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

List firstTitles = [
  "Bài viết của bạn bè và Trang trong mục yêu thích sẽ hiển thị ở vị trí cao hơn trong Bảng tin của bạn.",
  "Tim hiểu cách hoạt động của mục Yêu thích",
];
List secondTitles = [
  'Gợi ý theo hoạt động của bạn',
  'Hệ thống đữ ưu tiên hiển thị bài viết của các Trang và bạn bè này trong Bảng tin rồi. Hãy thêm vào mục yêu thích để ưu tiên bài viết hơn nữa nhé.',
  "Tìm hiểu lí do họ được ưu tiên"
];
List tabsTitles = ["Bạn bè", "Trang"];

class ReefFavorite extends StatefulWidget {
  const ReefFavorite({super.key});

  @override
  State<ReefFavorite> createState() => _ReefFavoriteState();
}

class _ReefFavoriteState extends State<ReefFavorite> {
  String _tabCurrent = tabsTitles[0];
  List<dynamic>? _selectionList;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      dynamic response = await FriendsApi().getListFriendsApi({"abc": "fssdf"});
      if (response != null) {
        _selectionList = response["data"];
        print("response ${json.encode(response)}");
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectionList ??= [];
    print("_selectionList ${_selectionList}");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          // first content
          buildSpacer(height: 7),
          _buildRichText(firstTitles[0], firstTitles[1]),
          buildSpacer(height: 7),
          // search input
          SearchInput(),
          // suggest title
          buildSpacer(height: 5),
          buildTextContent(
            secondTitles[0],
            true,
            fontSize: 18,
          ),
          buildSpacer(height: 7),
          // second title
          _buildRichText(secondTitles[1], secondTitles[2]),
          //tabs
          Expanded(child: _buildTabs())
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Column(
      children: [
        Row(
          children: tabsTitles
              .map((e) => InkWell(
                    onTap: () {
                      setState(() {
                        _tabCurrent = e;
                      });
                    },
                    child: SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            child: buildTextContent(e, true,
                                fontSize: 18, isCenterLeft: false),
                          ),
                          _tabCurrent == e
                              ? Container(color: red, width: 100, height: 2)
                              : const SizedBox(height: 2)
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
        buildDivider(color: greyColor),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 7),
            physics: const BouncingScrollPhysics(),
            child:
                // _selectionList == null
                //     ? buildCircularProgressIndicator()
                //     :
                _selectionList!.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: buildTextContent("Không có bạn bè", true,
                            fontSize: 17, isCenterLeft: false),
                      )
                    : Column(
                        children: _selectionList!
                            .map((e) => _buildSelectionWidget(e))
                            .toList()),
          ),
        )
      ],
    );
  }

  _buildRichText(String firstContent, String secondContent) {
    return RichText(
      text: TextSpan(
        text: firstContent,
        style: const TextStyle(color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
              text: secondContent,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSelectionWidget(dynamic data, {Function? function}) {
    dynamic _data = data ?? {};
    return GeneralComponent(
      [
        buildTextContent(
            _data["display_name"] ?? _data["username"] ?? "---", true,
            fontSize: 14),
        buildSpacer(height: 5),
        buildTextContent("Thông tin thêm", false,
            fontSize: 13, colorWord: greyColor)
      ],
      prefixWidget: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: _data["avatar_media"] != null
            ? Image.network(_data["avatar_media"]["url"])
            : Image.asset("assets/images/cat_1.png"),
      ),
      suffixWidget: const ButtonPrimary(
        label: "Thêm",
      ),
      suffixFlexValue: 8,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      changeBackground: transparent,
      function: () {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (ctx) => const InviteFriend()));
      },
    );
  }
}
