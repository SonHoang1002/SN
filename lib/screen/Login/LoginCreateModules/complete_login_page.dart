import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/authen_api.dart';
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
        pushAndReplaceToNextScreen(context, const MainLoginPage(null));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Đăng ký tài khoản thất bại, vui lòng thử lại")));
      }
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
    }

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: CupertinoActivityIndicator(),
        ),
        child: Scaffold(
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
                                    fontSize: 17,
                                    colorWord: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                    isCenterLeft: false),
                                buildSpacer(height: 10),
                                _buildDescription(),
                                buildSpacer(height: 10),
                                // button

                                SizedBox(
                                  height: 36,
                                  child: ButtonPrimary(
                                    label: "Hoàn tất",
                                    handlePress: () {
                                      handleRegistration();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
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
            style: const TextStyle(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(text: subTitle[2]),
          TextSpan(
            text: subTitle[3],
            style: const TextStyle(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: subTitle[4],
          ),
          TextSpan(
            text: subTitle[5],
            style: const TextStyle(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: subTitle[6],
          ),
        ],
      ),
    );
  }
}
