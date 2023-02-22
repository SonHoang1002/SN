import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import 'main_login_page.dart';

class CompleteLoginPage extends StatefulWidget {
  const CompleteLoginPage({super.key});

  @override
  State<CompleteLoginPage> createState() => _CompleteLoginPageState();
}

class _CompleteLoginPageState extends State<CompleteLoginPage> {
  late double width = 0;
  late double height = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

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
                                colorWord: blackColor,
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
                                  pushAndReplaceToNextScreen(
                                      context, const MainLoginPage());
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
