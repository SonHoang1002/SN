import 'dart:convert';

import 'package:badges/badges.dart' as ChipNoti;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/Menu/tranfer_account.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/user_item.dart';

class MenuUser extends ConsumerStatefulWidget {
  const MenuUser({super.key});

  @override
  ConsumerState<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends ConsumerState<MenuUser> {
  ValueNotifier<List?> listLoginUser = ValueNotifier(null);
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await SecureStorage().getKeyStorage('dataLogin').then((value) {
        if (value != 'noData') {
          listLoginUser.value = jsonDecode(value);
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    var meData = ref.read(meControllerProvider)[0];
    return meData != null
        ? InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserPageHome(),
                  settings: RouteSettings(
                    arguments: {'id': meData['id']},
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: theme.isDarkMode
                      ? Theme.of(context).cardColor
                      : const Color(0xfff1f2f5),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserItem(user: meData, subText: 'Xem trang cá nhân của bạn'),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15))),
                          builder: (BuildContext context) {
                            return TranferAccount(
                              listLoginUser: listLoginUser.value!,
                            );
                          });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChipNoti.Badge(
                          badgeContent: Text(
                              listLoginUser.value != null
                                  ? (listLoginUser.value!.length >= 10
                                          ? "9+"
                                          : listLoginUser.value!.length)
                                      .toString()
                                  : "0",
                              style:
                                  const TextStyle(color: white, fontSize: 12)),
                          child: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: greyColor,
                            size: 25,
                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
