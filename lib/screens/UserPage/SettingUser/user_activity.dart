import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_history_list.dart';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import '../../../theme/theme_manager.dart';

class UserActivityList extends ConsumerStatefulWidget {
  final dynamic data;
  final String? roleUser;
  final Function? handleChangeDependencies;
  const UserActivityList(
      {Key? key, this.data, this.roleUser, this.handleChangeDependencies})
      : super(key: key);

  @override
  ConsumerState<UserActivityList> createState() => _UserActivityListState();
}

class _UserActivityListState extends ConsumerState<UserActivityList> {
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
          "key": "user",
          "label": "Truy cập thông tin của bạn",
          "icon": "assets/icons/account_info.png",
        },
        {
          "key": "history",
          "label": "Nhật ký hoạt động",
          "icon": "assets/icons/account_info.png",
        },
        {
          "key": "supend",
          "label": "Vô hiệu hóa và xóa",
          "icon": "assets/icons/account_info.png",
        },
        {
          "key": "manage",
          "label": "Quản lý thông tin của bạn",
          "icon": "assets/icons/account_info.png",
        },
      ];
    });
  }

  void handlePress(key, context, index) {
    switch (key) {
      case 'user':
        _showUnavaliableDialog(context);
        break;
      case 'history':
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const UserHistoryList()));
        break;
      case 'supend':
        _showUnavaliableDialog(context);
        break;
      case 'manage':
        _showUnavaliableDialog(context);
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
        title: const AppBarTitle(title: 'Thông tin của bạn trên EMSO'),
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

  void _showUnavaliableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tính năng đang phát triển.Vui lòng thử lại sau!!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonPrimary(
                handlePress: () async {
                  Navigator.of(context).pop();
                },
                label: "OK",
              ),
            ],
          ),
        );
      },
    );
  }
}
