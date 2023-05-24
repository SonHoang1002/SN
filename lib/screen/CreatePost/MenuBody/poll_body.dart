import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/refractor_time.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class PollBody extends StatefulWidget {
  final Function handleUpdateData;
  final dynamic poll;
  final String type;
  const PollBody(
      {Key? key, required this.handleUpdateData, this.poll, required this.type})
      : super(key: key);

  @override
  State<PollBody> createState() => _PollBodyState();
}

class _PollBodyState extends State<PollBody> {
  List<bool> _settingStatusList = [true, true];

  final _timeMenuList = [
    {"key": "5_minutes", 'time': "5 phút", "value": 5 * 60},
    {"key": "30_minutes", 'time': "30 phút", "value": 30 * 60},
    {"key": "1_hour", 'time': "1 giờ", "value": 1 * 60 * 60},
    {"key": "6_hours", 'time': "6 giờ", "value": 6 * 60 * 60},
    {"key": "1_day", 'time': "1 ngày", "value": 1 * 24 * 60 * 60},
    {"key": "3_days", 'time': "3 ngày", "value": 3 * 24 * 60 * 60},
    {"key": "7_days", 'time': "7 ngày", "value": 7 * 24 * 60 * 60},
  ];
  List<dynamic> _selectionList = [
    {
      'key': "sel_0",
      "inputController": TextEditingController(text: ""),
      'image': null,
    },
    {
      'key': "sel_1",
      "inputController": TextEditingController(text: ""),
      'image': null,
    }
  ];
  dynamic _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.poll != null) {
      _selectedTime = _timeMenuList
          .firstWhere((e) => e['value'] == widget.poll["expires_in"]);
      _selectionList = [];
      for (int i = 0; i < widget.poll['options'].length; i++) {
        _selectionList.add({
          'key': "sel_$i",
          "inputController":
              TextEditingController(text: widget.poll['options'][i]),
          'image': null,
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  handleSetData() {
    final pollData = {
      "expires_in": 0,
      "multiple": _settingStatusList[1],
      "options": _selectionList.map((e) => e["inputController"].text).toList(),
    };
    {
      // "id": "97",
      // "expires_at": "2023-05-30T22:30:28.876+07:00",
      // "expired": false,
      // "multiple": true,
      // "votes_count": 0,
      // "voters_count": 4,
      // "voted": true,
      // "own_votes": [],
      // "options": [
      //   {
      //     "title": "1",
      //     "votes_count": 0
      //   },
      //   {
      //     "title": "2",
      //     "votes_count": 0
      //   }
      // ],
      // "emojis": []
    }

    if (_selectedTime != null && _selectedTime.isNotEmpty) {
      int timeCount;
      switch (_selectedTime["key"]) {
        case "5_minutes":
          timeCount = _selectedTime['value'];
          break;
        case "30_minutes":
          timeCount = _selectedTime['value'];
          break;
        case "1_hour":
          timeCount = _selectedTime['value'];
          break;
        case "6_hours":
          timeCount = _selectedTime['value'];
          break;
        case "1_day":
          timeCount = _selectedTime['value'];
          break;
        case "3_days":
          timeCount = _selectedTime['value'];
          break;
        case "7_days":
          timeCount = _selectedTime['value'];
          break;
        default:
          timeCount = 0;
          break;
      }
      pollData["expires_in"] = timeCount;
    }

    widget.handleUpdateData('update_poll', pollData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const marginHorizontal = EdgeInsets.symmetric(
      horizontal: 8.0,
    );
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: buildTextContent(
              "Lựa chọn thăm dò ý kiến",
              true,
              fontSize: 15,
            ),
          ),
          buildSpacer(height: 10),
          SizedBox(
            height: _selectionList.length * 50,
            child: ListView.builder(
                itemCount: _selectionList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = _selectionList[index];
                  return Container(
                    margin: marginHorizontal,
                    decoration: const BoxDecoration(),
                    child: _buildInputPoll(index, data["inputController"],
                        "Lựa chọn ${index + 1}"),
                  );
                }),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectionList.add({
                  'key': "sel_${_selectionList.length + 1}",
                  "inputController": TextEditingController(text: ""),
                  'image': null,
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(width: 0.4, color: greyColor)),
              padding: const EdgeInsets.all(10),
              margin: marginHorizontal,
              child: buildTextContent(
                  "+ Thêm lựa chọn thăm dò ý kiến...", false,
                  fontSize: 17),
            ),
          ),
          buildSpacer(height: 10),
          Container(
            margin: marginHorizontal,
            child: Column(
              children: [
                buildTextContent("Cài đặt", true, fontSize: 15),
                _builsTimeSelection(
                  context,
                  "Thời hạn thăm dò",
                  "Chọn khung giờ",
                ),
                // delay về sau thông nhất sau có thuộc tính này không
                // _buildSetting("Cho phép thành viên thêm lựa chọn", 0),
                // buildDivider(color: greyColor),
                _buildSetting("Cho phép mọi người có nhiều lựa chọn", 1),
                SizedBox(
                    height: 40,
                    child: ButtonPrimary(
                        label: "Xong",
                        handlePress: () {
                          handleSetData();
                        })),
                buildSpacer(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputPoll(
      int index, TextEditingController controller, String hintText,
      {double? height, TextInputType? keyboardType, Function? suffixFunction}) {
    return Row(
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: height ?? 40,
            child: TextFormField(
              controller: controller,
              maxLines: null,
              keyboardType: keyboardType ?? TextInputType.text,
              onChanged: (value) {},
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: red),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                prefixIcon: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                // suffixIcon: Container(
                //   padding: const EdgeInsets.all(10),
                //   child: SvgPicture.asset(
                //     "assets/icons/add_img_file_icon.svg",
                //     width: 10,
                //     height: 10,
                //     color: Theme.of(context).textTheme.bodyLarge!.color,
                //   ),
                // ),
                hintText: hintText,
              ),
            ),
          ),
        ),
        _selectionList.length != 1
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _selectionList.removeAt(index);
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                  size: 25,
                ))
            : const SizedBox()
      ],
    );
  }

  Widget _buildSetting(
    String title,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Flexible(child: buildTextContent(title, false, fontSize: 15)),
          CupertinoSwitch(
              value: _settingStatusList[index],
              onChanged: (value) {
                setState(() {
                  _settingStatusList[index] = value;
                });
              })
        ],
      ),
    );
  }

  Widget _builsTimeSelection(
    BuildContext context,
    String title,
    String titleForBottomSheet,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              _selectedTime != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: buildTextContent(
                          _selectedTime['time'].toString(), true,
                          fontSize: 14),
                    )
                  : const SizedBox()
            ],
            suffixWidget: const SizedBox(
              height: 40,
              width: 40,
              child: Icon(
                FontAwesomeIcons.caretDown,
                size: 18,
              ),
            ),
            changeBackground: transparent,
            padding: const EdgeInsets.all(5),
            isHaveBorder: true,
            function: () {
              showCustomBottomSheet(context, 500, titleForBottomSheet,
                  widget: SizedBox(
                      height: 400,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _timeMenuList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GeneralComponent(
                                  [
                                    buildTextContent(
                                        _timeMenuList[index]["time"].toString(),
                                        false)
                                  ],
                                  changeBackground: transparent,
                                  function: () async {
                                    setState(() {
                                      _selectedTime = _timeMenuList[index];
                                    });
                                    popToPreviousScreen(context);
                                  },
                                ),
                                buildDivider(color: greyColor)
                              ],
                            );
                          })));
            },
          ),
        ],
      ),
    );
  }
}
