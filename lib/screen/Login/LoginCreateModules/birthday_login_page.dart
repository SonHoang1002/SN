import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';

import '../../../constant/login_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/have_account_widget.dart';
import 'gender_login_page.dart';
import 'main_login_page.dart';

class BirthdayLoginPage extends StatefulWidget {
  @override
  State<BirthdayLoginPage> createState() => _BirthdayLoginPageState();
}

class _BirthdayLoginPageState extends State<BirthdayLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _isValid = true;
  // TextEditingController _birthdayController = TextEditingController(text: "");
  late List<int> _timeComponent = [];
  bool isFillAll = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    checkValidTime();
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
              // padding: EdgeInsets.symmetric(vertical: 5),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // img
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Column(
                          children: [
                            buildTextContent(
                                BirthDayLoginConstants.BIRTHDAY_LOGIN_TITLE,
                                true,
                                fontSize: 16,
                                colorWord: blackColor,
                                isCenterLeft: false),
                            buildSpacer(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 0.2, color: greyColor)),
                              child: GeneralComponent(
                                [
                                  buildTextContent(
                                      _timeComponent.length == 0
                                          ? BirthDayLoginConstants
                                              .BIRTHDAY_LOGIN_NAME_PLACEHOLODER
                                          : "ngày ${_timeComponent[0]} tháng ${_timeComponent[1]}, ${_timeComponent[2]}",
                                      false,
                                      fontSize: 16,
                                      colorWord: greyColor)
                                ],
                                suffixWidget: const Icon(
                                  LoginConstants.DOWN_ICON_DATA,
                                  color: greyColor,
                                ),
                                changeBackground: transparent,
                                function: () {
                                  _showPickerModalBottomSheet(context);
                                },
                              ),
                            ),
                            buildSpacer(height: 5),
                            !_isValid
                                ? buildTextContent(
                                    BirthDayLoginConstants
                                        .BIRTHDAY_LOGIN_WARNING,
                                    true,
                                    fontSize: 13,
                                    colorWord: Colors.red,
                                  )
                                : const SizedBox(),
                            buildSpacer(height: 10),
                            Text(
                              BirthDayLoginConstants.BIRTHDAY_LOGIN_SUBTITLE,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: greyColor,
                              ),
                            ),
                            buildTextContent(
                              BirthDayLoginConstants.BIRTHDAY_LOGIN_QUESTION,
                              true,
                              fontSize: 16,
                              colorWord: blackColor,
                              isCenterLeft: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildHaveAccountWidget(function: () {
            pushToNextScreen(context, MainLoginPage());
          })
        ]),
      ),
    );
  }

  checkValidTime() {
    final currentTime = DateTime.now();

    if (_timeComponent.length > 0) {
      if (_timeComponent[2] < currentTime.year) {
        setState(() {
          _isValid = true;
        });
      } else if (_timeComponent[2] == currentTime.year) {
        if (_timeComponent[1] < currentTime.month) {
          setState(() {
            _isValid = true;
          });
        } else if (_timeComponent[1] == currentTime.month) {
          if (_timeComponent[0] < currentTime.day) {
            setState(() {
              _isValid = true;
            });
          } else {
            setState(() {
              _isValid = false;
            });
          }
        } else {
          setState(() {
            _isValid = false;
          });
        }
      } else {
        setState(() {
          _isValid = false;
        });
      }
    }
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String placeHolder, {
    double? borderRadius = 5,
  }) {
    return Container(
      height: 50,
      child: TextFormField(
        controller: controller,
        onChanged: ((value) {}),
        validator: (value) {},
        readOnly: true,
        decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
              borderSide: const BorderSide(color: greyColor, width: 2),
            ),
            hintText: placeHolder,
            hintStyle: const TextStyle(
              color: greyColor,
            ),
            suffix: const Icon(
              LoginConstants.DOWN_ICON_DATA,
              color: greyColor,
              size: 10,
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 30),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      ),
    );
  }

  _showPickerModalBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        backgroundColor: greyColor[300],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) {
          return Container(
            height: 220,
            child: StatefulBuilder(builder: (context, setStateFull) {
              return Column(children: [
                Container(
                  height: 40,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10),
                      child: buildTextContentButton("Tiếp tục", true,
                          colorWord: _isValid
                              ? blackColor
                              : blackColor.withOpacity(0.4), function: () {
                        if (_isValid) {
                          popToPreviousScreen(context);
                          pushToNextScreen(context, GenderLoginPage());
                          return;
                        }
                        popToPreviousScreen(context);
                      }),
                    ),
                  ]),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      _timeComponent = [value.day, value.month, value.year];
                      setStateFull(() {});
                      setState(() {});
                    },
                    initialDateTime: DateTime.now(),
                  ),
                )
              ]);
            }),
          );
        });
  }
}
