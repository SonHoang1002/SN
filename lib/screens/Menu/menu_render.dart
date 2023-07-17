import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screens/Menu/menu_selected.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';

import '../MarketPlace/screen/main_market_page.dart';

class MenuRender extends StatelessWidget {
  const MenuRender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);

    handlePress(menu) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => menu['key'] == 'moment'
                  ? const Moment(isBack: true)
                  : menu["key"] == "marketPlace"
                      ? const MainMarketPage(true)
                      : MenuSelected(
                          menuSelected: menu,
                        )));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Menu của bạn",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
            shrinkWrap: true,
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 2,
                childAspectRatio: 3.6),
            itemCount: listSocial.length,
            itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: theme.isDarkMode
                          ? Theme.of(context).cardColor
                          : const Color(0xfff1f2f5),
                      border: Border.all(width: 0.1, color: greyColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      handlePress(listSocial[index]);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        listSocial[index]['icon'].contains('svg')
                            ? SvgPicture.asset(
                                listSocial[index]['icon'],
                                width: 19.4,
                              )
                            : Image.asset(
                                listSocial[index]['icon'],
                                width: 21.4,
                                height: 21.4,
                              ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listSocial[index]['label'],
                              style: const TextStyle(
                                  fontSize: 13.3, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
      ],
    );
  }
}
