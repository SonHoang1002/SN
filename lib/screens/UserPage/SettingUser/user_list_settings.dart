import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/public_post_setting.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_activity.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_change_password.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_general_settings.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_tag_settings.dart';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import '../../../theme/theme_manager.dart';

class UserSettings extends ConsumerStatefulWidget {
  final dynamic data;
  final String? roleUser;
  final Function? handleChangeDependencies;
  const UserSettings(
      {Key? key, this.data, this.roleUser, this.handleChangeDependencies})
      : super(key: key);

  @override
  ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
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
          "key": "general",
          "label": "Chung",
          "icon": "assets/groups/settingGroup.png",
        },
        {
          "key": "security",
          "label": "Bảo mật và đăng nhập",
          "icon": "assets/icons/Shield.png",
        },
        {
          "key": "info",
          "label": "Thông tin bạn trên Emso",
          "icon": "assets/icons/account_info.png",
        },
        {
          "key": "tag",
          "label": "Trang cá nhân và gắn thẻ",
          "icon": "assets/icons/tag.png",
        },
        {
          "key": "public",
          "label": "Bài viết công khai",
          "icon": "assets/groups/publish.png",
        },
        {
          "key": "block",
          "label": "Chặn",
          "icon": "assets/groups/private.png",
        },
        {
          "key": "money",
          "label": "Bật kiếm tiền",
          "icon": "assets/icons/noti_market_wallet_icon.png",
        },
      ];
    });
  }

  void handlePress(key, context, index) {
    switch (key) {
      case 'general':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => UserGeneralSettings(
                      data: widget.data,
                    )));
        break;
      case 'security':
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const PasswordChange()));
        break;
      case 'info':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => UserActivityList(
                      data: widget.data,
                    )));
        break;
      case 'tag':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => UserTagSetting(data: widget.data)));
        break;
      case 'public':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PublicPostSetting(data: widget.data)));

        break;
      case 'block':
        break;
      case 'money':
        /* Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageMessage(
                      data: widget.data,
                    ))); */
        break;
      default:
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
        title: const AppBarTitle(title: 'Cài đặt tài khoản chung'),
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
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
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
