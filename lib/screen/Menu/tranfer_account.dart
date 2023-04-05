import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/tranfer_account.dart';
import 'package:social_network_app_mobile/home/PreviewScreen.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class TranferAccount extends ConsumerStatefulWidget {
  const TranferAccount({Key? key}) : super(key: key);

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
    SecureStorage().getKeyStorage('dataLogin').then((value) {
      if (value != 'noData') {
        setState(() {
          dataLogin = jsonDecode(value);
        });
      }
    });
    super.initState();
  }

  void completeLogin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const PreviewScreen(),
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
    var meData = ref.watch(meControllerProvider);

    return SizedBox(
      height: 400,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Column(
              children: [
                const AppBarTitle(title: "Chuyển tài khoản"),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 0.2,
                  width: size.width,
                  color: greyColor,
                )
              ],
            )),
        body: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            children: List.generate(
                dataLogin.length,
                (index) => InkWell(
                      onTap: () {
                        if (meData[0]['username'] !=
                            dataLogin[index]['username']) {
                          SecureStorage().deleteKeyStorage('theme');
                          handleLogin(dataLogin[index]['token']);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                AvatarSocial(
                                    width: 36,
                                    height: 36,
                                    path: dataLogin[index]['show_url'] ??
                                        linkAvatarDefault),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  dataLogin[index]['name'],
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, right: 8),
                              child: Icon(
                                meData[0]['username'] ==
                                        dataLogin[index]['username']
                                    ? FontAwesomeIcons.circleDot
                                    : FontAwesomeIcons.circle,
                                size: 16,
                                color: secondaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
