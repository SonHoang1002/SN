import 'package:flutter/material.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevate_button_widget.dart';
import 'password_login_page.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _onPhoneScreen = true;

  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _emailController = TextEditingController(text: "");
  List<String> _countryNumberCode = ["VN", "+84"];
/////////////////////////////////////////////////////////////
  ///         validate email ??
  ///
////////////////////////////////////////////////////////////
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
          // main content
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
                                  _onPhoneScreen
                                      ? PhoneLoginConstants.PHONE_LOGIN_TITLE[0]
                                      : PhoneLoginConstants
                                          .PHONE_LOGIN_TITLE[1],
                                  true,
                                  fontSize: 16,
                                  colorWord: blackColor,
                                  isCenterLeft: false),
                              buildSpacer(height: 10),

                              // input

                              _onPhoneScreen
                                  ? _buildTextFormField(
                                      _phoneController,
                                      PhoneLoginConstants
                                          .PHONE_LOGIN_PLACEHOLODER[0],
                                      isHavePrefix: true,
                                      numberType: true)
                                  : _buildTextFormField(
                                      _emailController,
                                      PhoneLoginConstants
                                          .PHONE_LOGIN_PLACEHOLODER[1]),
                              buildSpacer(height: 10),

                              // description or navigator button
                              _phoneController.text.trim().length > 0 ||
                                      _emailController.text.trim().length > 0
                                  ? buildButtonForLoginWidget(
                                      width: width,
                                      function: () {
                                        pushToNextScreen(
                                            context, PasswordLoginPage());
                                      })
                                  : Text(
                                      _onPhoneScreen
                                          ? PhoneLoginConstants
                                              .PHONE_LOGIN_DESCRIPTION[0]
                                          : PhoneLoginConstants
                                              .PHONE_LOGIN_DESCRIPTION[1],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: greyColor,
                                      ),
                                    ),
                              buildSpacer(height: 10),
                              // change status button
                              buildButtonForLoginWidget(
                                  bgColor: transparent,
                                  colorText: blackColor,
                                  width: width,
                                  isHaveBoder: true,
                                  title: _onPhoneScreen
                                      ? PhoneLoginConstants
                                              .PHONE_LOGIN_CHANGE_SELECTION_TEXT_BUTTON[
                                          0]
                                      : PhoneLoginConstants
                                          .PHONE_LOGIN_CHANGE_SELECTION_TEXT_BUTTON[1],
                                  function: () {
                                    setState(() {
                                      _onPhoneScreen = !_onPhoneScreen;
                                    });
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
              borderSide: const BorderSide(color: Colors.black, width: 0.4),
            ),
            hintText: placeHolder,
            hintStyle: const TextStyle(
              color: greyColor,
            ),
            prefix: isHavePrefix!
                ? GestureDetector(
                    onTap: () {
                      _showBottomSheetForCountryCodeNumberPhone(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Wrap(
                        children: [
                          Text(_countryNumberCode[0],
                              style: TextStyle(fontSize: 16, color: greyColor)),
                          Icon(
                            LoginConstants.DOWN_ICON_DATA,
                            color: greyColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(_countryNumberCode[1],
                              style: TextStyle(fontSize: 16, color: greyColor)),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            contentPadding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      ),
    );
  }

  _showBottomSheetForCountryCodeNumberPhone(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: transparent,
        context: context,
        builder: ((context) {
          return Container(
            height: 600,
            decoration: BoxDecoration(
                color: greyColor[300],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(
              children: [
                // drag and drop navbar
                Container(
                  padding: EdgeInsets.only(top: 5),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount:
                          PhoneLoginConstants.PHONE_LOGIN_LIST_PHONE.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _countryNumberCode = PhoneLoginConstants
                                  .PHONE_LOGIN_LIST_PHONE[index]
                                  .split(" ");
                            });
                            print(_countryNumberCode);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                      PhoneLoginConstants
                                          .PHONE_LOGIN_LIST_PHONE[index],
                                      style: TextStyle(
                                        // color:  white,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                )),
                                Divider(
                                  height: 2,
                                  color: white,
                                )
                              ],
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
          );
        }));
  }
}
