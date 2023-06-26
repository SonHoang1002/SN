import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/textfield_edit_page.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class PageAction extends ConsumerStatefulWidget {
  final dynamic data;
  final Function? handleChangeDependencies;
  const PageAction({super.key, this.data, this.handleChangeDependencies});

  @override
  ConsumerState<PageAction> createState() => _PageActionState();
}

List actions = [
  {
    "key": "follow",
    "title": "Theo dõi",
    "subTitle": "Giúp mọi người dễ dàng theo dõi trang của bạn",
    "icon": "assets/pages/inviteFriend.png"
  },
  {
    "key": "messenger",
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

class _PageActionState extends ConsumerState<PageAction> {
  String isActiveAction = '';
  String buttonValue = '';

  @override
  void initState() {
    if (widget.data['button_key'] != null) {
      isActiveAction = widget.data['button_key'];
    }
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  handlePress(data, context) async {
    var buttonValue = widget.data['button_value'];

    switch (data) {
      case 'register':
        showBarModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (context) => TextFieldEdit(
            label: "Đăng ký",
            field: 'register',
            initialValue: buttonValue ?? "",
            onChange: (value) => handleCallApi(value, data),
          ),
        );
        break;
      case 'email':
        showBarModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (context) => TextFieldEdit(
            label: "Email",
            validateInput: (value) {
              final regex = RegExp(
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
                  r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.'
                  r'[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
              if (value.isEmpty) {
                return false;
              }
              if (!regex.hasMatch(value)) {
                return true;
              }
              return false;
            },
            field: 'email',
            initialValue: buttonValue ?? "",
            onChange: (value) => handleCallApi(value, data),
          ),
        );
        break;
      case 'about':
        showBarModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (context) => TextFieldEdit(
            label: "Tìm hiểu thêm",
            field: 'about',
            initialValue: buttonValue ?? "",
            onChange: (value) => handleCallApi(value, data),
          ),
        );
        break;
      default:
        setState(() {
          isActiveAction = data;
        });
        var res = await PageApi().pagePostMedia(
          {
            "button_key": data,
          },
          widget.data['id'],
        );
        if (res != null) {
          widget.handleChangeDependencies!(res);
          ref.read(pageControllerProvider.notifier).updateMedata(res);
        }
    }
  }

  void handleCallApi(value, data) async {
    if (value != null) {
      setState(() {
        buttonValue = value;
        isActiveAction = data;
      });
      var res = await PageApi().pagePostMedia(
        {
          "button_key": data,
          "button_value": value,
        },
        widget.data['id'],
      );
      if (res != null) {
        widget.handleChangeDependencies!(res);
        ref.read(pageControllerProvider.notifier).updateMedata(res);
      }
    }
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
                      horizontal: 12.0, vertical: 0.0),
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: 0),
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Image.asset(actions[index]['icon'],
                        width: 20,
                        height: 20,
                        color: theme.isDarkMode ? Colors.white : Colors.black),
                  ),
                  title: Text(
                    actions[index]['title'],
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    actions[index]['subTitle'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isActiveAction == actions[index]['key']
                      ? const Icon(Icons.check, color: Colors.blue, size: 15)
                      : const SizedBox(width: 5),
                  onTap: () => handlePress(actions[index]['key'], context),
                );
              },
            )
          ],
        ));
  }
}
