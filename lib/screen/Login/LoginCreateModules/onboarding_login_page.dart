import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import 'begin_join_login_page.dart';
import 'main_login_page.dart';

// ignore: must_be_immutable
class OnboardingLoginPage extends StatefulWidget {
  const OnboardingLoginPage({super.key});

  @override
  State<OnboardingLoginPage> createState() => _OnboardingLoginPageState();
}

class _OnboardingLoginPageState extends State<OnboardingLoginPage> {
  late double width = 0;
  late double height = 0;
  List dataLogin = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      fetchDataLogin();
    }
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
    context.loaderOverlay.hide();
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Home(),
      ),
    );
  }

  handleLogin(token) async {
    await SecureStorage().saveKeyStorage(token, 'token');
    completeLogin();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: CupertinoActivityIndicator(),
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
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
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Image.asset(LoginConstants.PATH_IMG + "cat_1.png"),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            // borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Image.asset(
                              LoginConstants.PATH_IMG + "avatar_img.png"),
                        ),
                        buildTextContent(
                            OnboardingLoginConstants.ONBOARDING_LOGIN_USERNAME,
                            true,
                            fontSize: 16,
                            colorWord: Colors.black,
                            isCenterLeft: false)
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pushToNextScreen(context, SettingLoginPage());
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                // color: Colors.grey[900],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Icon(
                              FontAwesomeIcons.gear,
                              color: blackColor,
                            ),
                          ),
                        ),
                        buildSpacer(height: 20),
                        buildTextContent(
                            OnboardingLoginConstants
                                .ONBOARDING_LOGIN_LOGIN_WITH_DIFFERENCE_ACCOUNT,
                            true,
                            fontSize: 15,
                            colorWord: blackColor,
                            isCenterLeft: false, function: () {
                          pushToNextScreen(context, MainLoginPage());
                        }),
                        buildSpacer(height: 20),
                        buildTextContent(
                            OnboardingLoginConstants
                                .ONBOARDING_LOGIN_SIGNIN_EMSO_ACCOUNT,
                            true,
                            fontSize: 15,
                            colorWord: blackColor,
                            isCenterLeft: false, function: () {
                          pushToNextScreen(context, BeginJoinEmsoLoginPage());
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
