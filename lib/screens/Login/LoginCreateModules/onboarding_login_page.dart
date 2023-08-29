import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/user.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/providers/connectivity_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/setting_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import 'account_management.dart';
import 'begin_join_login_page.dart';
import 'main_login_page.dart';

// ignore: must_be_immutable
class OnboardingLoginPage extends ConsumerStatefulWidget {
  const OnboardingLoginPage({super.key});

  @override
  ConsumerState<OnboardingLoginPage> createState() =>
      _OnboardingLoginPageState();
}

class _OnboardingLoginPageState extends ConsumerState<OnboardingLoginPage> {
  late double width = 0;
  late double height = 0;
  List dataLogin = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        fetchDataLogin();
      });
    }
  }

  @override
  void dispose() {
    dataLogin = [];
    super.dispose();
  }

  fetchDataLogin() async {
    var newList = await SecureStorage().getKeyStorage('dataLogin');
    if (newList != null && newList != 'noData') {
      setState(() {
        dataLogin = jsonDecode(newList) ?? [];
      });
    }
  }

  void completeLogin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Home(),
      ),
    );
  }

  handleLogin(int index) async {
    final themeData = dataLogin[index]['theme'];
    final token = dataLogin[index]['token'];
    Future.delayed(Duration.zero, () async {
      final connectionStatus =
          ref.watch(connectivityControllerProvider).connectInternet;
      if (connectionStatus) {
        final response = await UserApi().getAccountSettingApiWithToken(token);
        // {status_code: 403, content: {error: Your login is currently disabled, type: suspended}}
        if (response == null || response['status_code'] == 403) {
          buildSnackBar(context, "Tài khoản của bạn đang bị vô hiệu hoá !!");
          return;
        }
      } else {
        buildSnackBar(context, "Không có kết nối mạng !!");
      }
      final theme = pv.Provider.of<ThemeManager>(context, listen: false);
      theme.toggleTheme(themeData);
      await SecureStorage().saveKeyStorage(token, 'token');
      await ref
          .read(meControllerProvider.notifier)
          .updateMedata(reversedList(dataLogin, index));
      completeLogin();
    });
  }

  List reversedList(List data, int index) {
    final result = data;
    final indexObj = data[index];
    result.removeAt(index);
    result.add(indexObj);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: CupertinoActivityIndicator(),
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    if (dataLogin.length > 1) {
                      pushToNextScreen(context, const AccountManagerment());
                    } else {
                      pushToNextScreen(context, const SettingLoginPage(0));
                    }
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  )),
            ],
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GestureDetector(
            onTap: (() {
              hiddenKeyboard(context);
            }),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // main content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Emso",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Social",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w700),
                                )
                              ]),
                          Center(
                            child: Wrap(
                                children: List.generate(
                                    dataLogin.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            if (dataLogin[index]['token'] !=
                                                null) {
                                              // context.loaderOverlay.show();
                                              handleLogin(index);
                                              // context.loaderOverlay.hide();
                                            } else {
                                              pushToNextScreen(
                                                  context,
                                                  MainLoginPage(
                                                      dataLogin[index]));
                                            }
                                          },
                                          child: Column(children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              margin: const EdgeInsets.only(
                                                  bottom: 5, right: 5, left: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: ImageCacheRender(
                                                  path: dataLogin[index]
                                                          ['show_url'] ??
                                                      linkAvatarDefault,
                                                  width: 99.8,
                                                  height: 99.8,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 100,
                                                child: Text(
                                                  dataLogin[index]['name'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ))
                                          ]),
                                        ))),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        minimumSize: const Size.fromHeight(47),
                                        backgroundColor: secondaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () {
                                      pushToNextScreen(
                                          context, const MainLoginPage(null));
                                    },
                                    child: const Text(
                                      OnboardingLoginConstants
                                          .ONBOARDING_LOGIN_LOGIN_WITH_DIFFERENCE_ACCOUNT,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                buildSpacer(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    pushToNextScreen(
                                        context, BeginJoinEmsoLoginPage());
                                  },
                                  child: const Text(
                                    OnboardingLoginConstants
                                        .ONBOARDING_LOGIN_SIGNIN_EMSO_ACCOUNT,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                buildSpacer(height: 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
