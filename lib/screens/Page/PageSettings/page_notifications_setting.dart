import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/providers/page/page_notification_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:provider/provider.dart' as pv;

class PageNotificationsSetting extends ConsumerStatefulWidget {
  final dynamic data;
  const PageNotificationsSetting({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageNotificationsSettingState();
}

class _PageNotificationsSettingState
    extends ConsumerState<PageNotificationsSetting> {
  PageNotificationState data = PageNotificationState();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    data = ref.watch(pageNotificationsControllerProvider);
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
                decoration: theme.isDarkMode
                    ? BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      )
                    : BoxDecoration(
                        color: Colors.white,
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
                    SectionListItem(
                        theme,
                        "Cho phép thông báo toàn cầu",
                        true,
                        "assets/pages/bell-solid.png",
                        data.global_notifications,
                        "global")
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: theme.isDarkMode
                    ? BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      )
                    : BoxDecoration(
                        color: Colors.white,
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
                    SectionListItem(
                        theme,
                        "Cho phép thông báo",
                        true,
                        "assets/pages/bell-solid.png",
                        data.allow_notifications,
                        "allow"),
                    data.allow_notifications == true
                        ? Wrap(
                            children: [
                              SectionListItem(
                                  theme,
                                  "Cho phép thông báo qua email",
                                  false,
                                  "assets/pages/email.png",
                                  data.allow_email_notifications,
                                  "email"),
                              SectionListItem(
                                  theme,
                                  "Cho phép thông báo qua sms",
                                  false,
                                  "assets/pages/reviewPost.png",
                                  data.allow_sms_notifications,
                                  "sms"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi người check in page",
                                  false,
                                  "assets/pages/boxArchives.png",
                                  data.new_page_checkin,
                                  "checkin"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi được nhắc tới",
                                  false,
                                  "assets/icons/save_icon.png",
                                  data.new_page_mention,
                                  "mention"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi có review mới",
                                  false,
                                  "assets/pages/star-solid.png",
                                  data.new_page_review,
                                  "review"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi có comment",
                                  false,
                                  "assets/images/comment_icon.png",
                                  data.new_post_comment,
                                  "comment"),
                              SectionListItem(
                                  theme,
                                  "Thông báo khi like mới",
                                  false,
                                  "assets/pages/thumbs-up-solid.png",
                                  data.new_like,
                                  "like"),
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

  Widget SectionListItem(theme, String title, bool isFirstItem, String image,
      bool checked, String type) {
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
            value: checked,
            onChanged: (value) async {
              switch (type) {
                case "global":
                  data.global_notifications = value;
                  break;
                case "email":
                  data.allow_email_notifications = value;
                  break;
                case "allow":
                  if (checked) {
                    await showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Bạn có chắc chắn không?'),
                        content: const Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Bạn có thể bỏ lỡ các thông báo quan trọng khi mọi người tương tác với Trang. Bạn vẫn sẽ nhìn thấy mọi thông báo trên Nhật Nhất Nhẫn Nhần Nhẩn EMSO khi truy cập vào Trang này.',
                                style:
                                    TextStyle(fontSize: 13, color: greyColor)),
                          ],
                        ),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Huỷ'),
                          ),
                          CupertinoDialogAction(
                            onPressed: () async {
                              Navigator.pop(context);
                              data.allow_notifications = value;
                            },
                            child: const Text('Xác nhận'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    data.allow_notifications = value;
                  }
                  break;
                case "sms":
                  data.allow_sms_notifications = value;
                  break;
                case "checkin":
                  data.new_page_checkin = value;
                  break;
                case "mention":
                  data.new_page_mention = value;
                  break;
                case "review":
                  data.new_page_review = value;
                  break;
                case "comment":
                  data.new_post_comment = value;
                  break;
                case "like":
                  data.new_like = value;
                  break;
              }
              await Future.delayed(Duration.zero);
              setState(() {
                PageApi().updateNotificationsPage({
                  "global_notifications": data.global_notifications,
                  "allow_notifications": data.allow_notifications,
                  "allow_email_notifications": data.allow_email_notifications,
                  "allow_sms_notifications": data.allow_sms_notifications,
                  "new_message": data.new_message,
                  "new_page_checkin": data.new_page_checkin,
                  "new_page_mention": data.new_page_mention,
                  "new_page_review": data.new_page_review,
                  "new_post_comment": data.new_post_comment,
                  "new_like": data.new_like,
                  "new_like_on_page_post": true,
                  "new_subscribers_to_event": true,
                  "new_followers_of_page": true
                }, widget.data["id"]);
              });
            },
          ),
        ],
      ),
    );
  }
}
