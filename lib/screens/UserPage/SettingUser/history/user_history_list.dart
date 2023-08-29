import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/history/user_group_history.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/history/user_like_pages_history.dart';

import 'package:social_network_app_mobile/screens/UserPage/SettingUser/history/user_search_history.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/history/user_watch_history.dart';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class UserHistoryList extends ConsumerStatefulWidget {
  final dynamic data;
  final String? roleUser;
  final Function? handleChangeDependencies;
  const UserHistoryList(
      {Key? key, this.data, this.roleUser, this.handleChangeDependencies})
      : super(key: key);

  @override
  ConsumerState<UserHistoryList> createState() => _UserHistoryListState();
}

class _UserHistoryListState extends ConsumerState<UserHistoryList> {
  List<Map<String, dynamic>> pageEllipsis = [];

  @override
  void initState() {
    super.initState();
    updatePageEllipsis();
  }

  void updatePageEllipsis() {
    setState(() {
      pageEllipsis = [
        {
          "key": "watch",
          "label": "Lịch sử xem bài viết",
          "icon": "assets/pages/search.png",
        },
        {
          "key": "search",
          "label": "Lịch sử tìm kiếm",
          "icon": "assets/pages/search.png",
        },
        {
          "key": "group",
          "label": "Nhóm bạn đã tìm kiếm",
          "icon": "assets/groups/groupActivity.png",
        },
        {
          "key": "page",
          "label": "Trang, lượt thích Trang và sở thích",
          "icon": "assets/pages/thumbs-up-solid.png",
        },
      ];
    });
  }

  void handlePress(key, context, index) {
    switch (key) {
      case 'watch':
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const UserWatchHistory()));
        break;
      case 'search':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const UserSearchHistory()));

        break;
      case 'group':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const UserGroupSearchHistory()));
        break;
      case 'page':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const UserLikePagesHistory()));
        break;
      default:
        break;
    }
  }

  widgetRenderText(String value) {
    return RichText(
      text: TextSpan(
        text: '\u2022 ',
        style: const TextStyle(fontSize: 14, color: greyColor),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontSize: 12, color: greyColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Bài viết của bạn'),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.angleLeft,
            size: 18,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      body: Container(
        height: double.infinity,
        color: theme.isDarkMode
            ? MyThemes.darkTheme.canvasColor
            : Colors.grey.withOpacity(0.5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CrossBar(
                height: 7,
                margin: 0,
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: pageEllipsis.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          index == 0
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0.0),
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            horizontalTitleGap: 0,
                            dense: true,
                            leading: Image.asset(pageEllipsis[index]['icon'],
                                width: 20,
                                height: 20,
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                            title: Text(pageEllipsis[index]['label']),
                            onTap: () {
                              handlePress(
                                  pageEllipsis[index]['key'], context, index);
                            },
                          ),
                          index == pageEllipsis.length - 1
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          Divider(
                            height: index == pageEllipsis.length - 1 ? 0 : 20,
                            indent: 0,
                            thickness: 1,
                          ),
                          index == pageEllipsis.length - 1
                              ? const CrossBar(
                                  height: 7,
                                  margin: 0,
                                )
                              : Container(),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
