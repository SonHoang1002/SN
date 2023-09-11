import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/config.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/history/user_history_list.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/unavailable_dialog.dart';
import 'package:social_network_app_mobile/storage/storage.dart';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../theme/theme_manager.dart';

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
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
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
          "icon": "assets/groups/userActivity.png",
        },
        {
          "key": "history",
          "label": "Nhật ký hoạt động",
          "icon": "assets/groups/scheduledStatus.png",
        },
        {
          "key": "supend",
          "label": "Vô hiệu hóa và xóa",
          "icon": "assets/groups/canSpam.png",
        },
        {
          "key": "manage",
          "label": "Quản lý thông tin của bạn",
          "icon": "assets/groups/centerHelper.png",
        },
      ];
    });
  }

  void handlePress(key, context, index) {
    switch (key) {
      case 'user':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const UnavailableDialog(); // Sử dụng lớp UnavailableDialog ở đây
          },
        );
        break;
      case 'history':
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const UserHistoryList()));
        break;
      case 'supend':
        _showSuspendDialog(context);
        break;
      case 'manage':
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: WebView(
                initialUrl: '$linkSocialNetwork/help',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  controller.complete(webViewController);
                },
              ),
            ),
          ),
        );
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

  void _showSuspendDialog(BuildContext context) {
    logout() async {
      ref.read(postControllerProvider.notifier).reset();
      ref.read(momentControllerProvider.notifier).reset();
      ref.read(watchControllerProvider.notifier).reset();
      ref.read(watchControllerProvider.notifier).reset();
      ref.read(pageControllerProvider.notifier).reset();
      ref.read(friendControllerProvider.notifier).reset();
      ref.read(groupListControllerProvider.notifier).reset();
      // await IsarPostService().resetPostIsar();

      final theme = pv.Provider.of<ThemeManager>(context, listen: false);
      theme.toggleTheme('system');
      await SecureStorage().deleteKeyStorage('token');
      // ???? why after change value of token still is old token , not noData ????
      await SecureStorage().deleteKeyStorage("userId");
      await SecureStorage().deleteKeyStorage('theme');
      await SecureStorage().saveKeyStorage("token", "noData");
      ref.read(meControllerProvider.notifier).resetMeData();
      if (mounted) {
        pushAndReplaceToNextScreen(context, const OnboardingLoginPage());
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(25.0),
          title: const Text('Vô hiệu hóa hoặc xóa tài khoản Emso'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nếu muốn tạm ngừng sử dụng Emso, bạn có thể vô hiệu hóa tài khoản.Còn nếu muốn xóa vĩnh viễn tài khoản Emso, hãy cho chúng tôi biết nhé.',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: greyColor),
                    borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  title: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vô hiệu hóa tài khoản',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Đây có thể là hành động tạm thời',
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Hệ thống sẽ vô hiệu hóa tài khoản, cũng như gỡ tên và ảnh của bạn khỏi hầu hết những gì bạn đã chia sẻ.Bạn có thể tiếp tục dùng Messenger.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  leading: Radio(
                    value: 1,
                    activeColor: Colors.blue,
                    groupValue: 1,
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonPrimary(
                    handlePress: () async {
                      UserPageApi().suspendUser();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("vô hiệu hoá thành công"),
                        duration: Duration(seconds: 3),
                      ));
                      await Future.delayed(const Duration(seconds: 1));
                      logout();
                    },
                    label: "Tiếp tục vô hiệu hoá tài khoản",
                  ),
                  ButtonPrimary(
                    isGrey: true,
                    handlePress: () async {
                      Navigator.of(context).pop();
                    },
                    label: "Huỷ",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
