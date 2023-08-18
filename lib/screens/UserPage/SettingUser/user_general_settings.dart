import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';

import 'package:social_network_app_mobile/providers/UserPage/user_information_provider.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/textfield_settings_user.dart';

import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class UserGeneralSettings extends ConsumerStatefulWidget {
  final dynamic data;
  const UserGeneralSettings({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserGeneralSettingsState();
}

class _UserGeneralSettingsState extends ConsumerState<UserGeneralSettings> {
  dynamic editUser;
  dynamic daysDifference;
  String formattedDate = "";
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    var userAbout = ref.read(userInformationProvider).userMoreInfor;
    editUser = {
      "display_name": userAbout['display_name'],
      "username": userAbout['username'],
      "phone_number": userAbout['general_information']["phone_number"],
      "identity":
          "Xác nhận danh tính của bạn để làm những việc như chạy quảng cáo,bầu cử hoặc chính trị",
      "email": userAbout["email"],
    };
    if (userAbout['update_display_name_at'] != null) {
      DateTime currentDate = DateTime.now();
      var targetDate = DateTime.parse(userAbout['update_display_name_at']);
      final difference = currentDate.difference(targetDate);
      daysDifference = difference.inDays;
      formattedDate = DateFormat("dd 'tháng' MM, yyyy").format(targetDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Cài đặt tài khoản chung'),
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tên',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title:
                        Text("${editUser?['display_name'] ?? ""}", maxLines: 2),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => TextFieldSettingsUser(
                                label: "Họ và Tên",
                                field: 'display_name',
                                initialValue: editUser?['display_name'],
                                warningText: daysDifference != null &&
                                        daysDifference <= 60
                                    ? "Bạn không thể đổi tên trên Emso ngay lúc này vì bạn đã đổi tên trong 60 ngày qua.Bạn vẫn có thể thay đổi thứ tự tên."
                                    : null,
                                lastChangedDate: daysDifference != null &&
                                        daysDifference <= 60
                                    ? "Lần gần nhất bạn đổi tên là vào $formattedDate."
                                    : null,
                                hintText:
                                    "Nếu đổi tên trên EMSO, bạn không thể đổi lại trong 60 ngày.",
                                title: "Họ và Tên",
                                onChange: (value) async {
                                  FormData formData =
                                      FormData.fromMap({"display_name": value});
                                  var res = await UserPageCredentical()
                                      .updateCredentialUser(formData);
                                  if (res?["success"] == true && res != null) {
                                    ref
                                        .read(userInformationProvider.notifier)
                                        .setNewDisplayName(value);
                                    setState(() {
                                      if (value != "" && value != null) {
                                        editUser['display_name'] = value;
                                      }
                                    });
                                  }
                                })),
                      );
                    },
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Text('Tên người dùng',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "${editUser?['username'] ?? ""}",
                      maxLines: 2,
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => TextFieldSettingsUser(
                                label: "Tên người dùng",
                                field: 'username',
                                initialValue: editUser?['username'],
                                title: "Tên người dùng",
                                warningText: daysDifference != null &&
                                        daysDifference <= 60
                                    ? "Sau 60 ngày mới có thể đổi tên."
                                    : null,
                                validateInput: (value) async {
                                  var response = await UserPageCredentical()
                                      .checkUsername({"username": value});
                                  if (response != null) {
                                    return false;
                                  } else {
                                    return true;
                                  }
                                },
                                hintText:
                                    "Tên người dùng của bạn phải có tên thật.",
                                onChange: (value) async {
                                  FormData formData =
                                      FormData.fromMap({"username": value});
                                  var res = await UserPageCredentical()
                                      .updateCredentialUser(formData);
                                  if (res?["success"] == true) {
                                    ref
                                        .read(userInformationProvider.notifier)
                                        .setNewUsername(value);
                                    setState(() {
                                      if (value != "" && value != null) {
                                        editUser['username'] = value;
                                      }
                                    });
                                  }
                                })),
                      );
                    },
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Text('Số điện thoại',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title:
                        Text("${editUser?['phone_number'] ?? ""}", maxLines: 2),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => TextFieldSettingsUser(
                                label: "Số điện thoại",
                                field: 'phone_number',
                                initialValue: editUser?['phone_number'],
                                keyboardType: TextInputType.number,
                                title: "Chỉnh sửa số điện thoại",
                                validateInput: (value) {
                                  final regex =
                                      RegExp(r"^(0)?[1-9][0-9]{8,9}$");
                                  if (value.isEmpty) {
                                    return false;
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return true;
                                  }
                                  return false;
                                },
                                hintText:
                                    "Khi nhập số điện thoại, bạn có thể đặt lại mật khẩu dễ dàng và nhận thông báo qua SMS. Nhờ đó, chúng tôi cũng có thể gợi ý bạn bè, cung cấp cũng như cải thiện quảng cáo cho bạn và những người khác.",
                                onChange: (value) async {
                                  var res = await UserPageApi()
                                      .updateOtherInformation(
                                          null, {"phone_number": value});
                                  if (res != null) {
                                    setState(() {
                                      ref
                                          .read(
                                              userInformationProvider.notifier)
                                          .setUserNewPhone(res);
                                      if (value != "" && value != null) {
                                        editUser['phone_number'] = value;
                                      }
                                    });
                                  }
                                })),
                      );
                    },
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Text('Xác nhận danh tính',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "${editUser?['identity'] ?? ""}",
                      maxLines: 2,
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Text('Liên hệ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Email: ${editUser?['email'] ?? ""}",
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
