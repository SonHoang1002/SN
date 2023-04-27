import 'package:badges/badges.dart' as ChipNoti;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screen/Menu/tranfer_account.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/user_item.dart';

class MenuUser extends ConsumerWidget {
  const MenuUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = pv.Provider.of<ThemeManager>(context);
    var meData = ref.read(meControllerProvider)[0];

    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(),
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
            UserItem(
                user: ref.watch(meControllerProvider)[0],
                subText: 'Xem trang cá nhân của bạn'),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15))),
                    builder: (BuildContext context) {
                      return const TranferAccount();
                    });
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChipNoti.Badge(
                    badgeContent: const Text('2',
                        style: TextStyle(color: white, fontSize: 13)),
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
    );
  }
}
