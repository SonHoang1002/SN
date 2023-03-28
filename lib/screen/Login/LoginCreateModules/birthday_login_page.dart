import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

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
  final dynamic data;
  const BirthdayLoginPage({super.key, this.data});

  @override
  State<BirthdayLoginPage> createState() => _BirthdayLoginPageState();
}

class _BirthdayLoginPageState extends State<BirthdayLoginPage> {
  late double width = 0;

  late double height = 0;
  bool _isValid = true;
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
      bottomNavigationBar: SizedBox(
        height: 80,
        child: buildHaveAccountWidget(function: () {
          pushToNextScreen(context, const MainLoginPage());
        }),
      ),
      body: GestureDetector(
        onTap: (() {
          hiddenKeyboard(context);
        }),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  children: [
                    buildTextContent(
                        BirthDayLoginConstants.BIRTHDAY_LOGIN_TITLE, true,
                        fontSize: 17, isCenterLeft: false),
                    buildSpacer(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 0.2, color: greyColor)),
                      child: GeneralComponent(
                        [
                          buildTextContent(
                              _timeComponent.isEmpty
                                  ? BirthDayLoginConstants
                                      .BIRTHDAY_LOGIN_NAME_PLACEHOLODER
                                  : "${_timeComponent[0]} tháng ${_timeComponent[1]}, ${_timeComponent[2]}",
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
                            BirthDayLoginConstants.NOT_OLD_ENOUGH,
                            true,
                            fontSize: 13,
                            isCenterLeft: false,
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
                    buildSpacer(height: 10),
                    _isValid && _timeComponent.isNotEmpty
                        ? SizedBox(
                            height: 36,
                            child: ButtonPrimary(
                              label: "Tiếp tục",
                              handlePress: () {
                                // popToPreviousScreen(context);
                                pushToNextScreen(
                                    context,
                                    GenderLoginPage(data: {
                                      ...widget.data,
                                      "birth_date": '${_timeComponent[0]}',
                                      "birth_month": '${_timeComponent[1]}',
                                      "birth_year": "${_timeComponent[2]}",
                                    }));
                                return;
                              },
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkValidTime() {
    final currentTime = DateTime.now();

    if (_timeComponent.isNotEmpty) {
      if (_timeComponent[2] < currentTime.year - 13) {
        setState(() {
          _isValid = true;
        });
      } else if (_timeComponent[2] == currentTime.year - 13) {
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

  _showPickerModalBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) {
          return SizedBox(
            height: 220,
            child: StatefulBuilder(builder: (context, setStateFull) {
              return Column(children: [
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    dateOrder: DatePickerDateOrder.dmy,
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
