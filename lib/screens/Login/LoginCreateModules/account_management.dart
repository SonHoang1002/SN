import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/setting_login_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widgets/back_icon_appbar.dart';

// ignore: must_be_immutable
class AccountManagerment extends StatefulWidget {
  const AccountManagerment({super.key});

  @override
  State<AccountManagerment> createState() => _AccountManagerment();
}

class _AccountManagerment extends State<AccountManagerment> {
  late double width = 0;
  late double height = 0;
  List dataLogin = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchData() async {
    var newList = await SecureStorage().getKeyStorage('dataLogin');

    if (newList != null && newList != 'noData') {
      setState(() {
        dataLogin = jsonDecode(newList) ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackIconAppbar(),
                Container(
                  child: const Text("Quản lý trang cá nhân"),
                ),
                Container()
              ],
            ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Wrap(
                                  children: List.generate(
                                      dataLogin.length,
                                      (index) => GestureDetector(
                                            onTap: () {
                                              pushToNextScreen(context,
                                                  SettingLoginPage(index));
                                            },
                                            child: Column(children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                margin: const EdgeInsets.only(
                                                    bottom: 5,
                                                    right: 5,
                                                    left: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                          )))),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
