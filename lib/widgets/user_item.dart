import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/connectivity_provider.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/blue_certified_widget.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

import '../screens/UserPage/user_page.dart';

class UserItem extends ConsumerWidget {
  final dynamic user;
  final String? subText;
  const UserItem({Key? key, this.user, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        var status = ref.watch(connectivityControllerProvider).connectInternet;
        if (status == true) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const UserPageHome(),
                settings: RouteSettings(
                  arguments: {'id': user['id'].toString(), "user": user},
                ),
              ));
        } else {
          popToPreviousScreen(context);
          buildSnackBar(context, "Mạng của bạn không ổn định");
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarSocial(
              width: 40,
              height: 40,
              object: user,
              path: user?['avatar_media']?['preview_url'] ??
                  user?['show_url'] ??
                  linkAvatarDefault),
          const SizedBox(
            width: 7,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    user?['display_name'] ?? user?['name'] ?? 'Không xác định',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  user?["certified"] == true
                      ? buildBlueCertifiedWidget()
                      : const SizedBox()
                ],
              ),
              !['', null].contains(subText)
                  ? Container(
                      margin: const EdgeInsets.only(top: 4.0),
                      child: TextDescription(description: subText ?? ''))
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
