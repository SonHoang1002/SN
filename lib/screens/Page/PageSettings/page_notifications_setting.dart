import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:provider/provider.dart' as pv;

class PageNotificationsSetting extends ConsumerStatefulWidget {
  final dynamic data;
  List arr = [];
  PageNotificationsSetting({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageNotificationsSettingState();
}

class _PageNotificationsSettingState
    extends ConsumerState<PageNotificationsSetting> {
  List arr = [];
  var _switchValue = false;
  var _switchValue2 = false;
  List test = [];
  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Thông báo'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SectionTitle(
                        theme,
                        "Cài đặt thông báo toàn cầu",
                        "Bạn có thể tắt mọi thông báo hoặc giới hạn những thông báo mà bạn muốn nhận.",
                        "assets/pages/activityLog.png"),
                    SectionListItem(theme, "Thông báo khi like mới", true,
                        "assets/pages/bell-solid.png")
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SectionTitle(
                        theme,
                        "Tương tác với trang",
                        "Đây là những thông báo bạn nhận được khi có người tương tác với Trang của bạn.",
                        "assets/pages/thumbs-up-solid.png"),
                    SectionListItem(theme, "Cho phép thông báo", true,
                        "assets/pages/bell-solid.png"),
                    _switchValue
                        ? Wrap(
                            children: [
                              SectionListItem(
                                  theme,
                                  "Cho phép thông báo qua email",
                                  false,
                                  "assets/pages/email.png"),
                              SectionListItem(
                                  theme,
                                  "Cho phép thông báo qua sms",
                                  false,
                                  "assets/pages/reviewPost.png"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi người check in page",
                                  false,
                                  "assets/pages/boxArchives.png"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi được nhắc tới",
                                  false,
                                  "assets/icons/save_icon.png"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi có review mới",
                                  false,
                                  "assets/pages/star-solid.png"),
                              SectionListItem(theme, "Thông báo khi có comment",
                                  false, "assets/images/comment_icon.png"),
                              SectionListItem(theme, "Thông báo khi like mới",
                                  false, "assets/pages/thumbs-up-solid.png"),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  Widget SectionTitle(theme, String title, String subtitle, String image) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          image,
          width: 20,
          height: 20,
          color: theme.isDarkMode ? Colors.white : Colors.black,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget SectionListItem(theme, String title, bool isFirstItem, String image) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      margin: !isFirstItem ? const EdgeInsets.only(left: 16) : null,
      decoration: BoxDecoration(
        border: !isFirstItem
            ? const Border(
                bottom: BorderSide(
                  color: greyColor,
                  width: 1.0,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            width: 20,
            height: 20,
            color: theme.isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CupertinoSwitch(
            value: isFirstItem ? _switchValue : _switchValue2,
            onChanged: (value) {
              setState(() {
                if (isFirstItem) {
                  _switchValue = value;
                } else {
                  _switchValue2 = value;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
