import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/me_api.dart';
import 'package:social_network_app_mobile/apis/user.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/home/preview_screen.dart';
import 'package:social_network_app_mobile/providers/connectivity_provider.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/onboarding_login_page.dart';
import 'package:social_network_app_mobile/services/isar_post_service.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';

class TranferAccount extends ConsumerStatefulWidget {
  final List listLoginUser;
  const TranferAccount({Key? key, required this.listLoginUser})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TranferAccountState createState() => _TranferAccountState();
}

class _TranferAccountState extends ConsumerState<TranferAccount>
    with SingleTickerProviderStateMixin {
  var dataLogin = [];
  @override
  void initState() {
    if (!mounted) return;
    // SecureStorage().getKeyStorage('dataLogin').then((value) {
    //   if (value != 'noData') {
    //     setState(() {
    //       dataLogin = jsonDecode(value);
    //     });
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        dataLogin = widget.listLoginUser;
      });
    });
    super.initState();
  }

  void completeLogin() async {
    // await IsarPostService().resetPostIsar();
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) => const PreviewScreen(),
        ),
        ((route) => false));
  }

  handleLogin(token, themeData) async {
    final theme = pv.Provider.of<ThemeManager>(context, listen: false);
    theme.toggleTheme(themeData);
    await SecureStorage().saveKeyStorage(token, 'token');
    completeLogin();
  }

  handleTranferAccount(meData, index) async {
    if (meData[0]['username'] != dataLogin[index]['username']) {
      // bool isOK = true;
      // final connectionStatus =
      //     ref.read(connectivityControllerProvider).connectInternet;
      // if (connectionStatus) {
      //   final response = await MeApi().fetchDataMeApi();
      //   if (response?['status_code'] == 403) {
      //     buildSnackBar(context,
      //         "Tài khoản ${dataLogin[index]['username']} đang bị vô hiệu hoá !!");
      //     isOK = false;
      //   } else {
      //     isOK = true;
      //   }
      // }
      // if (isOK) {
      SecureStorage().deleteKeyStorage('theme');
      ref.read(postControllerProvider.notifier).reset();
      ref.read(momentControllerProvider.notifier).reset();
      ref.read(watchControllerProvider.notifier).reset();
      ref.read(watchControllerProvider.notifier).reset();
      ref.read(pageControllerProvider.notifier).reset();
      ref.read(friendControllerProvider.notifier).reset();
      ref.read(groupListControllerProvider.notifier).reset();
      ref.read(meControllerProvider.notifier).resetMeData();
      handleLogin(dataLogin[index]['token'], dataLogin[index]['theme']);
      // } else {
      //   Navigator.pop(context);
      // }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var meData = ref.watch(meControllerProvider);

    return SizedBox(
      height: 450,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: const AppBarTitle(title: "Chuyển tài khoản"),
          ),
          body: ListView.builder(
              itemCount: dataLogin.length,
              itemBuilder: (context, index) => InkWell(
                    onTap: () => handleTranferAccount(meData, index),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ))),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              AvatarSocial(
                                  width: 40,
                                  height: 40,
                                  path: dataLogin[index]['show_url'] ??
                                      linkAvatarDefault),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                dataLogin[index]['name'],
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, right: 8),
                            child: Icon(
                              meData[0]['username'] ==
                                      dataLogin[index]['username']
                                  ? FontAwesomeIcons.circleDot
                                  : FontAwesomeIcons.circle,
                              size: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))),
    );
  }
}
