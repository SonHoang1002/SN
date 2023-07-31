import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/apis/authen_api.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';
import 'package:social_network_app_mobile/widgets/text_form_field_custom.dart';

import '../../../constant/login_constants.dart';
import '../../../widgets/appbar_title.dart';
import '../../../widgets/back_icon_appbar.dart';

class ConfirmForgotPage extends StatefulWidget {
  const ConfirmForgotPage({super.key});

  @override
  State<ConfirmForgotPage> createState() => _ConfirmForgotPageState();
}

class _ConfirmForgotPageState extends State<ConfirmForgotPage> {
  late double width = 0;
  late double height = 0;
  String email = '';
  bool isNext = false;
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;

    handleSeedDataEmail() async {
      setState(() {
        isLoad = true;
      });
      dynamic response;
      var data = {"email": email};
      if (isNext) {
        response = await AuthenApi().forgotPassword(data);
      } else {
        response = await AuthenApi().reconfirmationEmail(data);
      }
      setState(() {
        isLoad = false;
      });
      if (response != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đã gửi mail xác nhận tới $email")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: primaryColor,
            content: Text("Không thể gửi mail xác nhận tới $email")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(
                title: ConfirmLoginConstants.CONFIRM_LOGIN_APPBAR_TITLE),
            Container()
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: Column(children: [
                              const Text(
                                "Vui lòng nhập địa chỉ email để tìm kiếm tài khoản của bạn",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              const CrossBar(
                                height: 1,
                              ),
                              TextFormFieldCustom(
                                  autofocus: true,
                                  hintText: "Địa chỉ Email",
                                  handleGetValue: (value) {
                                    setState(() {
                                      email = value;
                                      isNext = false;
                                    });
                                  }),
                              const SizedBox(
                                height: 8,
                              ),
                              const TextDescription(
                                  description:
                                      "Bằng cách nhấn vào Tiếp tục, chúng tôi sẽ gửi vào email của bạn một tin nhắn xác nhận. Vui lòng đọc kĩ tin nhắn và thực hiện các bước tiếp theo theo hướng dẫn.")
                            ])),
                        const CrossBar(
                          height: 1,
                        ),
                        SizedBox(
                          height: 36,
                          child: ButtonPrimary(
                            label: isNext ? 'Gửi lại' : 'Tiếp tục',
                            colorText: white,
                            handlePress: email.trim().isNotEmpty
                                ? isLoad
                                    ? null
                                    : () {
                                        setState(() {
                                          isNext = true;
                                        });
                                        handleSeedDataEmail();
                                      }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
