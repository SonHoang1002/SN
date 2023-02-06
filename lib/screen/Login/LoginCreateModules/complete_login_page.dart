import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/build_elevateButton_widget.dart';
import 'main_login_page.dart';

class CompleteLoginPage extends StatefulWidget {
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
                              buildElevateButtonWidget(
                                  title: CompleteLoginConstants
                                      .COMPLETE_LOGIN_NAME_PLACEHOLODER,
                                  width: width,
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
        style: TextStyle(color: greyColor),
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
