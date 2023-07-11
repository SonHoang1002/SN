import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/tranfer_account.dart';
import 'package:social_network_app_mobile/home/PreviewScreen.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PreviewScreen(),
        ),
        ((route) => false));
  }

  handleLogin(token) async {
    await SecureStorage().saveKeyStorage(token, 'token');
    completeLogin();
  }

  handleTranferAccount(meData, index) {
    if (meData[0]['username'] != dataLogin[index]['username']) {
      SecureStorage().deleteKeyStorage('theme');

      ref.read(postControllerProvider.notifier).reset();
      ref.read(momentControllerProvider.notifier).reset();
      ref.read(watchControllerProvider.notifier).reset();
      ref.read(watchControllerProvider.notifier).reset();
      ref.read(pageControllerProvider.notifier).reset();
      ref.read(friendControllerProvider.notifier).reset();
      ref.read(groupListControllerProvider.notifier).reset();

      handleLogin(dataLogin[index]['token']);
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
