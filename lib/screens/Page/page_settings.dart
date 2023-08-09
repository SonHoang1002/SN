import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/providers/page/page_notification_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_role_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_settings_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/page_activity.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/page_followers_setting.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/page_general_setting.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/page_message_setting.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/page_notifications_setting.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/page_owner_setting.dart';
import 'package:social_network_app_mobile/screens/Page/PageSettings/page_role_setting.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import '../../../theme/theme_manager.dart';

class PageSettings extends ConsumerStatefulWidget {
  final dynamic data;
  final bool? rolePage;
  final Function? handleChangeDependencies;
  const PageSettings(
      {Key? key, this.data, this.rolePage, this.handleChangeDependencies})
      : super(key: key);

  @override
  ConsumerState<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends ConsumerState<PageSettings> {
  List<Map<String, dynamic>> pageEllipsis = [];

  @override
  void initState() {
    super.initState();
    updatePageEllipsis();
    getSettings();
  }

  Future<void> getSettings() async {
    var response = await PageApi().getSettingsPage(widget.data["id"]) ?? [];
    var pSettings = PageSettingsState(
        visitor_posts: response["visitor_posts"] ?? "",
        age_restrictions: response["age_restrictions"],
        cencored: widget.data["monitored_keywords"]);
    ref.read(pageSettingsControllerProvider.notifier).updateState(pSettings);
    ref
        .read(pageNotificationsControllerProvider.notifier)
        .getNotificationsPage(widget.data['id']);
    ref
        .read(pageRoleControllerProvider.notifier)
        .getInviteListPage(widget.data['id']);
    ref
        .read(pageRoleControllerProvider.notifier)
        .getAdminListPage(widget.data['id']);
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
          "key": "notification",
          "label": "Thông báo",
          "icon": "assets/groups/publish.png",
        },
        {
          "key": "role",
          "label": "Vai trò trên trang",
          "icon": "assets/groups/userActivity.png",
        },
        {
          "key": "admin",
          "label": "Chủ tài khoản Trang",
          "icon": "assets/icons/noti_market_update_order_icon.png",
        },
        {
          "key": "others",
          "label": "Người và trang khác",
          "icon": "assets/groups/groupActivity.png",
        },
        {
          "key": "activity",
          "label": "Nhật ký hoạt động",
          "icon": "assets/pages/activityLog.png",
        },
        {
          "key": "mailbox",
          "label": "Cài đặt hộp thư",
          "icon": "assets/pages/reviewPost.png",
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
                builder: (context) => PageGeneralSettings(data: widget.data)));
        break;
      case 'notification':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    PageNotificationsSetting(data: widget.data)));
        break;
      case 'role':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageRoleSettings(data: widget.data)));
        break;
      case 'admin':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageOwnerSetting(data: widget.data)));
        break;
      case 'others':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    PageFollowersSettings(data: widget.data)));
        break;
      case 'activity':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageActivity(
                      data: widget.data,
                    )));
        break;
      case 'mailbox':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageMessage(
                      data: widget.data,
                    )));
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
        title: const AppBarTitle(title: 'Cài đặt Trang và gắn thẻ'),
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
