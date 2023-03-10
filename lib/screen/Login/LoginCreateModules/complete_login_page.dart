import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/authen_api.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'main_login_page.dart';

class CompleteLoginPage extends StatelessWidget {
  final dynamic data;
  const CompleteLoginPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    handleRegistration() async {
      context.loaderOverlay.show();
      var response = await AuthenApi().registrationAccount(
          {...data, "agreement": 1, "username": data['email'].split('@')[0]});
      if (response != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Đăng ký tài khoản thành công, đăng nhập lại để sử dụng")));
        // ignore: use_build_context_synchronously
        pushAndReplaceToNextScreen(context, const MainLoginPage());
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Đăng ký tài khoản thất bại, vui lòng thử lại")));
      }
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Column(
                            children: [
                              buildTextContent(
                                  CompleteLoginConstants.COMPLETE_LOGIN_TITLE,
                                  true,
                                  fontSize: 16,
                                  colorWord: blackColor,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),
                              _buildDescription(),
                              buildSpacer(height: 10),
                              // button
                              buildButtonForLoginWidget(
                                  title: CompleteLoginConstants
                                      .COMPLETE_LOGIN_NAME_PLACEHOLODER,
                                
                                  function: () {
                                    pushAndReplaceToNextScreen(
                                        context, MainLoginPage());
                                  })
                            ],
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

  Widget _buildTextFormField(
      TextEditingController controller, String placeHolder,
      {double? borderRadius = 5,
      bool? isHavePrefix = false,
      bool? numberType = false}) {
    return Container(
      height: 40,
      child: TextFormField(
        controller: controller,
        onChanged: ((value) {}),
        validator: (value) {},
        keyboardType: numberType! ? TextInputType.number : TextInputType.text,
        maxLength: numberType ? 10 : 100000,
        decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
              borderSide: const BorderSide(color: greyColor, width: 0.2),
            ),
            hintText: placeHolder,
            hintStyle: const TextStyle(
              color: greyColor,
            ),
            contentPadding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      ),
    );
  }

  Widget _buildDescription() {
    final subTitle = CompleteLoginConstants.COMPLETE_LOGIN_SUBTITLE;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: subTitle[0],
        style: const TextStyle(color: greyColor),
        children: <TextSpan>[
          TextSpan(
            text: subTitle[1],
            style: TextStyle(color: primaryColor),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                ////////////////////////////////////////////////////////////
                // chuyen den trang dieu khoan cho nguoi dung nghien cuu
                ////////////////////////////////////////////////////////////
                print("trang dieu khoan");
              },
          ),
          TextSpan(text: subTitle[2]),
          TextSpan(
            text: subTitle[3],
            style: TextStyle(color: primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // chuyen den trang chinh sach du lieu cho nguoi dung nghien cuu
                print("trang chinh sach du lieu");
              },
          ),
          TextSpan(
            text: subTitle[4],
          ),
          TextSpan(
            text: subTitle[5],
            style: TextStyle(color: primaryColor),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                // chuyen den trang chinh sach cookie cho nguoi dung nghien cuu
                print("trang chinh sach cookie");
              },
          ),
          TextSpan(
            text: subTitle[6],
          ),
        ],
      ),
    );
  }
}
