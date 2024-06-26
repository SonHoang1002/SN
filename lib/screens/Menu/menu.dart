import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Menu/menu_user.dart';
import 'package:social_network_app_mobile/screens/Setting/setting.dart';
import 'package:social_network_app_mobile/services/isar_post_service.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

import '../../helper/push_to_new_screen.dart';
import '../Login/LoginCreateModules/onboarding_login_page.dart';
import '../Search/search.dart';
import '../Setting/darkmode_setting.dart';
import 'menu_render.dart';
import 'menu_shortcut.dart';
import 'package:provider/provider.dart' as pv;

class Menu extends ConsumerStatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    final size = MediaQuery.sizeOf(context);

    List iconAction = [
      {
        "icon": Icons.settings,
        'type': 'icon',
        "action": () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const Setting()));
        }
      },
      {
        "icon": Icons.dark_mode,
        'type': 'icon',
        "action": () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const DarkModeSetting()));
        }
      },
      {
        "icon": Icons.search,
        'type': 'icon',
        "action": () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              // builder: (context) => const Setting(),
              builder: (context) => const Search(),
            ),
          );
        }
      },
    ];

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
        pushAndRemoveUntil(context, const OnboardingLoginPage());
      }
    }

    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 6,
                  ),
                  AppBarTitle(title: 'Menu'),
                ]),
            Row(
              children: List.generate(
                  iconAction.length,
                  (index) => GestureDetector(
                        onTap: () {
                          iconAction[index]['action']();
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.3)),
                            child: Icon(
                              iconAction[index]['icon'],
                              size: 20,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color,
                            )),
                      )),
            )
          ],
        ),
      ),
      body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const MenuUser(),
                const SizedBox(
                  height: 8,
                ),
                const CrossBar(
                  height: 1,
                ),
                const SizedBox(
                  height: 15,
                ),
                const MenuShortcut(),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 0.3,
                  decoration: const BoxDecoration(color: greyColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                const MenuRender(),
                Container(
                  height: 0.3,
                  decoration: const BoxDecoration(color: greyColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: size.width - 40,
                  height: 40, // <-- match_parent
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: const Color(0xffdcdcdc)),
                      onPressed: () {
                        logout();
                      },
                      child: const Text(
                        "Đăng xuất",
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
