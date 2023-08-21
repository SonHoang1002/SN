import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/unavailable_dialog.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});
  final TextEditingController emailController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Quên mật khẩu'),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Form(
          key: _formKey,
          child: Column(children: [
            // main content
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                // color: Colors.grey[900],
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Vui lòng nhập địa chỉ email để tìm kiếm tài khoản của bạn.",
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 0),
                          height: 50,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Hãy nhập đầy đủ thông tin';
                              }
                              final regex = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
                                  r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.'
                                  r'[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

                              if (!regex.hasMatch(value)) {
                                return 'Email không hợp lệ';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              hintText: "Email",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                          ),
                        ),
                        const Text(
                          "Bằng cách nhấn vào Tiếp tục, chúng tôi sẽ gửi vào email của bạn một tin nhắn xác nhận. Vui lòng đọc kĩ tin nhắn và thực hiện các bước tiếp theo theo hướng dẫn.",
                          style: TextStyle(color: greyColor, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonPrimary(
                          label: 'Lưu',
                          handlePress: () async {
                            if (_formKey.currentState!.validate()) {
                              var res = await UserPageApi().forgotPassword(
                                  {"email": emailController.text.trim()});
                              if (res != null &&
                                  res["success"] != null &&
                                  res["success"] == true) {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const UnavailableDialog(); // Sử dụng lớp UnavailableDialog ở đây
                                    },
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  switch (res["content"]["error"]) {
                                    case "No such email.":
                                      buildSnackBar(context,
                                          "Không tìm thấy tài khoản, vui lòng kiểm tra lại địa chỉ email đã nhập.");
                                      break;
                                    default:
                                      buildSnackBar(context,
                                          "Có lỗi sảy ra, hãy thử lại sau");
                                      break;
                                  }
                                }
                              }
                            }
                          },
                        ),
                        ButtonPrimary(
                          label: 'Huỷ',
                          isGrey: true,
                          handlePress: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
