import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class DarkModeSetting extends StatefulWidget {
  const DarkModeSetting({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DarkModeSettingState createState() => _DarkModeSettingState();
}

class _DarkModeSettingState extends State<DarkModeSetting> {
  List options = [
    {"key": "light", "title": "Đang tắt"},
    {"key": "dark", "title": "Đang bật"},
    {"key": "system", "title": "Hệ thống"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    // updateDart(value) {
    //   SecureStorage().saveKeyStorage(value, 'theme');
    //   setState(() {
    //     modeTheme = value;
    //   });
    // }

    ThemeManager themeManager = Provider.of<ThemeManager>(context);
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(title: "Chế độ tối"),
            SizedBox(),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextDescription(
                description:
                    "Nếu bạn chọn hệ thống, chúng tôi sẽ tự động điều chỉnh giao diện theo phần cài đặt trên hệ thống thiết bị."),
          ),
          const SizedBox(height: 15),
          Column(
              children: List.generate(
                  options.length,
                  (index) => GestureDetector(
                        onTap: () async {
                          // updateDart(options[index]['key']);
                          var token =
                              await SecureStorage().getKeyStorage("token");
                          var newList =
                              await SecureStorage().getKeyStorage('dataLogin');
                          await SecureStorage().saveKeyStorage(
                              jsonEncode(jsonDecode(newList)
                                  .toList()
                                  .map((el) => el['token'] == token
                                      ? {...el, 'theme': options[index]['key']}
                                      : el)
                                  .toList()),
                              'dataLogin');

                          themeManager.toggleTheme(options[index]['key']);
                        },
                        child: Container(
                          width: size.width - 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        options[index]["title"].toString(),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      modeTheme == options[index]['key']
                                          ? const Icon(
                                              FontAwesomeIcons.check,
                                              color: primaryColor,
                                              size: 17,
                                            )
                                          : Container()
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  index != 2
                                      ? Divider(
                                          height: 1,
                                          color: Colors.grey.withOpacity(0.3),
                                        )
                                      : Container()
                                ],
                              )),
                        ),
                      ))),
        ],
      ),
    );
  }
}
