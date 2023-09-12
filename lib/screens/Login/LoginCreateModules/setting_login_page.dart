import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/main_login_page.dart';

import '../../../constant/common.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../storage/storage.dart';
import '../../../theme/colors.dart';
import '../../../widgets/back_icon_appbar.dart';
import 'onboarding_login_page.dart';

class SettingLoginPage extends StatefulWidget {
  final index;
  const SettingLoginPage(this.index, {super.key});

  @override
  State<SettingLoginPage> createState() => _SettingLoginPageState();
}

class _SettingLoginPageState extends State<SettingLoginPage> {
  List dataLogin = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      fetchDataLogin();
    }
  }

  fetchDataLogin() async {
    var newList = await SecureStorage().getKeyStorage('dataLogin');

    if (newList != null && newList != 'noData') {
      setState(() {
        dataLogin = jsonDecode(newList) ?? [];
      });
    }
  }

  /// return status of dataLogin
  Future<bool> deleteData(index) async {
    const secureStorage = FlutterSecureStorage();

    // Đọc mảng từ "dataLogin"
    String? value = await secureStorage.read(key: "dataLogin");
    if (value != null) {
      // Giải mã giá trị JSON
      var data = jsonDecode(value) as List<dynamic>;

      // Xóa phần tử tại vị trí cụ thể trong mảng
      int indexToRemove = index; // Ví dụ xóa phần tử thứ 3
      data.removeAt(indexToRemove);

      // Mã hóa lại và lưu lại mảng đã cập nhật vào "dataLogin"
      String updatedValue = jsonEncode(data);
      await secureStorage.write(key: "dataLogin", value: updatedValue);
      return data.isEmpty;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  // color: Colors.grey[800],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        margin:
                            const EdgeInsets.only(bottom: 5, right: 5, left: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(width: 0.2, color: greyColor)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: ExtendedImage.network(
                            dataLogin[widget.index]['show_url'] ??
                                linkAvatarDefault,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 250,
                          child: Text(
                            dataLogin[widget.index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: const Size.fromHeight(47),
                        backgroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      bool dataListIfEmpty = await deleteData(widget.index);
                      if (dataListIfEmpty) {
                        // ignore: use_build_context_synchronously
                        pushAndRemoveUntil(context, const MainLoginPage(null));
                      } else {
                        // ignore: use_build_context_synchronously
                        pushAndRemoveUntil(
                            context, const OnboardingLoginPage());
                      }
                    },
                    child: const Text(
                      'Gỡ trang cá nhân',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
