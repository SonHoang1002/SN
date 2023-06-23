import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class PageAction extends StatefulWidget {
  final dynamic data;
  const PageAction({super.key, this.data});

  @override
  State<PageAction> createState() => _PageActionState();
}

List actions = [
  {
    "key": "follow",
    "title": "Theo dõi",
    "subTitle": "Giúp mọi người dễ dàng theo dõi trang của bạn",
    "icon": "assets/pages/inviteFriend.png"
  },
  {
    "key": "message",
    "title": "Gửi tin nhắn",
    "subTitle": "Nhận tin nhắn trong hộp thư trong trang",
    "icon": "assets/pages/chat.png"
  },
  {
    "key": "register",
    "title": "Đăng ký",
    "subTitle":
        "Chọn trang web mà mọi người có thể đăng ký nhận thông báo của bạn",
    "icon": "assets/pages/edit.png"
  },
  {
    "key": "email",
    "title": "Gửi email",
    "subTitle":
        "Chọn địa chỉ email mà mọi người có thể dùng để liên hệ với bạn",
    "icon": "assets/pages/email.png"
  },
  {
    "key": "about",
    "title": "Tìm hiểu thêm",
    "subTitle": "Chọn trang web để mọi người có thể tìm hiểu về bạn",
    "icon": "assets/pages/circleWarning.png"
  },
];

class _PageActionState extends State<PageAction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const AppBarTitle(title: 'Chỉnh sửa nút hành động'),
        ),
        body: Column(
          children: [
            const Text(
                'Chọn hành động mà bạn muốn khách truy cập Trang thực hiện.'),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: actions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  horizontalTitleGap: 0,
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 0.0),
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: 0),
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Image.asset(actions[index]['icon'],
                        width: 20,
                        height: 20,
                        color: theme.isDarkMode ? Colors.white : Colors.black),
                  ),
                  title: Text(actions[index]['title']),
                  subtitle: Text(actions[index]['subTitle']),
                  trailing: widget.data['button_key'] == actions[index]['key']
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {},
                );
              },
            )
          ],
        ));
  }
}
