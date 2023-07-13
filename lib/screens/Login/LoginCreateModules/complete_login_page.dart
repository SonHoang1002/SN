import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/authen_api.dart';
import 'package:social_network_app_mobile/screens/Login/LoginCreateModules/save_login_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../widgets/have_account_widget.dart';
import 'main_login_page.dart';

class CompleteLoginPage extends StatefulWidget {
  final dynamic data;
  const CompleteLoginPage({super.key, this.data});

  @override
  State<CompleteLoginPage> createState() => _CompleteLoginPageState();
}

class _CompleteLoginPageState extends State<CompleteLoginPage> {
  bool _isLoading = false;

  handleRegisteration() async {
    context.loaderOverlay.show();
    var response = await AuthenApi().registrationAccount({
      ...widget.data,
      "agreement": 1,
      "username": widget.data['email'].split('@')[0]
    });
    if (response != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Chúng tôi đã gửi tin nhắn yêu cầu xác thực tài khoản vào hòm thư Email của bạn, vui lòng kiểm tra và làm theo hướng dẫn.")));
      // ignore: use_build_context_synchronously
      // pushAndReplaceToNextScreen(context, const MainLoginPage(null));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Đăng ký tài khoản thất bại, vui lòng thử lại")));
    }
    // ignore: use_build_context_synchronously
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
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
          bottomNavigationBar: SizedBox(
            height: 80,
            child: buildHaveAccountWidget(function: () {
              pushToNextScreen(context, const MainLoginPage(null));
            }),
          ),
          body: GestureDetector(
              onTap: (() {
                FocusManager.instance.primaryFocus!.unfocus();
              }),
              child: SingleChildScrollView(
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
                                    fontSize: 25,
                                    colorWord: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                    isCenterLeft: false),
                                buildSpacer(height: 20),
                                _buildDescription(),
                                buildSpacer(height: 30),
                                // button
                                SizedBox(
                                  height: 36,
                                  child: ButtonPrimary(
                                    fontSize: 18,
                                    label: _isLoading ? "" : "Tôi đồng ý",
                                    icon: _isLoading
                                        ? buildCircularProgressIndicator()
                                        : null,
                                    handlePress: () {
                                      handleRegisteration();
                                      pushToNextScreen(
                                          context, const SaveLoginPage());
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
              )),
        ));
  }

  Widget _buildDescription() {
    final subTitle = CompleteLoginConstants.COMPLETE_LOGIN_SUBTITLE;
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        text: subTitle[0],
        style: const TextStyle(color: greyColor, fontSize: 17),
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
          TextSpan(
            text: subTitle[7],
            style: const TextStyle(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: subTitle[8],
          ),
          TextSpan(
            text: subTitle[9],
            style: const TextStyle(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: subTitle[10],
          ),
          TextSpan(
            text: subTitle[11],
          ),
          TextSpan(
            text: subTitle[12],
            style: const TextStyle(color: primaryColor),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }
}
