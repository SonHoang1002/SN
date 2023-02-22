import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import 'password_login_page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _onPhoneScreen = false;

  String _phoneController = '';
  String _emailController = '';
  List<String> _countryNumberCode = ["VN", "+84"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    checkIsValid() {
      if (_onPhoneScreen && _phoneController.trim().isEmpty) {
        return true;
      } else if (!_onPhoneScreen && _emailController.trim().isEmpty) {
        return true;
      } else {
        return false;
      }
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
          // main content
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
                                _onPhoneScreen
                                    ? PhoneLoginConstants.PHONE_LOGIN_TITLE[0]
                                    : PhoneLoginConstants.PHONE_LOGIN_TITLE[1],
                                true,
                                fontSize: 17,
                                isCenterLeft: false),
                            buildSpacer(height: 15),

                            // input

                            _onPhoneScreen
                                ? _buildTextFormField((value) {
                                    setState(() {
                                      _phoneController = value;
                                    });
                                  },
                                    PhoneLoginConstants
                                        .PHONE_LOGIN_PLACEHOLODER[0],
                                    isHavePrefix: true,
                                    numberType: true)
                                : _buildTextFormField((value) {
                                    setState(() {
                                      _emailController = value;
                                    });
                                  },
                                    PhoneLoginConstants
                                        .PHONE_LOGIN_PLACEHOLODER[1]),
                            buildSpacer(height: 15),

                            // description or navigator button

                            Text(
                              _onPhoneScreen
                                  ? PhoneLoginConstants
                                      .PHONE_LOGIN_DESCRIPTION[0]
                                  : PhoneLoginConstants
                                      .PHONE_LOGIN_DESCRIPTION[1],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: greyColor,
                              ),
                            ),
                            buildSpacer(height: 15),
                            // change status button
                            SizedBox(
                              height: 36,
                              child: ButtonPrimary(
                                isPrimary: true,
                                label: _onPhoneScreen
                                    ? PhoneLoginConstants
                                            .PHONE_LOGIN_CHANGE_SELECTION_TEXT_BUTTON[
                                        0]
                                    : PhoneLoginConstants
                                        .PHONE_LOGIN_CHANGE_SELECTION_TEXT_BUTTON[1],
                                handlePress: () {
                                  setState(() {
                                    _onPhoneScreen = !_onPhoneScreen;
                                  });
                                },
                              ),
                            ),

                            buildSpacer(height: 15),
                            // change status button
                            checkIsValid()
                                ? const SizedBox()
                                : SizedBox(
                                    height: 36,
                                    child: ButtonPrimary(
                                      label: "Tiếp tục",
                                      handlePress: () {
                                        pushAndReplaceToNextScreen(
                                            context, const PasswordLoginPage());
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

  Widget _buildTextFormField(Function handleUpdate, String placeHolder,
      {double? borderRadius = 5,
      bool? isHavePrefix = false,
      bool? numberType = false}) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        onChanged: ((value) {
          handleUpdate(value);
        }),
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
                              style: const TextStyle(
                                  fontSize: 16, color: greyColor)),
                          const Icon(
                            LoginConstants.DOWN_ICON_DATA,
                            color: greyColor,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(_countryNumberCode[1],
                              style: const TextStyle(
                                  fontSize: 16, color: greyColor)),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
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
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(
              children: [
                // drag and drop navbar
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: const BoxDecoration(
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
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
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
                                      style: const TextStyle(
                                        // color:  white,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                )),
                                const Divider(
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
